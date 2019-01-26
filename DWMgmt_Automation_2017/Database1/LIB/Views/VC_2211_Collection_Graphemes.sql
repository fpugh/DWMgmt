

CREATE VIEW [LIB].[VC_2211_Collection_Graphemes]
AS
SELECT DENSE_RANK() OVER(ORDER BY col.Name, SUM(hcg.Use_Count) DESC, alp1.Char_Val+alp2.Char_Val) as VID
, hcg.Collection_ID
, col.Name as Collection_Name
, lrg.Graph_ID
, alp1.Char_Val+alp2.Char_Val as Grapheme
, alp1.Class_VCNS+alp2.Class_VCNS as Grapheme_Class
, lrg.Use_Class
, sum(hcg.Use_Count) as Use_Count
FROM LIB.HSH_Collection_Graphemes AS hcg
JOIN LIB.REG_Graphemes as lrg
ON lrg.Graph_ID = hcg.Graph_ID
JOIN LIB.REG_Alphabet as alp1
ON alp1.ASCII_Char = lrg.ASCII_Char1
JOIN LIB.REG_Alphabet as alp2
ON alp2.ASCII_Char = lrg.ASCII_Char2
LEFT JOIN LIB.REG_Collections as col
ON col.Collection_ID = hcg.Collection_ID
GROUP BY hcg.Collection_ID
, col.Name
, lrg.Graph_ID
, alp1.Char_Val+alp2.Char_Val
, alp1.Class_VCNS+alp2.Class_VCNS
, lrg.Use_Class