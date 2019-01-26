

CREATE VIEW [LIB].[VC_2110_Collection_Alphabet]
AS
SELECT DENSE_Rank() OVER(ORDER BY col.Name, SUM(hca.Use_Count) DESC, alp.ASCII_Char) as VID
, col.Name as Collection_Name
, alp.Char_Val
, alp.ASCII_Char
, SUM(hca.Use_Count) AS Use_Count
FROM LIB.HSH_Collection_Alphabet AS hca WITH(NOLOCK)
JOIN LIB.REG_Alphabet AS alp WITH(NOLOCK)
ON alp.ASCII_Char = hca.ASCII_Char
JOIN LIB.REG_Collections AS col WITH(NOLOCK)
ON col.Collection_ID = hca.Collection_ID
GROUP BY col.Name
, alp.Char_Val
, alp.ASCII_Char