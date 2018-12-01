


--select hcd.Source_ID, hcr.Collection_ID, hcr.Rule_Value, lrr.Rule_Type, lrr.Rule_Name, lrr.Rule_Desc
--from LIB.HSH_Collection_Rules AS hcr WITH(NOLOCK)
--join LIB.VI_2119_Simple_Collection_List AS scl WITH(NOLOCK)
--on CAST(hcr.Collection_ID AS VARCHAR) = RIGHT(scl.Collection_Key, LEN(hcr.Collection_ID))
--and scl.Link_Type = 1
--and GETDATE() BETWEEN hcr.Post_Date AND hcr.Term_Date
--join LIB.HSH_Collection_Documents AS hcd WITH(NOLOCK)
--on hcd.Collection_ID = hcr.Collection_ID
--join LIB.REG_Rules as lrr
--on lrr.Rule_ID = hcr.Rule_ID
--where hcd.Source_ID IN (19949,21471,21558,21371,21346) -- 540+1048+10090+236309+322538
--order by Source_ID



--select hcd.Source_ID, clt.Name, doc.Title, doc.Author, src.Version_Stamp, src.File_Path
--from LIB.HSH_Collection_Documents as hcd
--join LIB.REG_Documents as doc
--on doc.Document_ID = hcd.Document_ID
--join LIB.REG_Sources as src
--on src.Source_ID = hcd.Source_ID
--join LIB.REG_Collections as clt
--on clt.Collection_ID = hcd.Collection_ID
--and clt.Name not in ('File Types')
--where getdate() between hcd.Post_Date and hcd.Term_Date
--and hcd.Source_ID IN (19942,19949,21471,21558,21371,21346) -- 540+1048+10090+236309+322538
--order by Source_ID, Title, Version_Stamp




--DECLARE @TargetSize NVARCHAR(16)

--SELECT @TargetSize = sum(String_Length) * 2 / 1048576 FROM TMP.TXT_Process_Hash

--EXEC('ALTER DATABASE tempdb MODIFY FILE
--   (NAME = ''templog'', SIZE = '+@TargetSize+')')

---- DROP TABLE ##WordBase

SELECT tsm.Source_ID
, CAST(NULL AS BIGINT) as Line_No
, CAST(tsm.ASCII_Char AS VARCHAR(3)) as ASCII_Char
, tsm.Char_Pos, CASE WHEN alp.Printable = 1 THEN alp.Char_Val ELSE '' END as Char_Val
, CAST(NULL AS NVARCHAR(4000)) as Word
INTO ##WordBase
FROM TMP.TXT_String_Map AS tsm WITH(NOLOCK)
JOIN LIB.REG_Alphabet AS alp WITH(NOLOCK)
ON alp.ASCII_Char = tsm.ASCII_Char
--LEFT JOIN (
--	SELECT DISTINCT hcd.Source_ID, hcr.Rule_Value
--	FROM LIB.HSH_Collection_Rules AS hcr WITH(NOLOCK)
--	JOIN LIB.VI_2119_Simple_Collection_List AS scl WITH(NOLOCK)
--	ON CAST(hcr.Collection_ID AS VARCHAR) = RIGHT(scl.Collection_Key, LEN(hcr.Collection_ID))
--	AND scl.Link_Type = 1
--	AND GETDATE() BETWEEN hcr.Post_Date AND hcr.Term_Date
--	JOIN LIB.HSH_Collection_Documents AS hcd WITH(NOLOCK)
--	ON hcd.Collection_ID = hcr.Collection_ID
--		--where hcr.Rule_Value not in (32,13,10) -- Using a hardcoded array for these until this process is refined and a full range of rules and use are understood/defined; then switch to 'restringer' method
--	) AS hcr
--ON hcr.Source_ID = tsm.Source_ID
WHERE 1=1

CREATE CLUSTERED INDEX tdx_ci_WordBase_K1_K4 ON ##WordBase (Source_ID, Char_Pos)


--select * from ##WordBase


CREATE TABLE #DelimiterChars (Delimiter_Char TINYINT)
INSERT INTO #DelimiterChars (Delimiter_Char)
VALUES (10)	-- CR
, (13) -- LF
, (32) -- <space>
, (124) -- <pipe>

-- select * from #DelimiterChars

; SET NOCOUNT ON
	
DECLARE @Word NVARCHAR(4000) = ''
, @Line_No BIGINT = 1
, @SourceID BIGINT

UPDATE t1 SET 
	@Word = t1.Word = CASE WHEN ISNULL(@SourceID, Source_ID) = Source_ID AND ISNULL(crp.Delimiter_Char,'') = '' THEN @Word+t1.Char_Val		-- Patindex causing values like 10 to be mixed with values like 110 for ASCII_Chars
	ELSE @Word END
	, @Word = CASE WHEN t1.ASCII_Char = crp.Delimiter_Char THEN '' ELSE @Word END
	, @Line_No = t1.Line_No = CASE WHEN @SourceID != Source_ID THEN 1
		WHEN t1.ASCII_Char IN (10,13) THEN @Line_No + 1
		ELSE @Line_No END
	, @SourceID= Source_ID
FROM ##WordBase AS t1
LEFT JOIN #DelimiterChars AS crp
ON crp.Delimiter_Char = t1.ASCII_Char

OPTION(MAXDOP 1)

SET NOCOUNT OFF



/* How many columns per file? */

select Source_ID
, sum(CASE WHEN ASCII_Char = 124 THEN 1 ELSE 0 END) 
/ sum(CASE WHEN ASCII_Char = 10 THEN 1 ELSE 0 END) * 1.000 as ColumnCount
from ##WordBase
group by Source_ID
order by Source_ID


/* How many lines per file? */
select Source_ID
, sum(CASE WHEN ASCII_Char = 10 THEN 1 ELSE 0 END) + 1 as Records
from ##WordBase
group by Source_ID
order by Source_ID

-- DROP TABLE #StructureSet

select Source_ID, Line_No
, ROW_NUMBER() OVER (PARTITION BY Source_ID, Line_No ORDER BY Char_Pos) AS Column_ID
, Word
into #StructureSet
from (
	select dom.Source_ID, line_No, dom.Char_Pos, dom.Word
	from ##WordBase AS dom WITH(NOLOCK)
	where dom.ASCII_Char IN (124)
	) as sub
order by Source_ID, Line_No, Char_Pos
option(recompile)



DECLARE @SQL nvarchar(4000) = ''
, @TargetDatabaseName nvarchar(256) = 'pp_drugs_hash'
, @TargetSchemaName nvarchar(256) = 'dbo'
, @TableName nvarchar(256)
, @TableNameLast nvarchar(256) = NULL
, @ColumnName nvarchar(256)
, @ColumnSize nvarchar(10)
, @IntFlag tinyint
, @VarFlag tinyint

DECLARE TableBuilder CURSOR FOR
SELECT replace(lrd.Title,lrc.Name,'') as TableName
, 'COLUMN_'+cast(Column_ID as varchar)
, CASE WHEN MIN(LEN(Word)) != MAX(LEN(Word)) AND MAX(LEN(Word)) > 8 THEN (MAX(LEN(Word))/8) + 1
	ELSE MAX(LEN(Word)) END * 8 as ColumnSize
, CASE WHEN MAX(PATINDEX('%[^0-9]%',Word)) = 0 THEN 1 ELSE 0 END as IntFlag
, CASE WHEN MIN(LEN(Word)) != MAX(LEN(Word)) THEN 1 ELSE 0 END as VarFlag
FROM #StructureSet as tmp
LEFT JOIN TMP.TXT_Process_Hash as hsh
ON hsh.Source_ID = tmp.Source_ID
LEFT JOIN LIB.REG_Collections as lrc
ON lrc.Collection_ID = hsh.Collection_ID
LEFT JOIN LIB.HSH_Collection_Documents as hcd
ON hcd.Source_ID = tmp.Source_ID
LEFT JOIN LIB.REG_Documents as lrd
ON lrd.Document_ID = hcd.Document_ID
GROUP BY hsh.Source_ID, lrc.Name, lrd.Title, Column_ID
ORDER BY hsh.Source_ID, tmp.Column_ID

OPEN TableBuilder

FETCH NEXT FROM TableBuilder
INTO @TableName, @ColumnName, @ColumnSize, @IntFlag, @VarFlag

WHILE @@FETCH_STATUS = 0
BEGIN

SELECT @SQL = CASE WHEN ISNULL(@TableNameLast,@TableName) != @TableName THEN @SQL+')' ELSE @SQL END

IF ISNULL(@TableNameLast,@TableName) != @TableName PRINT @SQL

SET @SQL = CASE WHEN @TableName != @TableNameLast OR @TableNameLast IS NULL THEN
	'CREATE TABLE '+@TargetDatabaseName+'.'+@TargetSchemaName+'.'+@TableName+' ('
	+ CHAR(10)+@ColumnName+' '
		+ CASE WHEN @IntFlag = 0 AND @VarFlag = 1 THEN 'VARCHAR ('+@ColumnSize+')'
			WHEN @IntFlag = 0 AND @VarFlag = 0 THEN 'CHAR ('+@ColumnSize+')'
			WHEN @IntFlag = 1 THEN 'INT' END
	ELSE @SQL + CHAR(10) +', '+@ColumnName+' '
		+ CASE WHEN @IntFlag = 0 AND @VarFlag = 1 THEN 'VARCHAR ('+@ColumnSize+')'
			WHEN @IntFlag = 0 AND @VarFlag = 0 THEN 'CHAR ('+@ColumnSize+')'
			WHEN @IntFlag = 1 THEN 'INT' END 
			END

SET @TableNameLast = @Tablename

FETCH NEXT FROM TableBuilder
INTO @TableName, @ColumnName, @ColumnSize, @IntFlag, @VarFlag

END

SELECT @SQL = CASE WHEN ISNULL(@TableNameLast,@TableName) != @TableName THEN @SQL+')' ELSE @SQL END

IF ISNULL(@TableNameLast,@TableName) != @TableName PRINT @SQL

CLOSE TableBuilder
DEALLOCATE TableBuilder


