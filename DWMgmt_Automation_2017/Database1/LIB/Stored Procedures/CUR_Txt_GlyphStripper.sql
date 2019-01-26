

CREATE PROCEDURE [LIB].[CUR_Txt_GlyphStripper]
AS

/* Register "Glyphs" - two character combinations which form word components */
SELECT CV1.Source_ID
, CV1.ASCII_Char AS ASCII_Char1
, CV2.ASCII_Char AS ASCII_Char2
INTO #FlatMap
FROM TMP.TMP_StringMap AS CV1
JOIN TMP.TMP_StringMap AS CV2
ON CV1.Source_ID = CV2.Source_ID
AND CV1.Char_Pos = CV2.Char_Pos - 1
AND CV2.Char_Pos > 1
ORDER BY 2,3

CREATE CLUSTERED INDEX tdx_FlatMap ON #FlatMap
(ASCII_Char1, ASCII_Char2)


INSERT INTO LIB.HSH_Collection_Glyphs (Collection_ID, Glyph_ID, Use_Count)
SELECT glp.Glyph_ID, hsh.Collection_ID, COUNT(*) as Use_Count
FROM #FlatMap AS map
JOIN LIB.REG_Glyphs AS glp with(nolock)
ON glp.ASCII_Char1 = map.ASCII_Char1
AND glp.ASCII_Char2 = map.ASCII_Char2
LEFT JOIN TMP.TMP_ProcessHash AS hsh with(nolock)
ON hsh.Source_ID = map.Source_ID
GROUP BY glp.Glyph_ID, hsh.Collection_ID
ORDER BY Use_Count DESC