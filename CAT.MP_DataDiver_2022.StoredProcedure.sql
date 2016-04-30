USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_DataDiver_2022]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[MP_DataDiver_2022]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_DataDiver_2022]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
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
---	*	@Value - The specific data value sought; e.g. ''#PASNXD0'' - a primary source system.	---
---																								---
---	*	@TargetColumn - The name or approximation columns to search - ''Med%Rec%No'' for example.	---
---																								---
---	*	@TargetSchema - Can be presented as a multi-valued comma-seperated list.				---
---																								---
---	Secondary criteria which are optinal further refine search scope, or define execution		---
---	behavior. These are generally only available by manually executing this procedure from SMSS	---
--- or other explicitly executed SQL command. They inlcude the following:						---
---																								---
---	*	@ColumnType - the system data-type name for the column; for example the value ''00359''	---
---		is given but it''s context is unknown. If "0" precedes other integers, then the type		---
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
--- the row-counts of all tables within a database/schema set (omit @value and @TargetColumn).	---
---	This is not an optimal use of this query however and is not recommended.					---
---																								---
---	Happy Diving!																				---
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
CREATE PROCEDURE [CAT].[MP_DataDiver_2022]
	--DECLARE
@TargetDatabase nvarchar(65) = N''ALL''
, @TargetSchema nvarchar(65) = N''ALL''
, @TargetObject nvarchar(65) = N''ALL''
, @TargetColumn nvarchar(65) = N''ALL''
, @Value nvarchar(4000) = NULL
, @ExecuteStatus tinyint = 1
, @ForceExecute int = 0

AS

/* Prevent query from further execution if NO criteria are provided. ForceExecute flag should NOT
	be considered as a valid escape from this check. */

IF (@Value IS NULL AND @TargetColumn IS NULL)
BEGIN
	RAISERROR(''You must supply search criteria!'', 0, 0) GOTO Abend
END


/* Set all discrete criteria variables to ''All'' instead of blank or NULL - these are used in multi-value lookups */

DECLARE @Schema nvarchar(65)
, @Table_Name nvarchar(65)
, @Database nvarchar(65)
, @SeekColumn varchar(65)
, @SQL1 nvarchar(4000) = ''''
, @SQL2 nvarchar(4000) = ''''
, @SQL nvarchar(max) = ''''
, @ExecuteSQL nvarchar(500)


/* Create a table variable for storing search results for end users, or to be accessed by advanced search procedures */


/* Initialize a cursor to process all table/column combinations that fit the base search criteria */
DECLARE tableresolver CURSOR FOR
SELECT DISTINCT REG_Database_Name, REG_Schema_Name, REG_Object_Name, REG_Column_Name
FROM CAT.VI_Column_Tier_Latches
WHERE (@TargetDatabase =''All'' OR CHARINDEX(REG_Database_Name, @TargetDatabase) > 0 OR CHARINDEX(@TargetDatabase, REG_Database_Name) > 0)
AND (@TargetSchema =''All'' OR CHARINDEX(REG_Schema_Name, @TargetSchema) > 0 OR CHARINDEX(@TargetSchema, REG_Schema_Name) > 0)
AND (@TargetObject =''All'' OR CHARINDEX(REG_Object_Name, @TargetObject) > 0 OR CHARINDEX(@TargetObject, REG_Object_Name) > 0)
AND (@TargetColumn =''All'' OR CHARINDEX(REG_Column_Name, @TargetColumn) > 0 OR CHARINDEX(@TargetColumn, REG_Column_Name) > 0)
AND REG_Object_Name not like ''#%''
ORDER BY REG_Schema_Name, REG_Object_Name, REG_Column_Name
 
OPEN tableresolver

FETCH NEXT FROM tableresolver
INTO @Database, @Schema, @Table_Name, @SeekColumn

/* Test for large search sets and force users or processes with poorly written calls to reconsider criteria due to query impact */
IF @@CURSOR_ROWS > 10000 AND (@TargetColumn = '''' OR @TargetSchema = ''ALL'') AND @ForceExecute = 0
BEGIN
	RAISERROR(''Search criteria is very broad - consider searching on column names, types, or confine your search to a target schema, or use @ForceExecute = 1'', 0, 0)
	CLOSE tableresolver
	DEALLOCATE tableresolver
	GOTO Abend
END


IF EXISTS (SELECT name FROM tempdb.sys.tables WHERE name like ''#TblList%'')
DROP TABLE #TblList

CREATE TABLE #TblList (TableID int identity(1,1), Table_Name nvarchar(255), Column_Name nvarchar(65), Hit_Count int)

SELECT @SQL1 = CASE WHEN CHARINDEX('','', @Value) > 0 THEN ''
DECLARE @ValueList TABLE (Value NVARCHAR(65))
DECLARE @ValueLCL NVARCHAR(4000) = ''''''+@Value+''''''
WHILE CHARINDEX('''','''', @ValueLCL) > 0
BEGIN
	INSERT INTO @ValueList (Value)
	SELECT LEFT(@ValueLCL ,CHARINDEX('''','''', @ValueLCL)-1)
	SET @ValueLCL = REPLACE(@ValueLCL, LEFT(@ValueLCL, CHARINDEX('''','''', @ValueLCL)),'''''''')
END'' ELSE '''' END


WHILE @@FETCH_STATUS = 0 
BEGIN

	
	SELECT @SQL2 = @SQL2 + CASE WHEN LEN(@SQL2) = 0
	THEN ''
	INSERT INTO #TblList (Table_Name, Column_Name, Hit_Count)	
	
	SELECT ''''''+@Database+''.''+@Schema+''.''+@Table_Name+'''''' as Table_Name, ''''[''+@SeekColumn+'']'''' AS Column_Name, count(*)
	FROM [''+@Database+''].[''+@Schema+''].[''+@Table_Name+''] AS tbl WITH(NOLOCK)''
		+ CASE WHEN CHARINDEX('','',@Value) = 0 THEN '' WHERE cast([''+@SeekColumn+''] as nvarchar) like ''''%''+@Value+''%''''''
		ELSE '' WHERE cast([''+@SeekColumn+''] as nvarchar) IN (SELECT Value FROM @ValueList)'' END
	 + '' HAVING count(*) > 0''
	--WHEN LEN(@SQL2) > 0 AND LEN(@SQL2) < (4000 - CASE WHEN CHARINDEX('','',@Value) = 0 THEN 915 ELSE 938 END)
	WHEN LEN(@SQL2) > 0 AND LEN(@SQL2) < 2200
	THEN ''
	UNION
	SELECT ''''''+@Database+''.''+@Schema+''.''+@Table_Name+'''''' as Table_Name, ''''[''+@SeekColumn+'']'''' AS Column_Name, count(*)
	FROM [''+@Database+''].[''+@Schema+''].[''+@Table_Name+''] AS tbl WITH(NOLOCK)''
		+ CASE WHEN CHARINDEX('','',@Value) = 0 THEN '' WHERE cast([''+@SeekColumn+''] as nvarchar) like ''''%''+@Value+''%''''''
		ELSE '' WHERE cast([''+@SeekColumn+''] as nvarchar) IN (SELECT Value FROM @ValueList)'' END
	 + '' HAVING count(*) > 0''
	ELSE '''' END


FETCH NEXT FROM tableresolver
INTO @Database, @Schema, @Table_Name, @SeekColumn


	--IF LEN(@SQL2) >= (4000 - CASE WHEN CHARINDEX('','',@Value) = 0 THEN 915 ELSE 938 END)
	IF LEN(@SQL2) >= 2200
	BEGIN
		
		IF @ExecuteStatus in (0,1)
		BEGIN
			PRINT @SQL1
			PRINT @SQL2
		END


		IF @ExecuteStatus in (1,2)
		BEGIN
			SET @SQL = @SQL1+@SQL2
			EXEC sp_executeSQL @SQL
		END

		SET @SQL2 = ''''
		SET @SQL = ''''
	END

END

CLOSE tableresolver
DEALLOCATE tableresolver


SELECT TableID, Table_Name, Column_Name, Hit_Count
FROM #TblList


Abend:
PRINT ''Search Aborted - One or more criteria not set, or potential timeout detected''
' 
END
GO
