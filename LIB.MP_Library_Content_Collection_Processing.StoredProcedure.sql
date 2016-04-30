USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[MP_Library_Content_Collection_Processing]') AND type in (N'P', N'PC'))
DROP PROCEDURE [LIB].[MP_Library_Content_Collection_Processing]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[MP_Library_Content_Collection_Processing]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [LIB].[MP_Library_Content_Collection_Processing]
AS

/* Library Content Logging */
/** Insert simple values into dictionary 

Insert only the first to Quartiles of data by cardinality
as a specific insert. **/

INSERT INTO LIB.REG_Dictionary (Word,Post_Date)
SELECT Column_Value, MIN(tmp.Post_Date) as Post_Date
FROM TMP.TRK_0354_Value_Hash AS tmp WITH(NOLOCK)
LEFT JOIN LIB.REG_Dictionary AS lib WITH(NOLOCK)
ON lib.Word = tmp.Column_Value
WHERE ISNULL(Column_Value,'''') <> ''''
AND ISNUMERIC(Column_Value) = 0
AND lib.Word_ID IS NULL
GROUP BY Column_Value
ORDER BY SUM(tmp.Value_Count) DESC, Column_Value


/** Insert Source Attributions **/

SELECT trk.TBL_ID, trk.LNK_T4_ID, trk.Server_Name, trk.Schema_Bound_Name, trk.Database_Name, trk.Column_Name
, ''VHASH:''+CAST(YEAR(GETDATE()) AS CHAR(4))+RIGHT(''00''+CAST(MONTH(GETDATE()) AS VARCHAR(2)),2)+RIGHT(''00''+CAST(DAY(GETDATE()) AS VARCHAR(2)),2)
+'':''+RIGHT(''0000000000''+CAST(VI.LNK_T3_ID AS VARCHAR),10)
+'':''+RIGHT(''0000000000''+CAST(VI.LNK_T4_ID AS VARCHAR),10)
+'':''+RIGHT(''000''+CAST((trk.TBL_ID/100) as VARCHAR),3) as VersionStamp
INTO #LibraryInsert
FROM TMP.TRK_0354_Value_Hash_Objects AS TRK 
LEFT JOIN CAT.VI_0200_Column_Tier_Latches AS VI
ON VI.REG_Server_Name = TRK.Server_Name
AND VI.Schema_Bound_Name = TRK.Schema_Bound_Name
AND CHARINDEX(TRK.Column_Name, VI.Column_Definition) > 0


/** Create a VersionStamp hash to enter items into the Library collection **/

INSERT INTO LIB.REG_Sources (Version_Stamp)
SELECT VersionStamp
FROM #LibraryInsert


/** Attribute Collection and Word ID for links **/

INSERT INTO LIB.HSH_Collection_Lexicon (Collection_ID, Source_ID, Column_ID, Word_ID, Post_Date, Use_Count)

SELECT DISTINCT reg.Collection_ID, src.Source_ID, trk.LNK_T4_ID, dic.Word_ID, trk.Post_Date, trk.Value_Count
FROM #LibraryInsert as tmp
JOIN TMP.TRK_0354_Value_Hash as trk
ON trk.LNK_T4_ID = tmp.LNK_T4_ID
JOIN LIB.REG_Dictionary as dic
ON dic.Word = trk.Column_Value
JOIN LIB.REG_Sources as src
ON src.Version_Stamp = tmp.VersionStamp
JOIN LiB.REG_Collections as reg
ON tmp.Server_Name = reg.Name
OR tmp.Database_Name = reg.Name
OR CHARINDEX(reg.Name, tmp.Schema_Bound_Name) > 0



--/* Process Long-String Values */
--/** Update Longstring table with Source_ID values to process via standard string mapping. **/

--UPDATE tbl SET Source_ID = tbl.TBL_ID
--FROM TMP.TRK_0354_Long_String_Values AS tbl


--/** Exeucute String Mapper, and String Processor **/

--DECLARE @MaxLen INT

--SELECT @MaxLen = max(len(String))
--FROM TMP.TRK_0354_Long_String_Values AS tbl

--EXEC LIB.TXT_011_String_Mapper
--@Source = ''TMP.TRK_0354_Long_String_Values'',
--@Segment = 1,
--@MaxLen = @MaxLen,
--@ExecuteStatus = 1


--/** Apply clean indexes to map prior to shredding **/

--IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = ''pk_TXTStringMap'')
--BEGIN
--	ALTER TABLE [TMP].[TXT_String_Map] ADD  CONSTRAINT [pk_TXTStringMap] PRIMARY KEY CLUSTERED 
--	([Source_ID] ASC,[Char_Pos] ASC) 
--	ON [PRIMARY]
--END


--IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = ''tdx_nc_TXTStringMap_K3_I2'')
--BEGIN
--	CREATE NONCLUSTERED INDEX [tdx_nc_TXTStringMap_K3_I2] ON [TMP].[TXT_String_Map] 
--	([Char_Pos] ASC)
--	INCLUDE ([ASCII_Char]) 
--	ON [PRIMARY]
--END


--/** Create Value Process Hash **/

--SELECT DISTINCT T3.Collection_ID, T4.Source_ID, T2.LNK_T4_ID, T1.TBL_ID
--INTO #ValueProcessHash
--FROM TMP.TRK_0354_Long_String_Values AS T1
--JOIN TMP.TRK_0354_Value_Hash_Objects AS T2 WITH(NOLOCK)
--ON T2.LNK_T4_ID = T1.LNK_T4_ID
--JOIN LIB.REG_Collections AS T3 WITH(NOLOCK)
--ON T3.Name = T2.Database_Name
--JOIN #LibraryInsert AS M1
--ON M1.LNK_T4_ID = T2.LNK_T4_ID
--JOIN LIB.REG_Sources AS T4 WITH(NOLOCK)
--ON T4.Version_Stamp = M1.VersionStamp


--/** Insert Collection Alphabetix **/

--INSERT INTO LIB.HSH_Collection_Alphabet (Collection_ID, Source_ID, ASCII_Char, Use_Count)
--SELECT T2.Collection_ID, T2.Source_ID, T1.ASCII_Char, COUNT(*)
--FROM TMP.TXT_String_Map AS T1
--JOIN #ValueProcessHash AS T2
--ON T2.TBL_ID = T1.Source_ID
--GROUP BY T2.Collection_ID, T2.Source_ID, T1.ASCII_Char


--/** Insert Collection Glyphs **/

--INSERT INTO [LIB].[HSH_Collection_Glyphs] (Collection_ID, Source_ID, Glyph_ID, Use_Count)
--SELECT T1.Collection_ID, T1.Source_ID, Glyph_ID, COUNT(*)
--FROM #ValueProcessHash AS T1
--JOIN TMP.TXT_String_Map AS M1 WITH(NOLOCK)
--ON M1.Source_ID = T1.TBL_ID
--JOIN TMP.TXT_String_Map AS M2 WITH(NOLOCK)
--ON M2.Source_ID = T1.TBL_ID
--AND M2.Char_Pos = M1.Char_Pos + 1
--CROSS APPLY LIB.GlyphList AS GL
--WHERE GL.ASCII_Char1 = M1.ASCII_Char
--AND GL.ASCII_Char2 = M2.ASCII_Char
--GROUP BY T1.Collection_ID, T1.Source_ID, Glyph_ID


--/** Insert Unique Words from Longstring **/

--IF EXISTS (SELECT name FROM tempdb.sys.tables WHERE name like ''#CodeBounds%'')
--DROP TABLE #CodeBounds

--SELECT Source_ID, min(Char_Pos) as Map_Anchor, max(Char_Pos) as Map_Bound
--INTO #CodeBounds
--FROM TMP.TXT_String_Map AS map with(nolock)
--GROUP BY Source_ID


--IF EXISTS (SELECT name FROM tempdb.sys.tables WHERE name like ''#TerminalGlyphs%'')
--DROP TABLE #TerminalGlyphs

--SELECT M1.Source_ID, M2.Char_Pos
--INTO #TerminalGlyphs
--FROM [TMP].[TXT_String_Map] AS M1
--JOIN [TMP].[TXT_String_Map] AS M2
--ON M1.ASCII_Char IN (9,10,13,32)
--AND M2.Source_ID = M1.Source_ID
--AND M2.Char_Pos = M1.Char_Pos + 1
--WHERE M2.ASCII_Char NOT IN (9,10,13,32)
--UNION
--SELECT Source_ID, 1
--FROM TMP.TXT_String_Map 
--GROUP BY Source_ID 


--; WITH Lines (Source_ID, Line_Rank, Line_Anchor, Line_Bound)
--AS (
--	SELECT t1.Source_ID, t1.Line_Rank, t1.Char_Pos as Line_Anchor
--	, min(isnull(t2.Char_Pos, TMP.Map_Bound)) as Line_Bound
--	FROM (
--		SELECT Source_ID, Char_Pos, DENSE_Rank() over (partition by Source_ID order by Char_Pos) as Line_Rank
--		FROM #TerminalGlyphs
--		) AS t1
--	LEFT JOIN (
--		SELECT Source_ID, Char_Pos - 1 as Char_Pos, DENSE_Rank() over (partition by Source_ID order by Char_Pos) as Line_Rank
--		FROM #TerminalGlyphs
--		) AS t2
--	ON t2.Source_ID = t1.Source_ID
--	AND t2.Char_Pos > t1.Char_Pos
--	JOIN #CodeBounds AS tmp
--	ON TMP.Source_ID = t1.Source_ID
--	GROUP BY t1.Source_ID, t1.Line_Rank, t1.Char_Pos
--	)

----INSERT INTO TMP.TXT_Parsed_Segments (Source_ID, Anchor, Bound, Segment)

--SELECT DISTINCT stk.Source_ID, cte.Line_Anchor, cte.Line_Bound
--, SUBSTRING(lsv.STring, cte.Line_Anchor, (cte.Line_Bound - cte.Line_Anchor) + 1 )
--FROM Lines AS cte
--JOIN #ValueProcessHash AS stk
--ON stk.TBL_ID = cte.Source_ID
--LEFT JOIN TMP.TRK_0354_Long_String_Values as lsv
--ON lsv.TBL_ID = stk.TBL_ID
--ORDER BY stk.Source_ID, cte.Line_Anchor
' 
END
GO
