USE [dhdcdtw_dev]
GO

/****** Object:  StoredProcedure [fp_test].[MP_Create_Object_From_Registry]    Script Date: 11/26/2013 15:55:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [fp_test].[MP_Create_Object_From_Registry]
@TargetDBLocation nvarchar(255)
, @SourceDBLocation nvarchar(255) = NULL
, @JoinFilter nvarchar(1000) = ''
, @Criteria nvarchar(1000) = ''
, @Schema nvarchar(15) = 'fp_test'

AS

SET @SourceDBLocation = isnull(@SourceDBLocation, 'dhdcdtw_dev')
SET @Criteria = CASE WHEN isnull(@Criteria, '') = '' THEN '' ELSE replace(@Criteria,'WHERE ','AND ') END

DECLARE @SQL nvarchar(max)
, @ExecuteSQL nvarchar(500)


SET @SQL = '
DECLARE @DefSQL NVARCHAR(4000)

DECLARE DefinitionResolver CURSOR FOR
SELECT reg_Object_Definition
FROM '+@SourceDBLocation+'.'+@Schema+'.v_0399_Required_Deployables AS vw
LEFT OUTER JOIN sys.all_objects AS obj
ON obj.name = vw.reg_Object_Name
'+@JoinFilter+'
WHERE obj.object_ID IS NULL
'+@Criteria+'

OPEN DefinitionResolver

FETCH NEXT FROM DefinitionResolver
INTO @DefSQL

WHILE @@FETCH_STATUS = 0

BEGIN

EXEC sp_executeSQL @DefSQL

FETCH NEXT FROM DefinitionResolver
INTO @DefSQL

END

CLOSE DefinitionResolver
DEALLOCATE DefinitionResolver
' SET @ExecuteSQL = @TargetDBLocation+'..sp_executesql' 
EXEC @ExecuteSQL @SQL  
PRINT @SQL






GO

/****** Object:  StoredProcedure [fp_test].[MP_DataDiver_2021]    Script Date: 11/26/2013 15:55:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------
---	MP_DataDiver_2021: A procedure which seeks tables in which a given data value is present	---
---	20130828:4est																				---
---																								---
---	This procedure will search through all tables covered by the provided criteria for a data	---
---	value sought by the user. Data values must be of a type and exist within a column whose		---
---	data type is searchable - certain types such as text, guid, geospatial, image or certain	---
---	datetime formats are inheirently excluded.													---
---																								---
---	@TargetDBLocation is the only strictly required parameter, although under most contexts	the	---
---	procedure will fail if all 3 of the primary search criteria are omitted. These include the	---
---	following:																					---
---																								---
---	*	@Value - The specific data value sought; e.g. '#PASNXD0' - a primary source system.	---
---																								---
---	*	@ColumnName - The name or approximation columns to search - 'Med%Rec%No' for example.	---
---																								---
---	*	@TargetSchema - Can be presented as a multi-valued comma-seperated list.				---
---																								---
---	Secondary criteria which are optinal further refine search scope, or define execution		---
---	behavior. These are generally only available by manually executing this procedure from SMSS	---
--- or other explicitly executed SQL command. They inlcude the following:						---
---																								---
---	*	@ColumnType - the system data-type name for the column; for example the value '00359'	---
---		is given but it's context is unknown. If "0" precedes other integers, then the type		---
---		must be one of char/nchar/varchar/nvarchar (text is not searchable without conversions)	---
---																								---
---	*	@ExecuteStatus - [0 - 2] defines execute state: 0 Print Only, 1 Print & Execute,		---
---		2 Execute Only. The default is Print and Execute. This will slow down results, but		---
---		allows for developers or power-users to see the code that is actually processed. Set	---
---		this parameter to 2 for SSRS reports, or inter-dependent processes which will integrate	---
---		results from this procedure into other code.											---
---																								---
---	*	@ForceExecute - The procedure will terminate with errors if the search criteria is too	---
---		broad to return results in a reasonable time. The default setting is 0/False/Off. It is	---
---		a tinyint datatype, but is used as a bit/boolean value. This option should generally be	---
---		avoided.																				---
---																								---
---	The following parameters are reserved for future use and are part of the standard set for	---
---	catalog procedures. @SourceSchema and @SourceDBLocation - define where results should be	---
---	returned (if applicable). Both default to the current location of the cataloging program.	---
---																								---
---	This procedure can perform other functions by omitting certain criteria, such as returning	---
--- the row-counts of all tables within a database/schema set (omit @value and @ColumnName).	---
---	This is not an optimal use of this query however and is not recommended.					---
---																								---
---	Happy Diving!																				---
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
CREATE PROCEDURE [fp_test].[MP_DataDiver_2021]
@TargetDBLocation nvarchar(200)
, @TargetSchema nvarchar(25) = NULL
, @SourceDBLocation nvarchar(200) = 'dhdcdtw_dev'
, @SourceSchema nvarchar(25) = 'fp_test'
, @Value nvarchar(255) = NULL
, @ColumnName nvarchar(255) = NULL
, @ColumnType nvarchar(60) = NULL
, @ExecuteStatus tinyint = 1
, @ForceExecute int = 0

AS

/* Prevent query from further execution if NO criteria are provided. ForceExecute flag should NOT
	be considered as a valid escape from this check. */
IF (@Value IS NULL AND @ColumnName IS NULL AND @ColumnType IS NULL AND @TargetSchema IS NULL)
BEGIN
	RAISERROR('You must supply search criteria!', 0, 0) GOTO Abend
END

/* Set all open criteria variables to empty string instead of blank or NULL - these are used in "Like" clauses */
SET @ColumnName = ISNULL(@ColumnName,'')
SET @Value = ISNULL(@Value,'')

/* Set all discrete criteria variables to 'All' instead of blank or NULL - these are used in multi-value lookups */
SET @ColumnType = ISNULL(@ColumnType,'All')
SET @TargetSchema = ISNULL(@TargetSchema, 'All')


DECLARE @Schema nvarchar(255)
, @TableName nvarchar(255)
, @ObjectID int
, @TableLast nvarchar(500)
, @SeekColumn varchar(255)
, @Sql nvarchar(max)
, @Rid smallint
, @ExecuteSQL nvarchar(500)


/* Create a table variable for storing search results for end users, or to be accessed by advanced search procedures */
CREATE TABLE #TblList (TableID int identity(1,1), TableName nvarchar(255), ObjectID int, HitCount int)


/* Initialize a cursor to process all table/column combinations that fit the base search criteria */
DECLARE tableresolver CURSOR FOR
SELECT DISTINCT obj.Object_id, scm.name, obj.name, clm.name
FROM sys.all_objects AS obj
JOIN sys.all_columns AS clm
ON clm.object_id = obj.object_id
JOIN sys.schemas AS scm
ON scm.schema_id = obj.schema_id
JOIN sys.types AS typ
ON clm.system_type_id = typ.system_type_id
WHERE obj.type IN ('U','V')
AND	(@TargetSchema ='All' OR CHARINDEX(scm.name, @TargetSchema) > 0)
AND clm.name LIKE '%'+@ColumnName+'%'
AND	(@ColumnType ='All' OR CHARINDEX(typ.name, @ColumnType) > 0)
ORDER BY scm.name, obj.name, clm.name
 
OPEN tableresolver

FETCH NEXT FROM tableresolver
INTO @ObjectID, @Schema, @TableName, @SeekColumn

SET @TableLast = @Schema+'.'+@TableName
SET @rid = 0

/* Test for large search sets and force users or processes with poorly written calls to reconsider criteria due to query impact */
IF @@CURSOR_ROWS > 10000 AND (@ColumnName = '' OR @ColumnType = 'ALL' OR @TargetSchema = 'ALL') AND @ForceExecute = 0
BEGIN
	RAISERROR('Search criteria is very broad - consider searching on column names, types, or confine your search to a target schema, or use @ForceExecute = 1', 0, 0)
	CLOSE tableresolver
	DEALLOCATE tableresolver
	GOTO Abend
END

WHILE @@FETCH_STATUS = 0 
BEGIN

	/* This code sets up the seek for execution - There is a weakness in that if a column list for
		the table is > 3980 characters, only the early subset of columns will be checked. This *may*
		produce inaccurate results for very large table and will be addressed in future upgrades 
		-- 20130828:4est */

	IF @TableLast <> @Schema+'.'+@TableName
	OR (@TableLast = @Schema+'.'+@TableName
		AND (len(@Sql) + len(' or ['+@SeekColumn+'] like ''%'+@Value+'%''') > 3980)
		)
	BEGIN

		/* Only insert values which have hits  */
		SET @Sql = @Sql  + ' HAVING count(*) > 0;'

		/* This code selectively prints/executes the procedure: 0 for print only
		, 1 for print and execute (manual or debug runs)
		, 2 for execute only (reporting/production execution) 
		-- 20130828:4est */
		IF @ExecuteStatus in (0,1)
		BEGIN
			PRINT 'INSERT INTO #TblList (TableName, ObjectID, HitCount)' + @SQl
		END

		IF @ExecuteStatus in (1,2)
		BEGIN
			INSERT INTO #TblList (TableName, ObjectID, HitCount)
			EXEC sp_executeSQL @SQL
		END
	
		SET @TableLast = @Schema+'.'+@TableName
		SET @Rid = 0
	END

	IF @TableLast = @Schema+'.'+@TableName
	AND @Rid = 0 
	BEGIN
		SET @sql = '
		SELECT '''+@Schema+'.'+@TableName+''', '''+cast(@ObjectID as varchar)+''', count(*)
		FROM ['+@TargetDBLocation+'].['+@Schema+'].['+@TableName+'] AS tbl with(nolock)
		WHERE ['+@SeekColumn+'] like ''%'+@Value+'%'''
	END

	IF @TableLast = @Schema+'.'+@TableName
		AND len(@Sql) < 3980 - len(' or ['+@SeekColumn+'] like ''%'+@Value+'%''')
		AND @Rid > 0
	BEGIN
		SET @Sql = @Sql + ' or ['+@SeekColumn+'] like ''%'+@Value+'%'''
	END
	
FETCH NEXT FROM tableresolver
INTO @ObjectID, @Schema, @TableName, @SeekColumn

SET @rid = @rid+1

END
CLOSE tableresolver
DEALLOCATE tableresolver

DECLARE @TblList TABLE (TableID int, TableName nvarchar(255), ObjectID int, HitCount int)

INSERT INTO @TblList (TableID, TableName, ObjectID, HitCount) SELECT TableID, TableName, ObjectID, HitCount FROM #TblList

SELECT TableID, TableName, ObjectID, HitCount
FROM @TblList

GOTO Goodend

Abend:
PRINT 'Search Aborted - One or more criteria not set, or potential timeout detected'

Goodend:
PRINT 'Search Success'

GO

/****** Object:  StoredProcedure [fp_test].[MP_String_Dicer]    Script Date: 11/26/2013 15:55:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [fp_test].[MP_String_Dicer]
@StringSource NVARCHAR(max)
, @ObjectID NVARCHAR(255)
, @SearchCase NVARCHAR(max)
, @RightBound NVARCHAR(max) = NULL
, @Precision TINYINT = 2

AS

SET @RightBound = ISNULL(@RightBound,'')

PRINT @SearchCase
PRINT @RightBound

DECLARE @StringSegment NVARCHAR(4000)
, @StringLen int
, @ObjectName nvarchar(255)
, @BoundIndex int
, @SeekIndex int
, @SegmentID int
, @SegmentRank int

DECLARE @RequiredStringSearch TABLE (ObjectID INT, SegmentID INT, SegmentRank INT, SearchCase NVARCHAR(max), AnchorPosition INT, RangePosition INT, StringPattern NVARCHAR(max))

SET @SegmentID = 0
SET @SegmentRank = 0
SET @StringLen = DATALENGTH(@StringSource)

WHILE @StringLen > 0
	AND (PATINDEX('%'+@SearchCase+'%', @StringSource) > 0
	OR @SegmentRank > 0)
    BEGIN

		/* Precision 1 - Wildcard matching throughout string and search case 
			- non-alphanumeric charcters replaced with wild-cards - other methods may be adapted. */
        IF @Precision = 1
        BEGIN

        SELECT @SearchCase = REPLACE(@SearchCase, SUBSTRING(@SearchCase, PATINDEX('%[^0-9a-zA-Z]%', @SearchCase), 1), '%')
        SELECT @RightBound = ISNULL(REPLACE(@RightBound, SUBSTRING(@RightBound, PATINDEX('%[^0-9a-zA-Z]%', @RightBound), 1), '%'),'')

		
        SELECT @SeekIndex = CASE WHEN @SegmentRank > 0 
								OR PATINDEX('%'+@SearchCase+'%', @StringSource) = 1 THEN 1
								ELSE 0 END
	                                
        SELECT @BoundIndex = CASE WHEN @SeekIndex = 0 THEN CASE
								WHEN PATINDEX('%'+@SearchCase+'%', @StringSource) BETWEEN 2 AND 4000
								THEN PATINDEX('%'+@SearchCase+'%', @StringSource)
									ELSE 4001 END
								WHEN @SeekIndex = 1	THEN CASE
								/* Upper Bound exists between Search Case and lesser of 4000 or Lower Bound */
								WHEN PATINDEX('%'+@RightBound+'%', @StringSource) > PATINDEX('%'+@SearchCase+'%', @StringSource)
								AND PATINDEX('%'+@RightBound+'%', @StringSource) <= 4000
								THEN PATINDEX('%'+@RightBound+'%', @StringSource)
								/* Terminal Index must match remainder of string length, or invalid segment parsing occurs*/
								WHEN PATINDEX('%'+@RightBound+'%', @StringSource) = 0
								AND LEN(@StringSource) - PATINDEX('%'+@RightBound+'%', @StringSource) <= 4000
								THEN LEN(@StringSource) - PATINDEX('%'+@RightBound+'%', @StringSource)
								/* Upper Bound not defined/default case */
                                ELSE 4001 END
							/* This case default should not exists */
							ELSE 4000 END
		END

    /* Precision 2 - Wildcard matching around explicit seek values */
    IF @Precision = 2
    BEGIN
        SELECT @SeekIndex = CASE WHEN @SegmentRank > 0 
								OR PATINDEX('%'+@SearchCase+'%', @StringSource) = 1 THEN 1
								ELSE 0 END
	                                
        SELECT @BoundIndex = CASE WHEN @SeekIndex = 0 THEN CASE
								WHEN PATINDEX('%'+@SearchCase+'%', @StringSource) BETWEEN 2 AND 4000
								THEN PATINDEX('%'+@SearchCase+'%', @StringSource)
									ELSE 4001 END
								WHEN @SeekIndex = 1	THEN CASE
								/* Upper Bound exists between Search Case and lesser of 4000 or Lower Bound */
								WHEN PATINDEX('%'+@RightBound+'%', @StringSource) > PATINDEX('%'+@SearchCase+'%', @StringSource)
								AND PATINDEX('%'+@RightBound+'%', @StringSource) <= 4000
								THEN PATINDEX('%'+@RightBound+'%', @StringSource)
								/* Terminal Index must match remainder of string length, or invalid segment parsing occurs*/
								WHEN PATINDEX('%'+@RightBound+'%', @StringSource) = 0
								AND LEN(@StringSource) - PATINDEX('%'+@RightBound+'%', @StringSource) <= 4000
								THEN LEN(@StringSource) - PATINDEX('%'+@RightBound+'%', @StringSource)
								/* Upper Bound not defined/default case */
                                ELSE 4001 END
							/* This case default should not exists */
							ELSE 4000 END
    END

    /* Precision 3 - Exact string matching within defined bounds */
    IF @Precision = 3
    BEGIN
        SELECT @SeekIndex = CASE WHEN @SegmentRank > 0 
								OR CHARINDEX(@SearchCase, @StringSource) = 1 THEN 1
								ELSE 0 END
	                                
        SELECT @BoundIndex = CASE WHEN @SeekIndex = 0 THEN CASE
								WHEN CHARINDEX(@SearchCase, @StringSource) BETWEEN 1 AND 4000
								THEN CHARINDEX(@SearchCase, @StringSource)
									ELSE 4001 END
								WHEN @SeekIndex = 1	THEN CASE
								/* Upper Bound exists between Search Case and lesser of 4000 or Lower Bound */
								WHEN CHARINDEX(@RightBound, @StringSource, (CHARINDEX(@SearchCase, @StringSource)+1)) > 0
								AND CHARINDEX(@RightBound, @StringSource, (CHARINDEX(@SearchCase, @StringSource)+1)) <= 4000
								THEN CHARINDEX(@RightBound, @StringSource, (CHARINDEX(@SearchCase, @StringSource)+1)) - 1
								/* Terminal Index must match remainder of string length, or invalid segment parsing occurs*/
								WHEN CHARINDEX(@RightBound, @StringSource, (CHARINDEX(@SearchCase, @StringSource)+1)) = 0
								AND LEN(@StringSource) - CHARINDEX(@SearchCase, @StringSource) <= 4000
								THEN LEN(@StringSource) - CHARINDEX(@SearchCase, @StringSource)
								/* Upper Bound not defined/default case */
                                ELSE 4001 END
							/* This case default should not exists */
							ELSE 4000 END
    END



	    IF @SeekIndex > 0
		AND @BoundIndex < 4001
	    BEGIN
            SELECT @StringSegment = CAST(SUBSTRING(@StringSource, @SeekIndex, @BoundIndex) AS NVARCHAR(4000))

	        INSERT INTO @RequiredStringSearch (ObjectID, SegmentID, SegmentRank, SearchCase, AnchorPosition, RangePosition, StringPattern)
	        SELECT	@ObjectID, @SegmentID, @SegmentRank, @SearchCase, @SeekIndex, @BoundIndex, CASE WHEN @StringSegment = '' THEN 'NO MATCH FOUND' ELSE @StringSegment END
        END


	    IF @SeekIndex > 0
		AND @BoundIndex = 4001
	    BEGIN
			/* Iterate @SegmentRank based on the case that undelimited string overflows segment width */
            SET @SegmentRank = CASE WHEN @BoundIndex = 4001 THEN @SegmentRank+1 ELSE @SegmentRank END

            SELECT @StringSegment = CAST(SUBSTRING(@StringSource, @SeekIndex, @BoundIndex-1) AS NVARCHAR(4000))

	        INSERT INTO @RequiredStringSearch (ObjectID, SegmentID, SegmentRank, SearchCase, AnchorPosition, RangePosition, StringPattern)
	        SELECT	@ObjectID, @SegmentID, @SegmentRank, @SearchCase, @SeekIndex, @BoundIndex, CASE WHEN @StringSegment = '' THEN 'NO MATCH FOUND' ELSE @StringSegment END
        END


        IF @SeekIndex = 0
        BEGIN
			/* Segments not containing search critera will be eliminated from string in left-to-right consumption */
            SELECT @StringSegment = SUBSTRING(@StringSource, 1, @BoundIndex)
        END


		--/* Debug Statement */
		--SELECT @SegmentRank as SegmentRank, @SeekIndex as SeekIndex, @BoundIndex as BoundIndex, @BoundIndex - @SeekIndex as SegmentLength
		--, LEN(@StringSource) - @BoundIndex as StringRemainder, @StringSegment as StringSegment
		--, SUBSTRING(@StringSource, @BoundIndex, (LEN(@StringSource) - @BoundIndex)) as SourceString


		/* Remove String Segment from Source and continue */
	    SET @StringSource = SUBSTRING(@StringSource, @BoundIndex, (LEN(@StringSource) - @BoundIndex)) 
	    SET @StringLen = DATALENGTH(@StringSource)

		/* If string segment fully contained then reset rank value */
        SET @SegmentRank = CASE WHEN @BoundIndex = 4001 THEN @SegmentRank ELSE 0 END
		/* If rank value reset, iterate Segment ID */
        SET @SegmentID = CASE WHEN @SegmentRank = 0 THEN @SegmentID + 1 ELSE @SegmentID END
	END
    
SELECT ObjectID, SegmentID, SegmentRank, SearchCase, AnchorPosition, RangePosition, StringPattern
FROM @RequiredStringSearch





GO

/****** Object:  StoredProcedure [fp_test].[MP_User_Database_Archiving_Process]    Script Date: 11/26/2013 15:55:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [fp_test].[MP_User_Database_Archiving_Process]
@TargetDBLocation nvarchar(200)
, @SourceDBLocation nvarchar(200) = NULL
, @Criteria nvarchar(500) = NULL
, @ArchiveClass tinyint = NULL

AS

SET @SourceDBLocation = isnull(@SourceDBLocation, 'dhdcdtw_dev')
SET @Criteria = CASE WHEN isnull(@Criteria, '') = '' THEN '' ELSE replace(@Criteria,'WHERE ','AND ') END
SET @ArchiveClass = isnull(@ArchiveClass,1)

DECLARE @SQL nvarchar(4000)
, @ExecuteSQL nvarchar(500)
, @Return_Value int


/* Create Two Local tables for object structures */
SET @sql = '
exec '+@SourceDBLocation+'.fp_test.mp_031_create_object_from_registry
@targetDBLocation = '''+@TargetDBLocation+''',
@ObjName = ''reg_0300_user_object_registry''
' PRINT @sql

SET @sql = '
exec '+@SourceDBLocation+'.fp_test.mp_031_create_object_from_registry
@targetDBLocation = '''+@TargetDBLocation+''',
@ObjName = ''reg_0310_user_object_definitions''
' PRINT @sql

SET @sql = '
exec '+@SourceDBLocation+'.fp_test.mp_031_create_object_from_registry
@targetDBLocation = '''+@TargetDBLocation+''',
@ObjName = ''reg_0320_user_object_relationships''
' PRINT @sql

--SET @sql = '
--exec '+@SourceDBLocation+'.fp_test.mp_031_create_object_from_registry
--@targetDBLocation = '''+@TargetDBLocation+''',
--@ObjName = ''ddlCreateObjectTrigger''
--' PRINT @sql

SET @sql = '
exec '+@SourceDBLocation+'.fp_test.MP_003_User_Object_Registry
@targetDBLocation = '''+@TargetDBLocation+''',
@SourceDBLocation = '''+@TargetDBLocation+'''
' PRINT @sql

/* Load select object scripts into local tables */
--SET @sql = '
--DECLARE @Reg_0100_ID tinyint
--SELECT @Reg_0100_ID = reg_0100_ID
--FROM '+@SourceDBLocation+'.fp_test.reg_0100_user_server_registry
--WHERE reg_Server_Name = @@ServerName;
--
--DECLARE @Reg_0110_ID smallint
--SELECT @Reg_0110_ID = reg_0110_id
--FROM '+@SourceDBLocation+'.fp_test.reg_0110_user_database_registry
--WHERE reg_fk_0100_ID = @Reg_0100_ID AND reg_Database_ID = DB_ID();
--
--DECLARE @Reg_0300_ID int
--
--DECLARE ObjectShippingResolver CURSOR FOR
--select min(reg_0300_id)
--from dhdcdtw_dev..reg_0300_user_object_registry
--where reg_fk_0110_ID = 57 and reg_Object_Type = 135
--group by reg_object_name
--
--OPEN ObjectShippingResolver
--
--FETCH NEXT FROM ObjectShippingResolver
--INTO @Reg_0300_ID
--
--WHILE @@FETCH_STATUS = 0
--
--BEGIN
--
--INSERT INTO reg_0300_user_object_registry (reg_fk_0100_ID, reg_fk_0110_ID, reg_Object_ID, reg_Parent_Object_ID, reg_Object_Name, reg_Object_Type, reg_Object_Notes, reg_Object_Version, reg_Create_Date, reg_LastModifyDate)
--SELECT reg_fk_0100_ID, reg_fk_0110_ID, reg_Object_ID, reg_Parent_Object_ID, reg_Object_Name, reg_Object_Type, reg_Object_Notes, reg_Object_Version, reg_Create_Date, reg_LastModifyDate
--FROM '+@SourceDBLocation+'.fp_test.reg_0300_user_object_registry
--WHERE reg_fk_0100_ID = @Reg_0100_ID
--AND reg_fk_0110_ID = @Reg_0110_ID
--AND reg_0300_ID = @Reg_0300_ID
--
--SELECT lcl.reg_0300_ID as Reg_ID_Local
--, lcl.reg_Object_ID
--, lcl.reg_Parent_Object_ID
--, src.reg_0300_ID as Reg_ID_Source
--INTO #bdg_registry_bridge
--FROM reg_0300_user_object_registry AS lcl
--JOIN '+@SourceDBLocation+'.fp_test.reg_0300_user_object_registry AS src
--ON src.reg_Object_ID = lcl.reg_Object_ID
--AND src.reg_Parent_Object_ID = lcl.reg_Parent_Object_ID
--
--INSERT INTO reg_0310_user_object_definitions (reg_fk_0300_id, reg_Definition_LineID, reg_Definition_SQL)
--SELECT bdg.Reg_ID_Local, bdg.reg_Definition_LineID, bdg.reg_Definition_SQL
--FROM '+@SourceDBLocation+'.fp_test.reg_0300_user_object_definitions AS def
--JOIN #bdg_registry_bridge AS bdg
--ON bdg.Reg_ID_Source = def.reg_fk_0300_id
--
--END
--
--FETCH NEXT FROM ObjectShippingResolver
--INTO @Reg_0300_ID
--
--CLOSE ObjectShippingResolver
--DEALLOCATE ObjectShippingResolver
--' PRINT @sql


/* Include a "create object from script" procedure for triggered deployment
exec mp_031_create_object_from_registry
@targetDBLocation = @TargetDBLocation,
@Reg0300ID = '??'
 */

/* Replace with "Object Toggle" functions as they become available */
--set @sql = ''
--DECLARE @IDXName nvachar(60)
--
--DECLARE IndiceDropper CURSOR FOR
--SELECT idx.name
--FROM sys.indexes AS idx
--JOIN reg_0300_user_object_registry AS reg
--ON reg.reg_Object_Name = idx.name









GO

/****** Object:  StoredProcedure [fp_test].[mp_XML_Node_Shredder_2000]    Script Date: 11/26/2013 15:55:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [fp_test].[mp_XML_Node_Shredder_2000]

AS
--CREATE SCHEMA Temp

DECLARE @FileName NVARCHAR(255)
, @XMLDefinition NVARCHAR(max)
, @XMLSegment NVARCHAR(max)
, @StringLen INT
, @StringSegment INT
, @NodeID INT
, @NodeIDParent INT
, @NodeLevel INT
, @LastNodeLevel INT
, @NoNodeFlag TINYINT
, @NodeOCFlag BIT
, @SQL NVARCHAR(MAX)

SET NOCOUNT ON

DECLARE XML_Parser CURSOR FOR
SELECT XMLF.reg_File_Name , XMLF.reg_XML_Definition
FROM fp_test.reg_0901_XML_Files as XMLF with(nolock)
WHERE XMLF.reg_XML_Processed_Status = 'False'

OPEN XML_Parser

FETCH NEXT FROM XML_PARSER INTO
@FileName, @XMLDefinition

WHILE @@FETCH_STATUS = 0
BEGIN

SET @SQL = '
IF (SELECT OBJECT_ID(''fp_test.'+@FileName+'_XML_Segments'')) IS NULL
   CREATE TABLE fp_test.'+@FileName+'_XML_Segments (
   Node_ID INT NOT NULL,
   Node_Parent_ID INT NOT NULL,
   Node_Content NVARCHAR(MAX),
   Node_OC_Flag BIT NOT NULL,
   Node_Level INT NOT NULL DEFAULT (0))
ELSE
   TRUNCATE TABLE fp_test.'+@FileName+'_XML_Segments 
' EXECUTE sp_ExecuteSQL @SQL


SET @LastNodeLevel = 0
SET @NodeIDParent = 0
SET @StringSegment = 0
SET @NodeLevel = 0
SET @StringLen = DATALENGTH(@XMLDefinition)


WHILE @StringLen > 0
BEGIN

 SET @XMLSegment = CASE
        WHEN CHARINDEX('<', @XMLDefinition) = 1 
        THEN CASE
			WHEN CHARINDEX('>', @XMLDefinition) BETWEEN 2 AND 4000 
			THEN LEFT(@XMLDefinition, CHARINDEX('>', @XMLDefinition))
			
			WHEN CHARINDEX('>', @XMLDefinition) >= 4000 
			THEN LEFT(@XMLDefinition, 4000)
			END

		WHEN CHARINDEX('<', @XMLDefinition) > 1 
		THEN CASE
			WHEN CHARINDEX('>', @XMLDefinition) > 1
			AND CHARINDEX('>', @XMLDefinition) < CHARINDEX('<', @XMLDefinition)
			AND CHARINDEX('>', @XMLDefinition) < 4000
			THEN LEFT(@XMLDefinition, CHARINDEX('>', @XMLDefinition))
			
			WHEN CHARINDEX('>', @XMLDefinition) > 1
			AND CHARINDEX('<', @XMLDefinition) < CHARINDEX('>', @XMLDefinition)
			AND CHARINDEX('<', @XMLDefinition) < 4000
			THEN LEFT(@XMLDefinition, CHARINDEX('<', @XMLDefinition)-1)

			WHEN CHARINDEX('>', @XMLDefinition) > 1
			AND CHARINDEX('<', @XMLDefinition) < CHARINDEX('>', @XMLDefinition)
			AND CHARINDEX('<', @XMLDefinition) >= 4000
			THEN LEFT(@XMLDefinition, 4000)
			END

        ELSE @XMLDefinition END
        
    SET @StringSegment = @StringSegment + 1

	SET @LastNodeLevel = @NodeLevel

    SET @NodeLevel = CASE WHEN CHARINDEX('<', @XMLSegment) = 1
                    AND CHARINDEX('>', @XMLSegment) > 1
                    AND CHARINDEX('</', @XMLSegment) = 0 
                    AND CHARINDEX('/>', @XMLSegment) = 0
                    AND CHARINDEX('-->', @XMLSegment) = 0
                    THEN @NodeLevel + 1
                    --WHEN CHARINDEX('</', @XMLSegment) > 0 
                    --THEN @NodeLevel - 1
                    ELSE @NodeLevel
                    END
	
    SET @NodeOCFlag = CASE WHEN CHARINDEX('</', @XMLSegment) > 0 THEN 1 ELSE 0 END


    SET @NoNodeFlag = CASE WHEN CHARINDEX('<', @XMLSegment) > 0
                    AND CHARINDEX('>', @XMLSegment) > 0
                    THEN 0
                    WHEN CHARINDEX('<', @XMLSegment) = 1
                    AND CHARINDEX('>', @XMLSegment) = 0
                    AND @NoNodeFlag = 0
                    THEN 1
                    WHEN CHARINDEX('<', @XMLSegment) = 0
                    AND CHARINDEX('>', @XMLSegment) > 0
                    AND @NoNodeFlag = 1
                    THEN 2
                    WHEN CHARINDEX('<', @XMLSegment) = 0
                    AND CHARINDEX('>', @XMLSegment) = 0
                    THEN 3
                    ELSE 4 END


	SET @NodeIDParent = CASE WHEN @NodeLevel > @LastNodeLevel AND @NodeOCFlag = 0
						AND @NoNodeFLag < 3 THEN @NodeIDParent + 1
						WHEN @NodeOCFlag = 1 
						AND @NoNodeFLag < 3 THEN @NodeIDParent - 1
						ELSE @NodeIDParent END

   
    SET @SQL = '
    BEGIN TRANSACTION
    INSERT INTO fp_test.'+@FileName+'_XML_Segments (Node_ID, Node_Parent_ID, Node_Content, Node_Level, Node_OC_Flag)
    SELECT '+cast(@StringSegment as varchar)+'
	, '+cast(@NodeIDParent as varchar)+'
    ,'''+CASE WHEN @NoNodeFLag > 2 THEN 'NO NODE INFORMATION' ELSE @XMLSegment END+'''
    , '+CAST(@NodeLevel as varchar)+'
	, '+CAST(@NodeOCFlag as varchar(1))+'
    COMMIT TRANSACTION
    ' EXECUTE sp_ExecuteSQL @SQL
    
	SET @XMLDefinition = SUBSTRING(@XMLDefinition, (LEN(REPLACE(@XMLSegment, ' ', '.')) + 1), (LEN(REPLACE(@XMLDefinition, ' ', '.')) - LEN(REPLACE(@XMLSegment, ' ', '.'))))
    SET @StringLen = DATALENGTH(@XMLDefinition)/2
    END
    
UPDATE reg SET reg_XML_Processed_Status = 'True'
FROM fp_test.reg_0901_XML_Files AS reg
WHERE reg_File_Name = @FileName


FETCH NEXT FROM XML_PARSER INTO
@FileName, @XMLDefinition

END

CLOSE XML_PARSER
DEALLOCATE XML_PARSER
    
    
    

    --WHILE CHARINDEX(' xmlns', reg_XML_Definition) > 6)
    --BEGIN

    --SELECT CASE WHEN (CHARINDEX(' xmlns', reg_XML_Definition) > 6) AND (CHARINDEX(' xmlns:', reg_XML_Definition) > 7)
    --        THEN (CHARINDEX(' xmlns:', reg_XML_Definition) + 7) 
    --       ELSE CHARINDEX(' xmlns', reg_XML_Definition) END AS startpos
     
    --, CHARINDEX('="', reg_XML_Definition, CHARINDEX(' xmlns', reg_XML_Definition)) AS endpos

    --, SUBSTRING(reg_xml_definition
    --    , CASE WHEN (CHARINDEX(' xmlns', reg_XML_Definition) > 6) AND (CHARINDEX(' xmlns:', reg_XML_Definition) > 7)
    --        THEN (CHARINDEX(' xmlns:', reg_XML_Definition) + 7) 
    --       ELSE CHARINDEX(' xmlns', reg_XML_Definition) END
           
    --    , CHARINDEX('="', reg_XML_Definition, CHARINDEX(' xmlns', reg_XML_Definition)) - CASE WHEN (CHARINDEX(' xmlns', reg_XML_Definition) > 6) AND (CHARINDEX(' xmlns:', reg_XML_Definition) > 7)
    --        THEN (CHARINDEX(' xmlns:', reg_XML_Definition) + 7) 
    --       ELSE CHARINDEX(' xmlns', reg_XML_Definition) END
    --    ) as xlmns_string
    --, reg_xml_definition
    --FROM reg_0901_XML_Files
    --SET @StringLen = DATALENGTH(@XMLDefinition)



GO

/****** Object:  StoredProcedure [fp_test].[MP_XML_Shredder]    Script Date: 11/26/2013 15:55:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [fp_test].[MP_XML_Shredder]
@FilePath NVARCHAR(255) = NULL
, @FileName NVARCHAR(255) = NULL
, @NameSpace NVARCHAR(max) = NULL
, @ExecuteStatus TINYINT = 1

AS

SET @FilePath = 'C:\Users\fpugh\Documents\Visual Studio 2010\Projects\CMMI_Reporting\CMMI_Reporting\'
SET @FileName = 'SM_Monthly_Percent_Of_Successful_Calls.rdl'
SET @NameSpace = ' xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns:cl="http://schemas.microsoft.com/sqlserver/reporting/2010/01/componentdefinition" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition"'

DECLARE @FileLocation NVARCHAR(255)
, @SQL NVARCHAR(max)
, @SQL1 NVARCHAR(max)
, @SQL2 NVARCHAR(max)
, @SQL3 NVARCHAR(max)
, @SQL4 NVARCHAR(max)


SET @FileLocation = @FilePath+@FileName


----DROP TABLE fp_test.Report_Data_Sources
--CREATE TABLE fp_test.Report_Data_Sources (
--Report_Name VARCHAR(255) NOT NULL PRIMARY KEY
--, DataSourceName VARCHAR(255) NOT NULL
--, AltDataSourceName VARCHAR(255) NOT NULL
--, DataSourceID VARCHAR(255) NOT NULL
--, PostDate DATETIME NOT NULL DEFAULT getdate()
--);

SET @SQL1 = '
INSERT INTO test.Report_Data_Sources (Report_Name, DataSourceName, AltDataSourceName, DataSourceID) 

SELECT '''+@FileName+'''
	,	X.DataSource.value(''(DataSourceReference)[1]'', ''VARCHAR(255)'')
	,	X.DataSource.value(''(@Name)'',''VARCHAR(255)'')
	,	X.DataSource.value(''(DataSourceID)[1]'', ''VARCHAR(255)'')
FROM ( 
	SELECT CAST(REPLACE(REPLACE( x , '''+@NameSpace+''',''''),''rd:'','''') AS XML)
	FROM OPENROWSET(     
			BULK '''+@FileLocation+''', SINGLE_BLOB
				) AS T(x)
	) AS T(x)
	CROSS APPLY x.nodes(''Report/DataSources/DataSource'') AS X(DataSource);
'



----DROP TABLE fp_test.Report_Parameters
--CREATE TABLE fp_test.Report_Parameters (
--Report_Name VARCHAR(255) NOT NULL
--, ParameterName VARCHAR(255) NOT NULL PRIMARY KEY
--, ParameterType VARCHAR(255) NOT NULL
--, ParameterPrompt VARCHAR(255) NULL
--, ParameterDefault VARCHAR(255) NULL
--, PostDate DATETIME NOT NULL DEFAULT getdate()
--);

SET @SQL2 = '
INSERT INTO fp_test.Report_Parameters (Report_Name, ParameterName, ParameterType, ParameterPrompt, ParameterDefault) 

SELECT '''+@FileName+'''
	,	X.Parameter.value(''(@Name)'',''VARCHAR(255)'')
	,	X.Parameter.value(''(DataType)[1]'', ''VARCHAR(255)'')
	,	X.Parameter.value(''(Prompt)[1]'', ''VARCHAR(255)'')
	,	Y.Defaults.value(''(Value)[1]'', ''VARCHAR(255)'')
FROM ( 
	SELECT CAST(REPLACE(REPLACE( x , '''+@NameSpace+''',''''),''rd:'','''') AS XML)
	FROM OPENROWSET(
			BULK '''+@FileLocation+''', SINGLE_BLOB
				) AS T(x)
	) AS T(x)
	CROSS APPLY x.nodes(''Report/ReportParameters/ReportParameter'') AS X(Parameter)
	CROSS APPLY parameter.nodes(''ValidValue/DataSetReference'') AS Y(Defaults);
'
	 

----DROP TABLE fp_test.Report_Data_Fields
--CREATE TABLE fp_test.Report_Data_Fields (
--Report_Name VARCHAR(255) NOT NULL
--, DataSetName VARCHAR(255) NOT NULL
--, FieldName VARCHAR(255) NOT NULL PRIMARY KEY
--, FieldType VARCHAR(255) NOT NULL
--, PostDate DATETIME NOT NULL DEFAULT getdate()
--);

SET @SQL3 = '
INSERT INTO fp_test.Report_Data_Fields (Report_Name, DataSetName, FieldName, FieldType) 

SELECT '''+@FileName+'''
	,	X.DataSet.value(''(../../@Name)'',''VARCHAR(255)'')
	,	X.DataSet.value(''(DataField)[1]'', ''VARCHAR(255)'')
	,	X.DataSet.value(''(TypeName)[1]'', ''VARCHAR(255)'')
FROM ( 
	SELECT CAST(REPLACE(REPLACE( x , '''+@NameSpace+''',''''),''rd:'','''') AS XML)
	FROM OPENROWSET(     
			BULK '''+@FileLocation+''', SINGLE_BLOB
				) AS T(x)
	) AS T(x)
CROSS APPLY x.nodes(''Report/DataSets/DataSet/Fields/Field'') AS X(DataSet)
'	



----DROP TABLE fp_test.Report_Data_Queries
--CREATE TABLE fp_test.Report_Data_Queries (
--Report_Name VARCHAR(255) NOT NULL
--, DataSourceReference VARCHAR(255) NOT NULL
--, CommandType VARCHAR(255) NOT NULL
--, CommandText VARCHAR(MAX) NOT NULL
--, PostDate DATETIME NOT NULL DEFAULT getdate()
--);

SET @SQL4 = '
INSERT INTO fp_test.Report_Data_Queries (Report_Name, DataSourceReference, CommandType, CommandText) 

SELECT '''+@FileName+'''
	,	X.DataSet.value(''(DataSourceName)[1]'',''VARCHAR(255)'')
	,	X.DataSet.value(''(CommandType)[1]'', ''VARCHAR(255)'')
	,	X.DataSet.value(''(CommandText)[1]'', ''VARCHAR(255)'')
FROM ( 
	SELECT CAST(REPLACE(REPLACE( x , '''+@NameSpace+''',''''),''rd:'','''') AS XML)
	FROM OPENROWSET(     
			BULK '''+@FileLocation+''', SINGLE_BLOB
				) AS T(x)
	) AS T(x)
CROSS APPLY x.nodes(''Report/DataSets/DataSet/Query'') AS X(DataSet)
'



IF @ExecuteStatus in (0,1)
BEGIN
	PRINT @SQL1
	PRINT @SQL2
	PRINT @SQL3
	PRINT @SQL4
END


IF @ExecuteStatus in (1,2)
BEGIN
	SET @SQL = cast(@SQL1 as nvarchar(max))+cast(@SQL2 as nvarchar(max))+cast(@SQL3 as nvarchar(max))+cast(@SQL4 as nvarchar(max))
	--SET @ExecuteSQL = @TargetDBLocation+'..sp_executesql' 
	EXEC sp_executeSQL @SQL
END
GO

