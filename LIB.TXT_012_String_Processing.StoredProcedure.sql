USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[TXT_012_String_Processing]') AND type in (N'P', N'PC'))
DROP PROCEDURE [LIB].[TXT_012_String_Processing]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[TXT_012_String_Processing]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [LIB].[TXT_012_String_Processing]
AS

/* Load Alphabet */

INSERT INTO LIB.HSH_Collection_Alphabet (Collection_ID, Source_ID, ASCII_Char, Use_Count)

SELECT hcd.Collection_ID, hcd.Source_ID, tmp.ASCII_Char, COUNT(*)
FROM LIB.HSH_Collection_Documents AS hcd WITH(NOLOCK)
JOIN TMP.TXT_String_Map AS tmp WITH(NOLOCK)
ON hcd.Source_ID = tmp.Source_ID
GROUP BY hcd.Collection_ID, hcd.Source_ID, tmp.ASCII_Char


/* Load Glyphs */

INSERT INTO [LIB].[HSH_Collection_Glyphs] (Collection_ID, Source_ID, Glyph_ID, Use_Count)

SELECT T1.Collection_ID, T1.Source_ID, Glyph_ID, COUNT(*)
FROM TMP.TXT_Process_Hash AS T1 WITH(NOLOCK)
JOIN TMP.TXT_String_Map AS M1 WITH(NOLOCK)
ON M1.Source_ID = T1.Source_ID
JOIN TMP.TXT_String_Map AS M2 WITH(NOLOCK)
ON M2.Source_ID = T1.Source_ID
AND M2.Char_Pos = M1.Char_Pos + 1
CROSS APPLY LIB.GlyphList AS GL
WHERE GL.ASCII_Char1 = M1.ASCII_Char
AND GL.ASCII_Char2 = M2.ASCII_Char
GROUP BY T1.Collection_ID, T1.Source_ID, Glyph_ID


/* Prepare Word processing */

IF EXISTS (SELECT name FROM tempdb.sys.tables WHERE name like ''#CodeBounds%'')
DROP TABLE #CodeBounds

SELECT Source_ID, min(Char_Pos) as Map_Anchor, max(Char_Pos) as Map_Bound
INTO #CodeBounds
FROM TMP.TXT_String_Map AS map with(nolock)
GROUP BY Source_ID


IF EXISTS (SELECT name FROM tempdb.sys.tables WHERE name like ''#TerminalGlyphs%'')
DROP TABLE #TerminalGlyphs

SELECT M1.Source_ID, M2.Char_Pos
INTO #TerminalGlyphs
FROM [TMP].[TXT_String_Map] AS M1
JOIN [TMP].[TXT_String_Map] AS M2
ON M1.ASCII_Char IN (9,10,13,32)
AND M2.Source_ID = M1.Source_ID
AND M2.Char_Pos = M1.Char_Pos + 1
WHERE M2.ASCII_Char NOT IN (9,10,13,32)
UNION
SELECT Source_ID, 1
FROM TMP.TXT_String_Map 
GROUP BY Source_ID 


; WITH Lines (Source_ID, Line_Rank, Line_Anchor, Line_Bound)
AS (
	SELECT t1.Source_ID, t1.Line_Rank, t1.Char_Pos as Line_Anchor
	, min(isnull(t2.Char_Pos, TMP.Map_Bound)) as Line_Bound
	FROM (
		SELECT Source_ID, Char_Pos, DENSE_Rank() over (partition by Source_ID order by Char_Pos) as Line_Rank
		FROM #TerminalGlyphs
		) AS t1
	LEFT JOIN (
		SELECT Source_ID, Char_Pos - 1 as Char_Pos, DENSE_Rank() over (partition by Source_ID order by Char_Pos) as Line_Rank
		FROM #TerminalGlyphs
		) AS t2
	ON t2.Source_ID = t1.Source_ID
	AND t2.Char_Pos > t1.Char_Pos
	JOIN #CodeBounds AS tmp
	ON TMP.Source_ID = t1.Source_ID
	GROUP BY t1.Source_ID, t1.Line_Rank, t1.Char_Pos
	)

INSERT INTO TMP.TXT_Parsed_Segments (Source_ID, Anchor, Bound, Segment)

SELECT DISTINCT cte.Source_ID, cte.Line_Anchor, cte.Line_Bound
, substring(stk.String, cte.Line_Anchor, (cte.Line_Bound - cte.Line_Anchor) + 1 )
FROM Lines AS cte
JOIN TMP.TXT_Process_Hash AS stk
ON stk.Source_ID = cte.Source_ID
left join LIB.External_String_Intake_Stack as cis
on cis.Version_Stamp = stk.Version_Stamp
ORDER BY cte.Source_ID, cte.Line_Anchor


/* Insert the words into the universal dictionary. */

INSERT INTO LIB.REG_Dictionary (Word)

SELECT DISTINCT Segment
FROM TMP.TXT_Parsed_Segments
WHERE len(Segment) > 256

/* Insert the word utilization into the collection lexicon */

INSERT INTO [LIB].[HSH_Collection_Lexicon] (Collection_ID, Source_ID, Word_ID, Use_Count)

SELECT T2.Collection_ID, T1.Source_ID, R1.Word_ID, COUNT(*)
FROM TMP.TXT_Parsed_Segments AS T1 WITH(NOLOCK)
JOIN TMP.TXT_Process_Hash AS T2 WITH(NOLOCK)
ON T2.Source_ID = T1.Source_ID
JOIN LIB.REG_Dictionary AS R1 WITH(NOLOCK)
ON R1.Word = T1.Segment
GROUP BY T2.Collection_ID, T1.Source_ID, R1.Word_ID


' 
END
GO
