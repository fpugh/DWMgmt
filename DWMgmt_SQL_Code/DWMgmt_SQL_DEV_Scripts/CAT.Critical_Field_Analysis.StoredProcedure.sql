
--CREATE PROCEDURE CAT.CRITICAL_FIELD_ANALYSIS
--AS

-- drop table #InnerJoinCodeSet
-- drop table #CodeBounds

CREATE TABLE #InnerJoinCodeSet (LNK_FK_T3_ID int, LNK_FK_0300_ID int, LNK_FK_0600_ID int, LNK_Rank int, REG_Code_Content varchar(8000), Critical_Priority tinyint)

SELECT LNK_FK_T3_ID, MIN(LNK_RANK) as Line_Anchor, MAX(LNK_RANK) as Line_Bound
INTO #CodeBounds
FROM CAT.LNK_0300_0600_Object_Code_Sections
WHERE GETDATE() BETWEEN LNK_Post_Date AND LNK_Term_Date
GROUP BY LNK_FK_T3_ID


; WITH Wheres (LNK_FK_T3_ID, Line_Anchor, Line_Bound)
AS (
	SELECT t1.LNK_FK_T3_ID, t1.LNK_Rank as Line_Anchor
	, MIN(ISNULL(t2.LNK_rank, tmp.Line_Bound)) as Line_Bound
	FROM (
		SELECT DISTINCT LNK_FK_T3_ID, LNK_Rank
		FROM CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
		JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
		ON ocs.LNK_FK_0600_ID = ocl.REG_0600_ID
		WHERE CONTAINS(REG_Code_Content, '"WHERE"')
		AND GETDATE() BETWEEN LNK_Post_Date AND LNK_Term_Date
		) AS t1
	JOIN #CodeBounds AS tmp
	ON tmp.LNK_FK_T3_ID = t1.LNK_FK_T3_ID
	OUTER APPLY (
		SELECT DISTINCT LNK_FK_T3_ID, LNK_Rank
		FROM CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
		JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
		ON ocs.LNK_FK_0600_ID = ocl.REG_0600_ID 
		WHERE CONTAINS(REG_Code_Content, '"join" OR "group" OR "having" OR "order" OR "select" OR "create" OR "drop" OR "delete" OR "update" OR "set" OR "from" OR "end" OR "while" OR "begin" OR "else" OR "truncate" OR "into" OR "union" OR "revert"') -- Eventually this will be replaced by a rule-set table reference for SQL control words.
		AND GETDATE() BETWEEN LNK_Post_Date AND LNK_Term_Date
		) as t2
	WHERE t2.LNK_FK_T3_ID = t1.LNK_FK_T3_ID
	AND t2.LNK_Rank > t1.LNK_Rank
	GROUP BY t1.LNK_FK_T3_ID, t1.LNK_Rank
	)

INSERT INTO #InnerJoinCodeSet (LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0600_ID, LNK_Rank, REG_Code_Content, Critical_Priority)

SELECT ocs.LNK_FK_T3_ID, ocs.LNK_FK_0300_ID, ocs.LNK_FK_0600_ID, ocs.LNK_Rank, ocl.REG_Code_Content
, 1 as Critical_Priority
FROM CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
ON ocs.LNK_FK_0600_ID = ocl.REG_0600_ID
JOIN Wheres AS cte
ON cte.LNK_FK_T3_ID = ocs.LNK_FK_T3_ID
AND cte.Line_Anchor <= ocs.LNK_Rank
AND cte.Line_Bound > ocs.LNK_Rank
ORDER BY ocs.LNK_FK_T3_ID, ocs.LNK_RANK


; WITH InnerJoins (LNK_FK_T3_ID, Line_Anchor, Line_Bound)
AS (
	SELECT t1.LNK_FK_T3_ID, t1.LNK_Rank as Line_Anchor
	, MIN(ISNULL(t2.LNK_rank, tmp.Line_Bound)) as Line_Bound
	FROM (
		SELECT DISTINCT LNK_FK_T3_ID, LNK_Rank
		FROM CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
		JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
		ON ocs.LNK_FK_0600_ID = ocl.REG_0600_ID
		WHERE CONTAINS(REG_Code_Content, '"inner join"')
		AND GETDATE() BETWEEN LNK_Post_Date AND LNK_Term_Date
		) AS t1
	JOIN #CodeBounds AS tmp
	ON tmp.LNK_FK_T3_ID = t1.LNK_FK_T3_ID
	OUTER APPLY (
		SELECT DISTINCT LNK_FK_T3_ID, LNK_Rank
		FROM CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
		JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
		ON ocs.LNK_FK_0600_ID = ocl.REG_0600_ID 
		WHERE CONTAINS(REG_Code_Content, '"join" OR "where" OR "group" OR "having" OR "order" OR "select" OR "create" OR "drop" OR "delete" OR "update" OR "set" OR "from" OR "end" OR "while" OR "begin" OR "else" OR "truncate" OR "into" OR "union" OR "revert"') -- Eventually this will be replaced by a rule-set table reference for SQL control words.
		AND GETDATE() BETWEEN LNK_Post_Date AND LNK_Term_Date
		) as t2
	WHERE t2.LNK_FK_T3_ID = t1.LNK_FK_T3_ID
	AND t2.LNK_Rank > t1.LNK_Rank
	GROUP BY t1.LNK_FK_T3_ID, t1.LNK_Rank
	)

INSERT INTO #InnerJoinCodeSet (LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0600_ID, LNK_Rank, REG_Code_Content, Critical_Priority)

SELECT ocs.LNK_FK_T3_ID, ocs.LNK_FK_0300_ID, ocs.LNK_FK_0600_ID, ocs.LNK_Rank, ocl.REG_Code_Content
, 2 as Critical_Priority
FROM CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
ON ocs.LNK_FK_0600_ID = ocl.REG_0600_ID
JOIN InnerJoins AS cte
ON cte.LNK_FK_T3_ID = ocs.LNK_FK_T3_ID
AND cte.Line_Anchor <= ocs.LNK_Rank
AND cte.Line_Bound > ocs.LNK_Rank
ORDER BY ocs.LNK_FK_T3_ID, ocs.LNK_RANK


; WITH Aggregates (LNK_FK_T3_ID, Line_Anchor, Line_Bound)
AS (
	SELECT t1.LNK_FK_T3_ID, t1.LNK_Rank as Line_Anchor
	, MIN(ISNULL(t2.LNK_rank, tmp.Line_Bound)) as Line_Bound
	FROM (
		SELECT DISTINCT LNK_FK_T3_ID, LNK_Rank
		FROM CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
		JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
		ON ocs.LNK_FK_0600_ID = ocl.REG_0600_ID
		WHERE CONTAINS(REG_Code_Content, '"group" OR "having"')
		AND GETDATE() BETWEEN LNK_Post_Date AND LNK_Term_Date
		) AS t1
	JOIN #CodeBounds AS tmp
	ON tmp.LNK_FK_T3_ID = t1.LNK_FK_T3_ID
	OUTER APPLY (
		SELECT DISTINCT LNK_FK_T3_ID, LNK_Rank
		FROM CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
		JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
		ON ocs.LNK_FK_0600_ID = ocl.REG_0600_ID 
		WHERE CONTAINS(REG_Code_Content, '"join" OR "where" OR "group" OR "having" OR "order" OR "select" OR "create" OR "drop" OR "delete" OR "update" OR "set" OR "from" OR "end" OR "while" OR "begin" OR "else" OR "truncate" OR "into" OR "union" OR "revert"') -- Eventually this will be replaced by a rule-set table reference for SQL control words.
		AND GETDATE() BETWEEN LNK_Post_Date AND LNK_Term_Date
		) as t2
	WHERE t2.LNK_FK_T3_ID = t1.LNK_FK_T3_ID
	AND t2.LNK_Rank > t1.LNK_Rank
	GROUP BY t1.LNK_FK_T3_ID, t1.LNK_Rank
	)

INSERT INTO #InnerJoinCodeSet (LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0600_ID, LNK_Rank, REG_Code_Content, Critical_Priority)

SELECT ocs.LNK_FK_T3_ID, ocs.LNK_FK_0300_ID, ocs.LNK_FK_0600_ID, ocs.LNK_Rank, ocl.REG_Code_Content
, 3 as Critical_Priority
FROM CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
ON ocs.LNK_FK_0600_ID = ocl.REG_0600_ID
JOIN Aggregates AS cte
ON cte.LNK_FK_T3_ID = ocs.LNK_FK_T3_ID
AND cte.Line_Anchor <= ocs.LNK_Rank
AND cte.Line_Bound > ocs.LNK_Rank
ORDER BY ocs.LNK_FK_T3_ID, ocs.LNK_RANK


; WITH SortsAndReferences (LNK_FK_T3_ID, Line_Anchor, Line_Bound)
AS (
	SELECT t1.LNK_FK_T3_ID, t1.LNK_Rank as Line_Anchor
	, MIN(ISNULL(t2.LNK_rank, tmp.Line_Bound)) as Line_Bound
	FROM (
		SELECT DISTINCT LNK_FK_T3_ID, LNK_Rank
		FROM CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
		JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
		ON ocs.LNK_FK_0600_ID = ocl.REG_0600_ID
		WHERE CONTAINS(REG_Code_Content, '"order" OR "left*join"')
		AND GETDATE() BETWEEN LNK_Post_Date AND LNK_Term_Date
		) AS t1
	JOIN #CodeBounds AS tmp
	ON tmp.LNK_FK_T3_ID = t1.LNK_FK_T3_ID
	OUTER APPLY (
		SELECT DISTINCT LNK_FK_T3_ID, LNK_Rank
		FROM CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
		JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
		ON ocs.LNK_FK_0600_ID = ocl.REG_0600_ID 
		WHERE CONTAINS(REG_Code_Content, '"join" OR "where" OR "group" OR "having" OR "order" OR "select" OR "create" OR "drop" OR "delete" OR "update" OR "set" OR "from" OR "end" OR "while" OR "begin" OR "else" OR "truncate" OR "into" OR "union" OR "revert"') -- Eventually this will be replaced by a rule-set table reference for SQL control words.
		AND GETDATE() BETWEEN LNK_Post_Date AND LNK_Term_Date
		) as t2
	WHERE t2.LNK_FK_T3_ID = t1.LNK_FK_T3_ID
	AND t2.LNK_Rank > t1.LNK_Rank
	GROUP BY t1.LNK_FK_T3_ID, t1.LNK_Rank
	)

INSERT INTO #InnerJoinCodeSet (LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0600_ID, LNK_Rank, REG_Code_Content, Critical_Priority)

SELECT ocs.LNK_FK_T3_ID, ocs.LNK_FK_0300_ID, ocs.LNK_FK_0600_ID, ocs.LNK_Rank, ocl.REG_Code_Content
, 4 as Critical_Priority
FROM CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
ON ocs.LNK_FK_0600_ID = ocl.REG_0600_ID
JOIN SortsAndReferences AS cte
ON cte.LNK_FK_T3_ID = ocs.LNK_FK_T3_ID
AND cte.Line_Anchor <= ocs.LNK_Rank
AND cte.Line_Bound > ocs.LNK_Rank
ORDER BY ocs.LNK_FK_T3_ID, ocs.LNK_RANK


; WITH BaseSelect (LNK_FK_T3_ID, Line_Anchor, Line_Bound)
AS (
	SELECT t1.LNK_FK_T3_ID, t1.LNK_Rank as Line_Anchor
	, MIN(ISNULL(t2.LNK_rank, tmp.Line_Bound)) as Line_Bound
	FROM (
		SELECT DISTINCT LNK_FK_T3_ID, LNK_Rank
		FROM CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
		JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
		ON ocs.LNK_FK_0600_ID = ocl.REG_0600_ID
		WHERE CONTAINS(REG_Code_Content, '"select"')
		AND GETDATE() BETWEEN LNK_Post_Date AND LNK_Term_Date
		) AS t1
	JOIN #CodeBounds AS tmp
	ON tmp.LNK_FK_T3_ID = t1.LNK_FK_T3_ID
	OUTER APPLY (
		SELECT DISTINCT LNK_FK_T3_ID, LNK_Rank
		FROM CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
		JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
		ON ocs.LNK_FK_0600_ID = ocl.REG_0600_ID 
		WHERE CONTAINS(REG_Code_Content, '"join" OR "where" OR "group" OR "having" OR "order" OR "select" OR "create" OR "drop" OR "delete" OR "update" OR "set" OR "from" OR "end" OR "while" OR "begin" OR "else" OR "truncate" OR "into" OR "union" OR "revert"') -- Eventually this will be replaced by a rule-set table reference for SQL control words.
		AND GETDATE() BETWEEN LNK_Post_Date AND LNK_Term_Date
		) as t2
	WHERE t2.LNK_FK_T3_ID = t1.LNK_FK_T3_ID
	AND t2.LNK_Rank > t1.LNK_Rank
	GROUP BY t1.LNK_FK_T3_ID, t1.LNK_Rank
	)

INSERT INTO #InnerJoinCodeSet (LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0600_ID, LNK_Rank, REG_Code_Content, Critical_Priority)

SELECT ocs.LNK_FK_T3_ID, ocs.LNK_FK_0300_ID, ocs.LNK_FK_0600_ID, ocs.LNK_Rank, ocl.REG_Code_Content
, 5 as Critical_Priority
FROM CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
ON ocs.LNK_FK_0600_ID = ocl.REG_0600_ID
JOIN BaseSelect AS cte
ON cte.LNK_FK_T3_ID = ocs.LNK_FK_T3_ID
AND cte.Line_Anchor <= ocs.LNK_Rank
AND cte.Line_Bound > ocs.LNK_Rank
ORDER BY ocs.LNK_FK_T3_ID, ocs.LNK_RANK



SELECT DISTINCT ccr.VID
, tmp.LNK_FK_T3_ID
, tmp.Critical_Priority
, tmp.LNK_Rank
, ccr.Fully_Qualified_Name
, odp.Column_Definition
, tmp.REG_Code_Content
, TRK_Total_Values
, TRK_Column_Nulls
, TRK_Density
--, ccr.*
FROM CAT.VI_0363_Code_Column_Reference AS ccr
JOIN #InnerJoinCodeSet AS tmp
ON tmp.LNK_FK_T3_ID = ccr.LNK_FK_T3P_ID
AND tmp.LNK_FK_0600_ID = ccr.REG_0600_ID

LEFT JOIN CAT.VI_0354_Object_Data_Profile AS odp
ON odp.LNK_T4_ID = ccr.LNK_FK_T4R_ID

ORDER BY tmp.Critical_Priority
, tmp.LNK_FK_T3_ID
, tmp.LNK_Rank

