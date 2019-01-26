

CREATE PROCEDURE [LIB].[TXT_011_String_Mapper]

--declare

@Segment INT = 1
, @MaxLen INT = 4000
, @Source NVARCHAR(256) = 'TMP.TXT_Process_Hash'
, @Destination NVARCHAR(256) = 'TMP.TXT_String_Map'
, @ExecuteStatus TINYINT = 2

AS

DECLARE @SQL NVARCHAR(MAX)
, @SQL1 NVARCHAR(4000)
, @SQL2 NVARCHAR(4000)


/* Prime CleanString table for insertion - this is a bottleneck process - streamline if possible */

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'tdx_nc_TXT_String_Map_K3_I2')
BEGIN
	DROP INDEX [tdx_nc_TXT_String_Map_K3_I2] ON TMP.TXT_String_Map 
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'pk_TXT_String_Map')
BEGIN
	ALTER TABLE TMP.TXT_String_Map DROP CONSTRAINT [pk_TXT_String_Map] 
END


/* Turn off count, and begin rebarring local StringMap - It's faster than it sounds. */

SET @SQL1 = '
DECLARE @StrIdx INT = 1
SET NOCOUNT ON
WHILE @StrIdx <= '+CAST(@MaxLen as NVARCHAR)+'
BEGIN
	INSERT INTO '+@Destination+'_'+CASE WHEN @ExecuteStatus = 3 THEN '"+@[User::Segment]+"' ELSE CAST(@Segment AS NVARCHAR) END+' (Source_ID, ASCII_Char, Char_Pos)
	SELECT Source_ID
	, ascii(SUBSTRING(String, (('+CASE WHEN @ExecuteStatus = 3 THEN '"+@[User::Segment]+"' ELSE CAST(@Segment AS NVARCHAR) END+'-1) * '+CASE WHEN @ExecuteStatus = 3 THEN '"+@[User::MaxLen]+"' ELSE CAST(@MaxLen as NVARCHAR) END+') + @StrIdx, 1))
	, (('+CASE WHEN @ExecuteStatus = 3 THEN '"+@[User::Segment]+"' ELSE CAST(@Segment AS NVARCHAR) END+'-1) * '+CAST(@MaxLen as NVARCHAR)+') + @StrIdx
	FROM '+@Source+' WITH(NOLOCK)
	WHERE ascii(SUBSTRING(String, (('+CASE WHEN @ExecuteStatus = 3 THEN '"+@[User::Segment]+"' ELSE CAST(@Segment AS NVARCHAR) END+'-1) * '+CASE WHEN @ExecuteStatus = 3 THEN '"+@[User::MaxLen]+"' ELSE CAST(@MaxLen as NVARCHAR) END+') + @StrIdx, 1)) IS NOT NULL
	ORDER BY Source_ID
SET @StrIdx = @StrIdx + 1
END
'

IF @ExecuteStatus <> 3 AND NOT EXISTS (SELECT name FROM sys.all_objects WHERE object_id = object_ID(N''+@Destination+'_'+CAST(@Segment AS NVARCHAR)+''))
SET @SQL1 = '
CREATE TABLE '+@Destination+'_'+CAST(@Segment AS NVARCHAR)+' (Source_ID INT, ASCII_Char TINYINT, Char_Pos BIGINT);
' + @SQL1


SET @SQL2 = '
SET NOCOUNT OFF

; INSERT INTO '+@Destination+' (Source_ID, Char_Pos, ASCII_Char)
SELECT Source_ID, Char_Pos, ASCII_Char
FROM '+@Destination+'_'+CASE WHEN @ExecuteStatus = 3 THEN '"+@[User::Segment]+"' ELSE CAST(@Segment AS NVARCHAR) END+'

; DROP TABLE '+@Destination+'_'+CASE WHEN @ExecuteStatus = 3 THEN '"+@[User::Segment]+"' ELSE CAST(@Segment AS NVARCHAR) END+'
' 


IF @ExecuteStatus in (0,1)
BEGIN
	PRINT @SQL1
	PRINT @SQL2
END

IF @ExecuteStatus = 3
BEGIN
	SELECT '1' AS StmtID, '"'+@SQL1+'"' AS SQLStatement
	UNION
	SELECT '2' AS StmtID, '"'+@SQL2+'"' AS SQLStatement
END

IF @ExecuteStatus IN (1,2)
BEGIN
	SET @SQL = CAST(@SQL1 AS NVARCHAR(MAX))+CAST(@SQL2 AS NVARCHAR(MAX))
	EXEC sp_ExecuteSQL @SQL
END