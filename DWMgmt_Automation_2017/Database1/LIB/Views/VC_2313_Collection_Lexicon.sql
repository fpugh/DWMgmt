

CREATE VIEW [LIB].[VC_2313_Collection_Lexicon]
AS
SELECT col.Name as Collection_Name
, REPLACE(src.File_Path,doc.Title,'') as Collection_Path
, dic.Word
, COUNT(DISTINCT doc.Document_ID) as Attesting_Documents
, MIN(hcl.Use_Count) as Lowest_Attestations
, AVG(hcl.Use_Count) as Average_Attestations
, MAX(hcl.Use_Count) as Highest_Attestations
, SUM(hcl.Use_Count) as Collection_Attestations
FROM LIB.HSH_Collection_Lexicon AS hcl WITH(NOLOCK)
LEFT JOIN LIB.HSH_Collection_Documents AS hcd WITH(NOLOCK)
ON hcd.Source_ID = hcl.Source_ID
AND hcd.Collection_ID = hcl.Collection_ID
LEFT JOIN LIB.REG_Collections AS col WITH(NOLOCK)
ON col.Collection_ID = hcl.Collection_ID
LEFT JOIN LIB.REG_Sources AS src WITH(NOLOCK)
ON src.Source_ID = hcl.Source_ID
LEFT JOIN LIB.REG_Dictionary AS dic WITH(NOLOCK)
ON dic.Word_ID = hcl.Word_ID
LEFT JOIN LIB.REG_Documents AS doc WITH(NOLOCK)
ON doc.Document_ID = hcd.Document_ID
GROUP BY col.Name
, REPLACE(src.File_Path,doc.Title,'')
, dic.Word