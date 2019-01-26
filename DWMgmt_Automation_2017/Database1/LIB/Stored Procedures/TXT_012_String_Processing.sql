

CREATE PROCEDURE [LIB].[TXT_012_String_Processing]
@SourceID INT = NULL
, @ExecuteStatus TINYINT = 2

AS


/* Debug Setup
	DROP TABLE #Source_Graphs
	DROP TABLE #WordBase
*/


/* Create table index on TXT_String_Map if not exists */

IF NOT EXISTS (SELECT name FROM sys.indexes WHERE name = N'tdx_nc_TXT_String_Map_K2_I3_I4')
CREATE NONCLUSTERED INDEX [tdx_nc_TXT_String_Map_K2_I3_I4]
ON [TMP].[TXT_String_Map] ([Source_ID])
INCLUDE ([ASCII_Char],[Char_Pos])




/* Load Alphabet */

-- declare @SourceID int = null
INSERT INTO LIB.HSH_Collection_Alphabet (Collection_ID, Source_ID, ASCII_Char, Use_Count)

SELECT tph.Collection_ID, ISNULL(@SourceID, tph.Source_ID), tmp.ASCII_Char, COUNT(*)
FROM TMP.TXT_Process_Hash AS tph WITH(NOLOCK)
JOIN TMP.TXT_String_Map AS tmp WITH(NOLOCK)
ON tph.Source_ID = tmp.Source_ID
GROUP BY tph.Collection_ID, ISNULL(@SourceID, tph.Source_ID), tmp.ASCII_Char


/* Load Graphemes */

SELECT maps.Source_ID, lrg.Graph_ID, COUNT(*) as Use_Count
INTO #Source_Graphs
FROM (
	SELECT map1.Source_ID
	, map1.ASCII_Char as ASCII_Char1
	, map2.ASCII_Char as ASCII_Char2
	FROM TMP.TXT_String_Map AS map1 WITH(NOLOCK)
	JOIN TMP.TXT_String_Map AS map2 WITH(NOLOCK)
	ON map1.Source_ID = map2.Source_ID
	AND map1.Char_Pos = map2.Char_Pos + 1
	) AS maps
JOIN LIB.REG_Graphemes AS lrg WITH(NOLOCK)
ON lrg.ASCII_Char1 = maps.ASCII_Char1
AND lrg.ASCII_Char2 = maps.ASCII_Char2
GROUP BY maps.Source_ID, lrg.Graph_ID
ORDER BY Source_ID, lrg.Graph_ID


CREATE CLUSTERED INDEX tdx_pk_SourceGraphs ON #Source_Graphs
([Source_ID] ASC,[Graph_ID] ASC) 
ON [PRIMARY]


-- declare @SourceID int = NULL

INSERT INTO LIB.HSH_Collection_Graphemes (Collection_ID, Source_ID, Graph_ID, Use_Count)

SELECT sub.Collection_ID, ISNULL(@SourceID, sub.Source_ID), dom.Graph_ID, SUM(dom.Use_Count)
FROM #Source_Graphs AS dom
JOIN (
	SELECT Source_ID, Collection_ID
	FROM TMP.TXT_Process_Hash WITH(NOLOCK)
	) AS sub
ON sub.Source_ID = dom.Source_ID
GROUP BY sub.Collection_ID, ISNULL(@SourceID, sub.Source_ID), dom.Graph_ID


/* Auto-detect fundamental rule: Universal Delimiter
	-- Helps detect structured file content.
	-- Replace this with streamlined proc-call when enough fundamental rules are formally structured
*/

INSERT INTO LIB.HSH_Collection_Rules (Collection_ID, Rule_ID, Rule_Rank, Rule_Value_Type, Rule_Value, Use_Count)

SELECT DISTINCT dom.Collection_ID
, crp.Rule_ID
, 1
, 'ASCII_Char' AS Rule_Value_Type
, dom.ASCII_Char AS Rule_Value
, dom.Use_Count
FROM (
	SELECT ROW_NUMBER() OVER(PARTITION BY hsh.Collection_ID ORDER BY SUM(hsh.Use_Count) DESC) AS RuleRank
	, hsh.Collection_ID, reg.ASCII_Char, reg.Char_Val, SUM(hsh.Use_Count) as Use_Count
	FROM LIB.HSH_Collection_Alphabet AS hsh WITH(NOLOCK)
	JOIN LIB.REG_Alphabet AS reg WITH(NOLOCK)
	ON reg.ASCII_Char = hsh.ASCII_Char
	AND Class_VCNS = 'S'
	GROUP BY hsh.Collection_ID, reg.ASCII_Char, reg.Char_Val
	) AS dom
CROSS APPLY (
	SELECT tbl.Rule_ID
	FROM LIB.REG_Rules AS tbl WITH(NOLOCK)
	WHERE tbl.Rule_Name IN ('Universal_Delimiter')
	) AS crp
WHERE RuleRank = 1
ORDER BY Collection_ID


/* Auto-detect fundamental rule: Row Terminator
	-- Helps detect structured file content.
	-- Replace this with streamlined proc-call when enough fundamental rules are formally structured
*/

INSERT INTO LIB.HSH_Collection_Rules (Collection_ID, Rule_ID, Rule_Rank, Rule_Value_Type, Rule_Value, Use_Count)

SELECT DISTINCT dom.Collection_ID
, crp.Rule_ID
, 2
, 'ASCII_Char' AS Rule_Value_Type
, dom.ASCII_Char AS Rule_Value
, dom.Use_Count
FROM (
	SELECT ROW_NUMBER() OVER(PARTITION BY hsh.Collection_ID ORDER BY SUM(hsh.Use_Count) DESC) AS RuleRank
	, hsh.Collection_ID, reg.ASCII_Char, reg.Char_Val, SUM(hsh.Use_Count) as Use_Count
	FROM LIB.HSH_Collection_Alphabet AS hsh WITH(NOLOCK)
	JOIN LIB.REG_Alphabet AS reg WITH(NOLOCK)
	ON reg.ASCII_Char = hsh.ASCII_Char
	AND Class_VCNS = 'S' AND Printable = 0
	GROUP BY hsh.Collection_ID, reg.ASCII_Char, reg.Char_Val
	) AS dom
CROSS APPLY (
	SELECT tbl.Rule_ID
	FROM LIB.REG_Rules AS tbl WITH(NOLOCK)
	WHERE tbl.Rule_Name IN ('Line_End_Type')
	) AS crp
WHERE RuleRank = 1
ORDER BY Collection_ID


/* Determine if structured data exists.
-- Avoid "Word" processing below, establish a tabular structure and import data
*/




/* Load fundamental rule: Punctuation_Replacement
	-- Removes non-Alpha characters used as punctuation to faciliate accurate word detection.
	-- Replace this with streamlined proc-call when enough fundamental rules are formally structured
	-- 20180429:4est !! This should probably added to the Library Defaults load process and referenced generically.
*/

INSERT INTO LIB.HSH_Collection_Rules (Collection_ID, Rule_ID, Rule_Rank, Rule_Value_Type, Rule_Value, Use_Count)

SELECT DISTINCT hsh.Collection_ID
, tbl.Rule_ID
, 3
, 'ASCII_Char' AS Rule_Value_Type
, '9,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,58,59,60,61,62,63,64,91,92,93,94,95,96
  ,123,124,125,126,127,128,130,131,132,133,134,135,136,137,139,140,145,146,147,148,149,150
  ,151,152,153,155,156,162,165,166,167,168,169,170,171,172,174,173,175,176,177,178,179,180
  ,181,182,183,184,185,186,187,188,189,190,191,215,247' AS Rule_Value
, 0
FROM LIB.HSH_Collection_Rules AS hsh WITH(NOLOCK)
LEFT JOIN LIB.REG_Rules AS tbl WITH(NOLOCK)
ON tbl.Rule_ID = hsh.Rule_ID
WHERE tbl.Rule_ID IS NULL
ORDER BY Collection_ID


/* Prepare Word processing 
	Identify the locations from the	String_Map where a normal delimiter character is used 
	to terminate a line (carriage return and/or line feed), or text string (space).

	-- DROP TABLE #WordBase

	--Retain the following code incase terminal character per source becomes necessary.
	----IF EXISTS (SELECT name FROM tempdb.sys.tables WHERE name like '#CodeBounds%')
	----DROP TABLE #CodeBounds

	----SELECT Source_ID, MIN(Char_Pos) as Map_Anchor, MAX(Char_Pos) as Map_Bound
	----INTO #CodeBounds
	----FROM TMP.TXT_String_Map AS map with(nolock)
	----GROUP BY Source_ID

	Setting the tempdb log size will be necessary - set maximum size = total file size to process.
	your process batch you will need to subdivide files by type, source, etc.
*/

DECLARE @TargetSize NVARCHAR(16)

SELECT @TargetSize = sum(String_Length) * 2 / 1048576 FROM TMP.TXT_Process_Hash

select @TargetSize

EXEC('ALTER DATABASE tempdb MODIFY FILE
   (NAME = ''templog'', SIZE = '+@TargetSize+')')

/* Make a Flat String of all Character Exclusions 
	-- This identifies the valid character sets for "Words"
	--- As a default it includes only printable alpha characters of all language sets
*/

; WITH Rule_Values (Rule_Value, Collection_ID, Rule_ID)
AS (
	SELECT TOP 1 CAST(Rule_Value AS VARCHAR(max))
	, Collection_ID
	, CAST(Rule_ID AS VARCHAR(max))
	FROM LIB.HSH_Collection_Rules
	UNION ALL
	SELECT CAST(src.Rule_Value AS VARCHAR(max))+','+cte.Rule_Value
	, src.Collection_ID
	, CAST(src.Rule_ID AS VARCHAR(max))+','+cte.Rule_ID
	FROM LIB.HSH_Collection_Rules AS src
	INNER JOIN Rule_Values AS cte
	ON cte.Collection_ID = src.Collection_ID
	AND CHARINDEX(CAST(src.Rule_ID AS VARCHAR), cte.Rule_ID) = 0
	)

SELECT DISTINCT tsm.Source_ID
, ISNULL(hcr.Rule_Value,'')+',44,32,13,10' as Delimiter_Char
, CAST(tsm.ASCII_Char AS VARCHAR(3)) as ASCII_Char
, tsm.Char_Pos
, alp.Char_Val
, CAST(NULL AS NVARCHAR(4000)) as Word
INTO #WordBase
FROM TMP.TXT_String_Map AS tsm WITH(NOLOCK)
JOIN LIB.REG_Alphabet AS alp WITH(NOLOCK)
ON alp.ASCII_Char = tsm.ASCII_Char
CROSS APPLY (
	SELECT Rule_Value
	, Collection_ID
	, DENSE_RANK() OVER (PARTITION BY Collection_ID ORDER BY Rule_ID DESC) as Rule_Rank
	FROM Rule_Values
	) AS hcr
WHERE hcr.Rule_Rank = 1

CREATE CLUSTERED INDEX tdx_ci_WordBase_K1_K4 ON #WordBase (Source_ID, Char_Pos)


; SET NOCOUNT ON
	
DECLARE @Word NVARCHAR(4000) = ''
, @SrcID BIGINT

SELECT @SrcID = (SELECT TOP 1 Source_ID FROM #WordBase)

UPDATE t1 SET 
	@Word = t1.Word = CASE WHEN CHARINDEX(t1.ASCII_Char, t1.Delimiter_Char) = 0 THEN @Word+t1.Char_Val
	ELSE @Word END
	, @Word = CASE WHEN CHARINDEX(t1.ASCII_Char, t1.Delimiter_Char) > 0 THEN '' ELSE @Word END
	, @SrcID = t1.Source_ID
FROM #WordBase AS t1
OPTION(MAXDOP 1)

SET NOCOUNT OFF



/* Insert new words into the source Dictionary 
	These are parsed segments of length between 2 and 256 
	which must not be blank or numeric
*/

INSERT INTO LIB.REG_Dictionary (Word)

SELECT DISTINCT base.Word
FROM #WordBase AS base WITH(NOLOCK)
INNER JOIN (
	SELECT Char_Val
	FROM LIB.REG_Alphabet WITH(NOLOCK)
	WHERE Class_VCNS IN ('V','C')
	) AS cfs
ON CHARINDEX(cfs.Char_Val, Word) > 0 -- Requires distinct because case-insenstive filter produces duplicates, and only strings which contain a letter should be included.
--LEFT JOIN (
--	SELECT Char_Val
--	FROM LIB.REG_Alphabet WITH(NOLOCK)	-- 20180429::4est  This reference may no longer be needed. These characters should be handled by punctuation rule by default.
--	WHERE Class_VCNS IN ('S','N')
--	AND ASCII_Char NOT IN (9,10,13,32)
--	) AS sne
--ON CHARINDEX(sne.Char_Val, Word) > 0 -- Exclude any value where a numeric character or symbol is present.
LEFT JOIN LIB.REG_Dictionary AS lib WITH(NOLOCK)
ON lib.Word = base.Word
WHERE 1=1
AND LEN(ISNULL(base.Word,'')) > 1 -- Must be at least 2 characters or longer - single characters such as 'A', 'I', and slang abbreviations such as 'R' and 'U' are preloaded.
AND CHARINDEX(ASCII_Char, Delimiter_Char) > 0
--AND sne.Char_Val IS NULL
AND lib.Word_ID IS NULL


/* Insert other parsed segments into the Lexicon 
	Attribute Collection and Word ID for links to Enhance the Library Collection 
	process to identify individual columns as a subordinate collection of a source
	- allows for greater junction testing, profiling, and rules detection.
*/

-- declare @SourceID int = NULL

INSERT INTO LIB.HSH_Collection_Lexicon (Collection_ID, Source_ID, Column_ID, Word_ID, Use_Count)

SELECT stk.Collection_ID
, ISNULL(@SourceID, stk.Source_ID)
, 0
, lrd.Word_ID
, COUNT(*)
FROM #WordBase AS tmp
JOIN LIB.REG_Dictionary AS lrd
ON lrd.Word = tmp.Word
JOIN TMP.TXT_Process_Hash AS stk
ON stk.Source_ID = tmp.Source_ID
WHERE 1=1
AND ISNULL(tmp.Word,'') != ''
AND CHARINDEX(ASCII_Char, Delimiter_Char) > 0
GROUP BY stk.Collection_ID, ISNULL(@SourceID, stk.Source_ID), lrd.Word_ID




IF @ExecuteStatus = 2
BEGIN

	DELETE T1
	FROM LIB.External_String_Intake_Stack AS T1
	JOIN TMP.TXT_Process_Hash AS T2
	ON T2.Version_Stamp = T1.Version_Stamp

	TRUNCATE TABLE TMP.TXT_Parsed_Segments

	TRUNCATE TABLE TMP.TXT_Process_Hash

	TRUNCATE TABLE TMP.TXT_String_Map

END


/* Clean up TXT_String_Map Index after use */
DROP INDEX [tdx_nc_TXT_String_Map_K2_I3_I4] ON [TMP].[TXT_String_Map]