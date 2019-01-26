

CREATE PROCEDURE [CAT].[SUB_1354_Data_Profile_Executor]
@TargetDBLocation NVARCHAR(256) = 'master'
, @SourceDBLocation NVARCHAR(256) = N'DWMgmt'
, @NamePart NVARCHAR(256) = N'ALL'
, @SourceCollation NVARCHAR(65) = N'Database_Default'
, @ExecuteStatus TINYINT = 2

AS

IF @ExecuteStatus IN (0,2) SET NOCOUNT ON


DECLARE @DateString CHAR(8)
SELECT @DateString = CAST(YEAR(GETDATE()) AS CHAR(4))+RIGHT('00'+CAST(MONTH(GETDATE()) AS VARCHAR(2)),2)+RIGHT('00'+CAST(DAY(GETDATE()) AS VARCHAR(2)),2)


DECLARE @SQL NVARCHAR(max) = ''
, @SQL1 NVARCHAR(4000) = ''
, @SQL2 NVARCHAR(4000)
, @SQL3 NVARCHAR(4000)
, @SQL4 NVARCHAR(4000)
, @ExecuteSQL NVARCHAR(500)


SET @SQL1 = '
TRUNCATE TABLE TMP.TRK_0354_Value_Hash_objects
TRUNCATE TABLE TMP.TRK_0354_Value_Hash
TRUNCATE TABLE TMP.TRK_0354_Long_String_Values

CREATE TABLE #TRK_0354_Value_Hash (Tbl_ID INT, Server_Name NVARCHAR(65), Database_Name NVARCHAR(65), Schema_Bound_Name NVARCHAR(256)
, Column_Name NVARCHAR(65), Column_Type NVARCHAR(65), Collate_Flag NVARCHAR(1), Column_Value NVARCHAR(MAX), Value_Count BIGINT, String_Flag TINYINT)

; DECLARE @Splay NVARCHAR(max) = ''''
, @TblID NVARCHAR(65)
, @ServerName NVARCHAR(65)
, @DatabaseName NVARCHAR(65)
, @SchemaBoundName NVARCHAR(256)
, @ColumnName NVARCHAR(65)
, @ColumnType NVARCHAR(65)
, @CollateFlag NVARCHAR(1)

; DECLARE SplayStruct CURSOR FOR
SELECT DISTINCT CAST(DENSE_RANK() OVER (ORDER BY @@ServerName, scm.name, obj.name, col.name) AS NVARCHAR) as TBL_ID
, '''+@TargetDBLocation+''' as Database_Name
, scm.name+''.''+obj.name as Schema_Bound_Name
, col.name as Column_Name
, typ.name as Column_Type
, CAST(CASE WHEN col.user_Type_ID IN (167,175,231,239) THEN 1 ELSE 0 END AS NVARCHAR) as Collate_Flag
FROM '+@TargetDBLocation+'.sys.schemas AS scm WITH(NOLOCK)
JOIN '+@TargetDBLocation+'.sys.all_objects AS obj WITH(NOLOCK)
ON scm.Schema_ID = obj.Schema_ID
AND obj.type IN (''U'')
JOIN '+@TargetDBLocation+'.sys.all_columns AS col WITH(NOLOCK)
ON obj.Object_ID = col.Object_ID
AND col.user_Type_ID NOT IN (34,35,98,99,129,130,241)
AND ('''+@NamePart+''' = ''ALL'' 
OR CHARINDEX('''+@NamePart+''', scm.name+''.''+obj.name) > 0)
JOIN sys.types AS typ
ON typ.user_type_id = col.user_type_id

OPEN SplayStruct

FETCH NEXT FROM SplayStruct
INTO @TblID, @DatabaseName, @SchemaBoundName, @ColumnName, @ColumnType, @CollateFlag

WHILE @@FETCH_STATUS = 0
BEGIN
'


/* A complete Value summary is performed - slowest/biggest - Confidence = 100% */
SET @SQL2 = '
IF len(@Splay) <= 3500
SET @Splay = @Splay + ''
'

SET @SQL2 = @SQL2 + '
INSERT INTO #TRK_0354_Value_Hash (Tbl_ID, Server_Name, Database_Name, Schema_Bound_Name, Column_Name, Column_Type, Column_Value, Value_Count, String_Flag)
SELECT ''''''+@TblID+'''''', @@ServerName AS Server_Name
, ''''''+@DatabaseName+'''''' as Database_Name
, ''''''+@SchemaBoundName+'''''' as Schema_Bound_Name
, ''''''+@ColumnName+'''''' as Column_Name
, ''''''+@ColumnType+''''''
, CASE WHEN ''+@CollateFlag+'' = 1 THEN convert(varchar(4000), [''+@ColumnName+''])
	ELSE rtrim(ltrim(convert(varchar(4000), [''+@ColumnName+'']))) COLLATE '+@SourceCollation+' END AS Column_Value
, COUNT_BIG(*) as Value_Count
, CASE WHEN ISNUMERIC('' + CAST(Column_Name AS NVARCHAR) + '') = 0 
	AND ISDATE('' + CAST(Column_Name AS NVARCHAR) + '') = 0 
	AND PATINDEX(''%[^0-9a-zA-Z.]%'', CAST('' + Column_Name + '' AS VARCHAR)) > 0
	OR LEN('' + Column_Name + '') > 256 THEN 1 ELSE 0 END AS String_Flag
FROM ''+@DatabaseName+''.''+@SchemaBoundName+'' WITH(NOLOCK)
GROUP BY [''+@ColumnName+'']
''
'

SET @SQL3 = '
IF len(@Splay) > 3500
BEGIN
	IF '+cast(@ExecuteStatus as nvarchar)+' in (0,1)
	BEGIN
		PRINT @Splay
	END

	IF '+cast(@ExecuteStatus as nvarchar)+' in (1,2,3)
	BEGIN
		EXEC sp_executeSQL @Splay
	END

	SET @Splay = ''''


	INSERT INTO '+@SourceDBLocation+'.TMP.TRK_0354_Value_Hash_Objects (LNK_T4_ID, Server_Name, Database_Name, Schema_Bound_Name, Column_Name, Column_Type, Collate_Flag)
	
	SELECT DISTINCT lat.LNK_T4_ID, tmp.Server_Name, tmp.Database_Name, tmp.Schema_Bound_Name, tmp.Column_Name, tmp.Column_Type, tmp.Collate_Flag
	FROM #TRK_0354_Value_Hash AS tmp
	JOIN '+@SourceDBLocation+'.CAT.VI_0300_Full_Object_Map AS lat
	ON tmp.Server_Name = lat.REG_Server_Name
	AND tmp.Database_Name = lat.REG_Database_Name
	AND tmp.Schema_Bound_Name = lat.Schema_Bound_Name
	AND tmp.Column_Name = lat.REG_Column_Name
	EXCEPT
	SELECT LNK_T4_ID, Server_Name, Database_Name, Schema_Bound_Name, Column_Name, Column_Type, Collate_Flag
	FROM '+@SourceDBLocation+'.TMP.TRK_0354_Value_Hash_Objects


	INSERT INTO '+@SourceDBLocation+'.TMP.TRK_0354_Value_Hash (LNK_T4_ID, Column_Value, Value_Count)
	
	SELECT DISTINCT LNK_T4_ID, Column_Value, Value_Count
	FROM #TRK_0354_Value_Hash AS tmp
	JOIN '+@SourceDBLocation+'.CAT.VI_0300_Full_Object_Map AS lat
	ON tmp.Server_Name = lat.REG_Server_Name
	AND tmp.Database_Name = lat.REG_Database_Name
	AND tmp.Schema_Bound_Name = lat.Schema_Bound_Name
	AND tmp.Column_Name = lat.REG_Column_Name
	WHERE String_Flag = 0


	INSERT INTO '+@SourceDBLocation+'.TMP.TRK_0354_Long_String_Values (LNK_T4_ID, String, Value_Count, Batch_ID)
	
	SELECT DISTINCT LNK_T4_ID, Column_Value, Value_Count
	, RIGHT(''0000000000''+CAST(ROW_NUMBER() OVER(PARTITION BY LNK_T4_ID ORDER BY Column_Value, Value_Count) AS VARCHAR),10) AS Batch_ID
	FROM #TRK_0354_Value_Hash AS tmp
	JOIN '+@SourceDBLocation+'.CAT.VI_0300_Full_Object_Map AS lat
	ON tmp.Server_Name = lat.REG_Server_Name
	AND tmp.Database_Name = lat.REG_Database_Name
	AND tmp.Schema_Bound_Name = lat.Schema_Bound_Name
	AND tmp.Column_Name = lat.REG_Column_Name
	WHERE String_Flag = 1

	TRUNCATE TABLE #TRK_0354_Value_Hash

END

FETCH NEXT FROM SplayStruct
INTO @TblID, @DatabaseName, @SchemaBoundName, @ColumnName, @ColumnType, @CollateFlag


IF len(@Splay) <= 3500
BEGIN

	IF '+cast(@ExecuteStatus as nvarchar)+' in (0,1)
	BEGIN
		PRINT @Splay
	END

	IF '+cast(@ExecuteStatus as nvarchar)+' in (1,2,3)
	BEGIN
		EXEC sp_executeSQL @Splay
	END

	SET @Splay = ''''
'

SET @SQL4 = '
	INSERT INTO '+@SourceDBLocation+'.TMP.TRK_0354_Value_Hash_Objects (LNK_T4_ID, Server_Name, Database_Name, Schema_Bound_Name, Column_Name, Column_Type, Collate_Flag)
	SELECT DISTINCT lat.LNK_T4_ID, tmp.Server_Name, tmp.Database_Name, tmp.Schema_Bound_Name, tmp.Column_Name, tmp.Column_Type, tmp.Collate_Flag
	FROM #TRK_0354_Value_Hash AS tmp
	JOIN '+@SourceDBLocation+'.CAT.VI_0300_Full_Object_Map AS lat
	ON tmp.Server_Name = lat.REG_Server_Name
	AND tmp.Database_Name = lat.REG_Database_Name
	AND tmp.Schema_Bound_Name = lat.Schema_Bound_Name
	AND tmp.Column_Name = lat.REG_Column_Name
	EXCEPT
	SELECT LNK_T4_ID, Server_Name, Database_Name, Schema_Bound_Name, Column_Name, Column_Type, Collate_Flag
	FROM '+@SourceDBLocation+'.TMP.TRK_0354_Value_Hash_Objects


	INSERT INTO '+@SourceDBLocation+'.TMP.TRK_0354_Value_Hash (LNK_T4_ID, Column_Value, Value_Count)
	
	SELECT DISTINCT LNK_T4_ID, Column_Value, Value_Count
	FROM #TRK_0354_Value_Hash AS tmp
	JOIN '+@SourceDBLocation+'.CAT.VI_0300_Full_Object_Map AS lat
	ON tmp.Server_Name = lat.REG_Server_Name
	AND tmp.Database_Name = lat.REG_Database_Name
	AND tmp.Schema_Bound_Name = lat.Schema_Bound_Name
	AND tmp.Column_Name = lat.REG_Column_Name
	WHERE String_Flag = 0


	INSERT INTO '+@SourceDBLocation+'.TMP.TRK_0354_Long_String_Values (LNK_T4_ID, String, Value_Count, Batch_ID)
	
	SELECT DISTINCT LNK_T4_ID, Column_Value, Value_Count
	, RIGHT(''0000000000''+CAST(ROW_NUMBER() OVER(PARTITION BY LNK_T4_ID ORDER BY Column_Value, Value_Count) AS VARCHAR),10) AS Batch_ID
	FROM #TRK_0354_Value_Hash AS tmp
	JOIN '+@SourceDBLocation+'.CAT.VI_0300_Full_Object_Map AS lat
	ON tmp.Server_Name = lat.REG_Server_Name
	AND tmp.Database_Name = lat.REG_Database_Name
	AND tmp.Schema_Bound_Name = lat.Schema_Bound_Name
	AND tmp.Column_Name = lat.REG_Column_Name
	WHERE String_Flag = 1

	TRUNCATE TABLE #TRK_0354_Value_Hash
END

FETCH NEXT FROM SplayStruct
INTO @TblID, @DatabaseName, @SchemaBoundName, @ColumnName, @ColumnType, @CollateFlag

END

CLOSE SplayStruct
DEALLOCATE SplayStruct
'


IF @ExecuteStatus in (0)
BEGIN
	SELECT 'CSR_SplayStruct_1' AS SQL_Object_Name, @SQL1
	SELECT 'TRK_0354_Value_Hash' AS SQL_Object_Name, @SQL2
	SELECT 'CSR_SplayStruct_2' AS SQL_Object_Name, @SQL3
	SELECT 'CSR_SplayStruct_3' AS SQL_Object_Name, @SQL4
END


IF @ExecuteStatus in (3)
BEGIN
	SELECT CAST(@SQL1 AS nvarchar(MAX))+CAST(@SQL2 AS nvarchar(MAX))+CAST(@SQL3 AS nvarchar(MAX))+CAST(@SQL4 AS nvarchar(MAX)) AS SQLText
END


IF @ExecuteStatus in (1)
BEGIN
	PRINT @SQL1
	PRINT @SQL2
	PRINT @SQL3
	PRINT @SQL4
END


IF @ExecuteStatus in (1,2)
BEGIN
	SET @SQL = CAST(@SQL1 AS nvarchar(MAX))+CAST(@SQL2 AS nvarchar(MAX))+CAST(@SQL3 AS nvarchar(MAX))+CAST(@SQL4 AS nvarchar(MAX))
	EXEC sp_ExecuteSQL @SQL
END