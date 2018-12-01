USE DWMGMT
GO


SELECT *
FROM TMP.TRK_0354_Value_Hash_Objects WITH(NOLOCK)
ORDER BY 2 DESC
GO


SELECT distinct LNK_T4_ID
FROM TMP.TRK_0354_Value_Hash WITH(NOLOCK)




--/* Generate Histogram of values by object */
--SELECT VHO.Database_Name, VHO.Schema_Name, VHO.Object_Name, VHO.Column_Name
--, COUNT(DISTINCT CVH.Column_Value) as Unique_Values, SUM(CVH.Value_Count) as Total_Value_Count
--FROM TMP.TRK_0354_Value_Hash_Objects AS VHO WITH(NOLOCK)
--JOIN TMP.TRK_0354_Value_Hash AS CVH WITH(NOLOCK)
--ON CVH.LNK_T4_ID = VHO.LNK_T4_ID
--GROUP BY VHO.Database_Name, VHO.Schema_Name, VHO.Object_Name, VHO.Column_Name
--ORDER BY Total_Value_Count




/* Typical Column Values - Create a data-dictionary. */


-- drop table #TopValues

CREATE TABLE #TopValues (Database_Name NVARCHAR(65), Schema_Bound_Name NVARCHAR(256), Column_Name NVARCHAR(65), Column_Type NVARCHAR(65), Column_Value NVARCHAR(MAX), ROWID INT, LNK_T4_ID INT, Typical_Values NVARCHAR(max))

INSERT INTO #TopValues (Database_Name, Schema_Bound_Name, Column_Name, Column_Type, Column_Value, ROWID, LNK_T4_ID, Typical_Values)

SELECT VHO.Database_Name, VHO.Schema_Bound_Name, VHO.Column_Name, VHO.Column_Type
, SUB.Column_Value, ROWID, VHO.LNK_T4_ID
, Typical_Values = 'Typical Values: '
FROM TMP.TRK_0354_Value_Hash_Objects AS VHO WITH(NOLOCK)
JOIN (
	SELECT vh1.Column_Value
		, vh1.LNK_T4_ID
		, Value_Count
		, rowid = DENSE_RANK() OVER (PARTITION BY LNK_T4_ID ORDER BY Value_Count, Column_Value DESC)
	FROM TMP.TRK_0354_Value_Hash AS VH1 WITH(NOLOCK)
	) AS SUB
ON SUB.LNK_T4_ID = VHO.LNK_T4_ID
AND SUB.rowid <= 5
WHERE VHO.Column_Type like '%char%'
OR VHO.Column_Type in ('sysname','uniquidentifier')


CREATE CLUSTERED INDEX tdx_ci_TopValues ON #TopValues (LNK_T4_ID, Rowid)


SET NOCOUNT OFF

	DECLARE @LNK_T4_ID INT = 0
	, @Rowid INT = 0
	, @TypicalValues NVARCHAR(max)

	UPDATE tmp SET @TypicalValues = Typical_Values = 
					CASE WHEN @LNK_T4_ID = LNK_T4_ID AND @RowID <= RowID 
						THEN 
							CASE WHEN PATINDEX('%[,	]%', Column_Value) > 0 OR LEN(Column_Value) > 65 THEN 'Typical Values:  FREE TEXT' ELSE @TypicalValues +', '+ISNULL(Column_Value,'') END
						ELSE 
							CASE WHEN PATINDEX('%[,	]%', Column_Value) > 0 OR LEN(Column_Value) > 65 THEN 'Typical Values:  FREE TEXT' ELSE Typical_Values+' '+ISNULL(Column_Value,'') END
						END
				, @LNK_T4_ID = LNK_T4_ID
				, @Rowid = Rowid
	FROM #TopValues AS tmp
	OPTION(MAXDOP 1)

SET NOCOUNT ON

-- UPDATE #TopValues SET Typical_Values = 'Typical Values:  '

SELECT TMP.Database_Name, TMP.Schema_Bound_Name, TMP.Column_Name, TMP.Column_Type, TMP.Typical_Values
FROM #TopValues AS TMP
JOIN (
	SELECT LNK_T4_ID, MAX(ROWID) as RowID
	FROM #TopValues
	GROUP BY LNK_T4_ID
	) AS SUB
ON SUB.LNK_T4_ID = TMP.LNK_T4_ID
AND SUB.ROWID = TMP.ROWID

UNION

SELECT DISTINCT S1.Database_Name, S1.Schema_Bound_Name, S1.Column_Name, S1.Column_Type
, 'Value Ranges - Minimum:  '+ISNULL(S1.Column_Value, '-')+'   Maximum:  '+ISNULL(S2.Column_Value,'-') AS Typical_Values
FROM (
	SELECT VHO.Database_Name, VHO.Schema_Bound_Name, VHO.Column_Name, VHO.Column_Type
	, SUB.Column_Value, ROWID, VHO.LNK_T4_ID
	FROM TMP.TRK_0354_Value_Hash_Objects AS VHO WITH(NOLOCK)
	JOIN (
		SELECT vh1.Column_Value
			, vh1.LNK_T4_ID
			, Value_Count
			, rowid = DENSE_RANK() OVER (PARTITION BY LNK_T4_ID ORDER BY Column_Value, Value_Count DESC)
		FROM TMP.TRK_0354_Value_Hash AS VH1 WITH(NOLOCK)
		) AS SUB
	ON SUB.LNK_T4_ID = VHO.LNK_T4_ID
	AND rowid = 1
	WHERE VHO.Column_Type NOT LIKE '%char%'
	AND VHO.Column_Type NOT IN ('sysname')
	) AS S1
JOIN (	
	SELECT SUB.Column_Value, VHO.LNK_T4_ID
	FROM TMP.TRK_0354_Value_Hash_Objects AS VHO WITH(NOLOCK)
	JOIN (
		SELECT vh1.Column_Value
			, vh1.LNK_T4_ID
			, Value_Count
			, rowid = DENSE_RANK() OVER (PARTITION BY LNK_T4_ID ORDER BY Column_Value DESC, Value_Count DESC)
		FROM TMP.TRK_0354_Value_Hash AS VH1 WITH(NOLOCK)
		) AS SUB
	ON SUB.LNK_T4_ID = VHO.LNK_T4_ID
	AND rowid = 1
	WHERE VHO.Column_Type NOT LIKE '%char%'
	AND VHO.Column_Type NOT IN ('sysname')
	) AS S2
ON S2.LNK_T4_ID = S1.LNK_T4_ID





/* Basic Junctions 
	Scenario 1: Simple Hash Match
	Raw hash matching produces over-size resultsets (16777216+ Rows)
	Reduce this by applying limiting logic.
*/

; WITH MaxValues (LNK_T4_ID, Total_Records)
AS (
	SELECT LNK_T4_ID, SUM(CVH.Value_Count)
	FROM TMP.TRK_0354_Value_Hash AS CVH WITH(NOLOCK)
	GROUP BY LNK_T4_ID
)

SELECT VH1.Column_Value
, VH1.LNK_T4_ID as LNK_T4_ID_1
--, VH1.Total_Records as Total_Records_1, VH1.Value_Count as Value_Count_1
, 100 - (VH1.Value_Count / (VH1.Total_Records * 1.000000)) as Cardinality1
, VH2.LNK_T4_ID as LNK_T4_ID_2
--, VH2.Total_Records as Total_Records_2, VH2.Value_Count as Value_Count_2
, 100 - (VH2.Value_Count / (VH2.Total_Records * 1.000000)) as Cardinality2
--INTO #JunctionTemp		-- Crapped out of memory at 16,777,216/16:27 with Value Counts 1 & 2, Total Records 1& 2 and JProb
FROM (
	SELECT CTE.LNK_T4_ID, CVH.Column_Value, CVH.Value_Count, CTE.Total_Records
	FROM TMP.TRK_0354_Value_Hash_Objects AS VHO WITH(NOLOCK)
	JOIN MaxValues AS CTE
	ON CTE.LNK_T4_ID = VHO.LNK_T4_ID
	CROSS APPLY TMP.TRK_0354_Value_Hash AS CVH WITH(NOLOCK)
	WHERE CVH.LNK_T4_ID = VHO.LNK_T4_ID
	) AS VH1
CROSS APPLY (
	SELECT CTE.LNK_T4_ID, CVH.Column_Value, CVH.Value_Count, CTE.Total_Records
	FROM TMP.TRK_0354_Value_Hash_Objects AS VHO WITH(NOLOCK)
	JOIN MaxValues AS CTE
	ON CTE.LNK_T4_ID = VHO.LNK_T4_ID
	CROSS APPLY TMP.TRK_0354_Value_Hash AS CVH WITH(NOLOCK)
	WHERE CVH.LNK_T4_ID = VHO.LNK_T4_ID
	) AS VH2
WHERE VH1.Column_Value = VH2.Column_Value
AND VH1.LNK_T4_ID <> VH2.LNK_T4_ID
AND VH1.Value_Count >= VH2.Value_Count








SELECT *
FROM TMP.TRK_0354_Value_Hash_Objects WITH(NOLOCK)



SELECT Column_Value
, COUNT(DISTINCT vh.LNK_T4_ID) as Links
, SUM(Value_Count) as Total_Records
FROM TMP.TRK_0354_Value_Hash AS vh
JOIN TMP.TRK_0354_Value_Hash_Objects AS vho
ON vho.LNK_T4_ID = vh.LNK_T4_ID
GROUP BY Column_Value
HAVING COUNT(DISTINCT vh.LNK_T4_ID) > 1
ORDER BY 3 DESC, 2 DESC





SELECT VH1.Schema_Name, VH1.Object_Name, VH1.Column_Name
, TMP.*
, VH2.Schema_Name, VH2.Object_Name, VH2.Column_Name
FROM #JunctionTemp AS TMP
JOIN TMP.TRK_0354_Value_Hash_Objects AS VH1 WITH(NOLOCK)
ON VH1.LNK_T4_ID = TMP.LNK_T4_ID_1
JOIN TMP.TRK_0354_Value_Hash_Objects AS VH2 WITH(NOLOCK)
ON VH2.LNK_T4_ID = TMP.LNK_T4_ID_2





