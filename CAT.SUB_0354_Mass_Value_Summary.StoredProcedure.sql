USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[SUB_0354_Mass_Value_Summary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[SUB_0354_Mass_Value_Summary]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[SUB_0354_Mass_Value_Summary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [CAT].[SUB_0354_Mass_Value_Summary]
@TargetDBLocation NVARCHAR(256) = ''master''
, @SourceDBLocation NVARCHAR(256) = N''DWMgmt''
, @NamePart NVARCHAR(256) = N''ALL''
, @SourceCollation NVARCHAR(65) = N''Database_Default''
, @ExecuteStatus TINYINT = 2

AS

IF @ExecuteStatus IN (0,2) SET NOCOUNT ON


DECLARE @DateString CHAR(8)
SELECT @DateString = CAST(YEAR(GETDATE()) AS CHAR(4))+RIGHT(''00''+CAST(MONTH(GETDATE()) AS VARCHAR(2)),2)+RIGHT(''00''+CAST(DAY(GETDATE()) AS VARCHAR(2)),2)


DECLARE @SQL NVARCHAR(max) = ''''
, @SQL1 NVARCHAR(4000) = ''''
, @SQL2 NVARCHAR(4000)
, @SQL3 NVARCHAR(4000)
, @ExecuteSQL NVARCHAR(500)


SET @SQL1 = ''
CREATE TABLE #TRK_0354_Value_Hash (Tbl_ID INT, Server_Name NVARCHAR(65), Server_ID INT DEFAULT 0, Database_Name NVARCHAR(65), Database_ID INT
, Schema_Name NVARCHAR(65), Schema_ID INT, Object_Name NVARCHAR(65), Object_ID INT, Column_Name NVARCHAR(65), Column_ID INT, Column_Type NVARCHAR(65)
, Column_Value NVARCHAR(4000), Value_Count BIGINT)

; DECLARE @Splay NVARCHAR(max) = ''''''''
, @TblID NVARCHAR(65)
, @ServerName NVARCHAR(65)
, @DatabaseName NVARCHAR(65)
, @DBID NVARCHAR(65)
, @SchemaName NVARCHAR(65)
, @SchemaID NVARCHAR(65)
, @ObjectName NVARCHAR(65)
, @ObjectID NVARCHAR(65)
, @ColumnName NVARCHAR(65)
, @ColumnID NVARCHAR(65)
, @ColumnType NVARCHAR(65)
, @CollateFlag NVARCHAR(1)

; DECLARE SplayStruct CURSOR FOR
SELECT DISTINCT CAST(DENSE_RANK() OVER (ORDER BY @@ServerName, scm.name, obj.name, col.name) AS NVARCHAR) as TBL_ID
, @@ServerName as Server_Name
, ''''''+@TargetDBLocation+'''''' as Database_Name
, db_id(''''''+@TargetDBLocation+'''''') as Database_ID
, scm.name as Schema_Name, scm.schema_id
, obj.name as Object_Name, obj.object_id
, col.name as Column_Name, col.column_id
, typ.name as Column_Type
, CAST(CASE WHEN col.user_Type_ID IN (167,175,231,239) THEN 1 ELSE 0 END AS NVARCHAR) as Collate_Flag
FROM [''+@TargetDBLocation+''].sys.schemas AS scm WITH(NOLOCK)
JOIN [''+@TargetDBLocation+''].sys.all_objects AS obj WITH(NOLOCK)
ON scm.Schema_ID = obj.Schema_ID
AND obj.type IN (''''U'''')
JOIN [''+@TargetDBLocation+''].sys.all_columns AS col WITH(NOLOCK)
ON obj.Object_ID = col.Object_ID
AND col.user_Type_ID NOT IN (34,35,98,99,129,130,241)
AND (''''''+@NamePart+'''''' = ''''ALL'''' 
OR CHARINDEX(''''''+@NamePart+'''''', scm.name+''''.''''+obj.name) > 0)
JOIN sys.types AS typ
ON typ.user_type_id = col.user_type_id

OPEN SplayStruct

FETCH NEXT FROM SplayStruct
INTO @TblID, @ServerName, @DatabaseName, @DBID, @SchemaName, @SchemaID, @ObjectName, @ObjectID, @ColumnName, @ColumnID, @ColumnType, @CollateFlag

WHILE @@FETCH_STATUS = 0
BEGIN
''


/* A complete Value summary is performed - slowest/biggest - Confidence = 100% */
SET @SQL2 = ''
IF len(@Splay) <= 3500
SET @Splay = @Splay + ''''
''

SET @SQL2 = @SQL2 + ''
INSERT INTO #TRK_0354_Value_Hash (Tbl_ID, Server_Name, Database_Name, Database_ID, Schema_Name, Schema_ID, Object_Name, Object_ID, Column_Name, Column_ID, Column_Type, Column_Value, Value_Count)
SELECT ''''''''''''+@TblID+'''''''''''', @@ServerName AS Server_Name
, ''''''''''''+@DatabaseName+'''''''''''' as Database_Name, ''''''''''''+@DBID+'''''''''''' as Database_ID
, ''''''''''''+@SchemaName+'''''''''''' as Schema_Name, ''''''''''''+@SchemaID+'''''''''''' as Schema_ID
, ''''''''''''+@ObjectName+'''''''''''' as Object_Name, ''''''''''''+@ObjectID+'''''''''''' as Object_ID
, ''''''''''''+@ColumnName+'''''''''''' as Column_Name, ''''''''''''+@ColumnID+'''''''''''' as Column_ID
, ''''''''''''+@ColumnType+''''''''''''
, CASE WHEN ''''+@CollateFlag+'''' = 1 THEN convert(varchar(4000), [''''+@ColumnName+''''])
	ELSE rtrim(ltrim(convert(varchar(4000), [''''+@ColumnName+'''']))) COLLATE ''+@SourceCollation+'' END AS Column_Value
, COUNT_BIG(*) as Value_Count
FROM ''''+@SchemaName+''''.''''+@ObjectName+'''' WITH(NOLOCK)
GROUP BY [''''+@ColumnName+'''']
''''
''

SET @SQL3 = ''
IF len(@Splay) > 3500
BEGIN
	IF ''+cast(@ExecuteStatus as nvarchar)+'' in (0,1)
	BEGIN
		PRINT @Splay
	END

	IF ''+cast(@ExecuteStatus as nvarchar)+'' in (1,2,3)
	BEGIN
		EXEC sp_executeSQL @Splay
	END

	SET @Splay = ''''''''

	INSERT INTO [''+@SourceDBLocation+''].TMP.TRK_0354_Value_Hash_Objects (TRK_0354_ID, Server_Name, Database_Name, Database_ID, Schema_Name, Schema_ID, Object_Name, Object_ID, Column_Name, Column_ID, Column_Type)
	SELECT Tbl_ID, Server_Name, Database_Name, Database_ID, Schema_Name, Schema_ID, Object_Name, Object_ID, Column_Name, Column_ID, Column_Type
	FROM #TRK_0354_Value_Hash
	EXCEPT
	SELECT TRK_0354_ID, Server_Name, Database_Name, Database_ID, Schema_Name, Schema_ID, Object_Name, Object_ID, Column_Name, Column_ID, Column_Type
	FROM [''+@SourceDBLocation+''].TMP.TRK_0354_Value_Hash_Objects

	INSERT INTO [''+@SourceDBLocation+''].TMP.TRK_0354_Value_Hash (RK_0354_ID, Column_Value, Value_Count)
	SELECT Tbl_ID, Column_Value, Value_Count
	FROM #TRK_0354_Value_Hash

	TRUNCATE TABLE #TRK_0354_Value_Hash
END

FETCH NEXT FROM SplayStruct
INTO @TblID, @ServerName, @DatabaseName, @DBID, @SchemaName, @SchemaID, @ObjectName, @ObjectID, @ColumnName, @ColumnID, @ColumnType, @CollateFlag


IF len(@Splay) <= 3500
BEGIN

	IF ''+cast(@ExecuteStatus as nvarchar)+'' in (0,1)
	BEGIN
		PRINT @Splay
	END

	IF ''+cast(@ExecuteStatus as nvarchar)+'' in (1,2,3)
	BEGIN
		EXEC sp_executeSQL @Splay
	END

	SET @Splay = ''''''''

	INSERT INTO [''+@SourceDBLocation+''].TMP.TRK_0354_Value_Hash_Objects (TRK_0354_ID, Server_Name, Database_Name, Database_ID, Schema_Name, Schema_ID, Object_Name, Object_ID, Column_Name, Column_ID, Column_Type)
	SELECT Tbl_ID, Server_Name, Database_Name, Database_ID, Schema_Name, Schema_ID, Object_Name, Object_ID, Column_Name, Column_ID, Column_Type
	FROM #TRK_0354_Value_Hash
	EXCEPT
	SELECT TRK_0354_ID, Server_Name, Database_Name, Database_ID, Schema_Name, Schema_ID, Object_Name, Object_ID, Column_Name, Column_ID, Column_Type
	FROM [''+@SourceDBLocation+''].TMP.TRK_0354_Value_Hash_Objects

	INSERT INTO [''+@SourceDBLocation+''].TMP.TRK_0354_Value_Hash (RK_0354_ID, Column_Value, Value_Count)
	SELECT Tbl_ID, Column_Value, Value_Count
	FROM #TRK_0354_Value_Hash

	TRUNCATE TABLE #TRK_0354_Value_Hash

END


END

CLOSE SplayStruct
DEALLOCATE SplayStruct
''


IF @ExecuteStatus in (0)
BEGIN
	SELECT ''CSR_SplayStruct_1'' AS SQL_Object_Name, @SQL1
	SELECT ''TRK_0354_Value_Hash'' AS SQL_Object_Name, @SQL2
	SELECT ''CSR_SplayStruct_2'' AS SQL_Object_Name, @SQL3
END


IF @ExecuteStatus in (3)
BEGIN
	SELECT CAST(@SQL1 AS nvarchar(MAX))+CAST(@SQL2 AS nvarchar(MAX))+CAST(@SQL3 AS nvarchar(MAX)) AS SQLText
END


IF @ExecuteStatus in (1)
BEGIN
	PRINT @SQL1
	PRINT @SQL2
	PRINT @SQL3
END


IF @ExecuteStatus in (1,2)
BEGIN
	SET @SQL = CAST(@SQL1 AS nvarchar(MAX))+CAST(@SQL2 AS nvarchar(MAX))+CAST(@SQL3 AS nvarchar(MAX))
	SET @ExecuteSQL = @TargetDBLocation+''..sp_executesql'' 
	EXEC @ExecuteSQL @SQL
END



' 
END
GO
