

CREATE PROCEDURE [LIB].[MP_Library_Content_Collection_Processing]
AS

/* Insert qualified values to Library tables 
	20180114:4est - Original criteria allows any non-numeric value to be a "word".
					I am substantially refining this to exclude all integers which
					effectively eliminates dates, and identifier codes. 

					I found and eliminated a condition where multiple symbol characters
					formed a "word" for example "...", "!?" used as punctuation, or ",,." -
					cases where a delimited list missing values is found - perhaps a bad 
					Excel import.
					
					I will seek edge cases where common abbreviations include numerics
					after re-analyzing my data with this change in place.
					-- AND ISNUMERIC(Column_Value) = 0 -- TRY_CONVERT() is better at detecting conversion errors, but ISNUMERIC() is fine for this purpose.
*/



/*** Dev Check: Truncate working tables 
	TRUNCATE TABLE TMP.TXT_Process_Hash
	TRUNCATE TABLE TMP.TXT_String_Map
	DROP TABLE #LibraryInsert
***/ 


/* Collect fundamental values for insertion */

SELECT DISTINCT vi.Target_Database, tmp.LNK_T4_ID, tmp.Column_Value, Value_Count
INTO #LibraryInsert
FROM (
	SELECT Column_Value, LNK_T4_ID, Value_Count
	FROM TMP.TRK_0354_Value_Hash AS tmp WITH(NOLOCK)
	UNION
	SELECT Chunk, LNK_T4_ID, Value_Count
	FROM TMP.TRK_0354_Long_String_Values AS lsv
	CROSS APPLY [LIB].[SplitTable] (' ',1,256, String, LNK_T4_ID) as crp
	) AS tmp
INNER JOIN CAT.VI_0300_Full_Object_Map AS vi
ON vi.LNK_T4_ID = tmp.LNK_T4_ID

CREATE NONCLUSTERED INDEX tdx_nc_LibraryInsert_K2_I1_I3_4 ON #LibraryInsert (LNK_T4_ID) INCLUDE(Target_Database, Column_Value, Value_Count)


/* Insert new Words to the dictionary */

INSERT INTO LIB.REG_Dictionary (Word)

SELECT Column_Value
FROM #LibraryInsert AS tmp
INNER JOIN (
	SELECT Char_Val
	FROM LIB.REG_Alphabet WITH(NOLOCK)
	WHERE Class_VCNS IN ('V','C')
	) AS cfs
ON CHARINDEX(cfs.Char_Val, tmp.Column_Value) > 0 -- Includes only word strings containing at least one letter
LEFT JOIN LIB.REG_Dictionary AS lib WITH(NOLOCK)
ON lib.Word = tmp.Column_Value
WHERE LEN(ISNULL(Column_Value,'')) > 1
AND (PATINDEX('%[0-9]%', Column_Value) = 0
AND PATINDEX('[0-9]%', Column_Value) = 0
AND PATINDEX('%[0-9]', Column_Value) = 0) -- Exclude all Integers in word strings
AND lib.Word_ID IS NULL
GROUP BY Column_Value


/* Run the Library Collection Currator procedure to load up collections */

EXEC LIB.CUR_DB_Collection_Currator


/* Associate current hash to related library collection */

INSERT INTO LIB.HSH_Collection_Documents (Collection_ID, Source_ID, Document_ID)

SELECT DISTINCT col.Collection_ID
, -1 -- Source_ID for Value Hashes
, doc.Document_ID
FROM #LibraryInsert AS tmp
JOIN LIB.REG_Collections AS col
ON col.name = tmp.Target_Database
CROSS APPLY LIB.REG_Documents AS doc
WHERE doc.Title = 'Values'


/* Insert other parsed segments into the Lexicon 
	Attribute Collection and Word ID for links to Enhance the Library Collection 
	process to identify individual columns as a subordinate collection of a source
	- allows for greater junction testing, profiling, and rules detection.
*/

INSERT INTO LIB.HSH_Collection_Lexicon (Collection_ID, Source_ID, Column_ID, Word_ID, Use_Count)

SELECT reg.Collection_ID, -1, tmp.LNK_T4_ID, dic.Word_ID, SUM(tmp.Value_Count)
FROM #LibraryInsert as tmp
JOIN LIB.REG_Dictionary as dic
ON dic.Word = tmp.Column_Value
JOIN LIB.REG_Collections as reg
ON reg.Name = tmp.Target_Database
GROUP BY reg.Collection_ID, tmp.LNK_T4_ID, dic.Word_ID