USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[CUR_TXT_StringMapper]') AND type in (N'P', N'PC'))
DROP PROCEDURE [LIB].[CUR_TXT_StringMapper]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[CUR_TXT_StringMapper]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [LIB].[CUR_TXT_StringMapper]
@Segment INT = 1
, @MaxLen INT = 4000

AS

DECLARE @SQL NVARCHAR(4000)

/* Prime CleanString table for insertion - this is a bottleneck process - streamline if possible */

IF EXISTS (SELECT * FROM sys.indexes WHERE name = ''tdx_nc_TMP_String_Map_K3_I4'')
BEGIN
	DROP INDEX [tdx_nc_TMP_String_Map_K3_I4] ON TMP.TMP_String_Map 
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = ''pk_TMP_String_Map'')
BEGIN
	ALTER TABLE TMP.TMP_String_Map DROP CONSTRAINT [pk_TMP_String_Map] 
END


/* Turn off count, and begin rebarring local StringMap */
SET NOCOUNT ON

SET @SQL = ''
DECLARE @StrIdx INT = 1

SET NOCOUNT ON

WHILE @StrIdx <= ''+CAST(@MaxLen as nvarchar)+''
BEGIN

	INSERT INTO TMP.TMP_String_Map_''+CAST(@Segment as nvarchar)+'' (Source_ID, ASCII_Char, Char_Pos)
	SELECT Source_ID
	, ascii(SUBSTRING(String, (''+CAST(@Segment - 1 as nvarchar)+'' * ''+CAST(@MaxLen as nvarchar)+'') + @StrIdx, 1))
	, (''+CAST(@Segment - 1 as nvarchar)+'' * ''+CAST(@MaxLen as nvarchar)+'') + @StrIdx
	FROM TMP.SQL_Process_Hash WITH(NOLOCK)
	WHERE ascii(SUBSTRING(String, (''+CAST(@Segment - 1 as nvarchar)+'' * ''+CAST(@MaxLen as nvarchar)+'') + @StrIdx, 1)) IS NOT NULL
	ORDER BY Source_ID

SET @StrIdx = @StrIdx + 1
END


SET NOCOUNT OFF


INSERT INTO TMP.TMP_String_Map (Source_ID, Char_Pos, ASCII_Char)

SELECT Source_ID, Char_Pos, ASCII_Char
FROM TMP.TMP_String_Map_''+CAST(@Segment as nvarchar)+''

DROP TABLE TMP.TMP_String_Map_''+CAST(@Segment as nvarchar)+''
'' 

IF NOT EXISTS (SELECT name FROM sys.all_objects WHERE name = N''TMP_String_Map_''+CAST(@Segment as nvarchar)+'''')
SET @SQL = ''
CREATE TABLE TMP.TMP_String_Map_''+CAST(@Segment as nvarchar)+'' (Source_ID INT, ASCII_Char TINYINT, Char_Pos BIGINT)
'' + @SQL

EXEC sp_ExecuteSQL @SQL
--PRINT @SQL
' 
END
GO
