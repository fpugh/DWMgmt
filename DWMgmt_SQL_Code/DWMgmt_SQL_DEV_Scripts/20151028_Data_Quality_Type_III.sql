 /* This code creates a basic data dictionary of one or more scanned tables.
	Package REG_Data_Profile.dtsx must run.
	- This could be deployed as a job, and exectued??
	-- Needs an SQL 2012+ Server currently.
	-- ~OR~ Rebuilt as 2008 Package (not difficult)
	- Long string values should be processed with a shredder
	-- All values should be passed through the LIB architecture
	-- This process will need to migrate to the collection/lexicon architecture.

	--TRUNCATE TABLE #ValueSources_Objects
	--TRUNCATE TABLE #ValueSources
	*/

IF EXISTS (SELECT name FROM tempdb.sys.tables WHERE name like N'#ValueSources%')
DROP TABLE #ValueSources

SELECT IDENTITY(BIGINT,1,1) AS TBL_ID, Collection_Name, REG_Server_name, REG_Database_Name, Schema_Bound_Name, REG_Column_Rank, v2.LNK_T4_ID, Column_Definition, Word as Column_Value, Word_Age_Days, Collection_Use_Count as Value_Count
INTO #ValueSources
FROM LIB.VC_2100_Meta_Dictionary as v1
LEFT JOIN CAT.VH_0200_Column_Tier_Latches as v2
ON v2.LNK_T4_ID = v1.Column_ID


IF EXISTS (SELECT name FROM tempdb.sys.tables WHERE name like N'#TopValues%')
DROP TABLE #TopValues

CREATE TABLE #TopValues (Database_Name NVARCHAR(65), Schema_Bound_Name NVARCHAR(256), Column_Definition NVARCHAR(128), Max_Data_Length INT, Column_Value NVARCHAR(MAX), ROWID INT, LNK_T4_ID INT, Typical_Values NVARCHAR(max))

INSERT INTO #TopValues
SELECT DISTINCT VHO.REG_Database_Name, VHO.Schema_Bound_Name, VHO.Column_Definition
, Lens.Max_Data_Length
, Val.Column_Value
, ROWID, VHO.LNK_T4_ID
, Typical_Values = 'Typical Values: '
FROM #ValueSources AS VHO WITH(NOLOCK)
JOIN (
	SELECT CASE WHEN ISNULL(LTRIM(RTRIM(vh1.Column_Value)),'') = '' THEN '<NULL/Empty>' ELSE vh1.Column_Value END AS Column_Value
		, vh1.LNK_T4_ID
		, Value_Count
		, rowid = DENSE_RANK() OVER (PARTITION BY LNK_T4_ID ORDER BY Value_Count DESC, ISNULL(Column_Value,'') DESC)
	FROM #ValueSources AS VH1 WITH(NOLOCK)
	) AS Val
ON Val.LNK_T4_ID = VHO.LNK_T4_ID
AND Val.rowid <= 5
JOIN (
	SELECT vh1.LNK_T4_ID, MAX(LEN(ISNULL(RTRIM(LTRIM(Column_Value)),''))) as Max_Data_Length
	FROM #ValueSources AS VH1 WITH(NOLOCK)
	GROUP BY vh1.LNK_T4_ID
	) as Lens
ON Lens.LNK_T4_ID = VHO.LNK_T4_ID
WHERE (VHO.Column_Definition like '%char%'
OR VHO.Column_Definition = 'Time'
OR VHO.Column_Definition in ('sysname','uniquidentifier'))


CREATE CLUSTERED INDEX tdx_ci_TopValues ON #TopValues (LNK_T4_ID, Rowid)


SET NOCOUNT OFF

	DECLARE @LNK_T4_ID INT = 0
	, @Rowid INT = 0
	, @TypicalValues NVARCHAR(max) = ''

	UPDATE tmp SET @TypicalValues = Typical_Values = 
					CASE WHEN @LNK_T4_ID = LNK_T4_ID AND @RowID <= RowID 
						THEN @TypicalValues +', '+ISNULL(Column_Value,'')
						ELSE Typical_Values+' '+ISNULL(Column_Value,'')
						END
				, @LNK_T4_ID = LNK_T4_ID
				, @Rowid = Rowid
	FROM #TopValues AS tmp
	OPTION(MAXDOP 1)

SET NOCOUNT ON


IF NOT EXISTS (SELECT name FROM sys.indexes WHERE name = N'idx_nc_ValSrc_K1_I2')
CREATE NONCLUSTERED INDEX [idx_nc_ValSrc_K1_I2]
ON #ValueSources ([LNK_T4_ID])
INCLUDE ([Column_Value])


; WITH Numchars (LNK_T4_ID, Numeric_Type_Flag)
AS (
	SELECT LNK_T4_ID, 1 as Numeric_Type_Flag
	FROM (
		SELECT LNK_T4_ID
		, ISNUMERIC(Column_Value) as Numeric_Char_Flag
		FROM #ValueSources
		WHERE Column_Value <> ''
		) AS tbl
	GROUP BY LNK_T4_ID
	HAVING SUM(Numeric_Char_Flag) > 0
	AND COUNT(DISTINCT Numeric_Char_Flag) = 1
	UNION
	SELECT LNK_T4_ID, 2 as Numeric_Type_Flag
	FROM (
		SELECT LNK_T4_ID
		, ISDATE(Column_Value) as Date_Type_Flag
		FROM #ValueSources
		WHERE Column_Value <> ''
		) AS tbl
	GROUP BY LNK_T4_ID
	HAVING SUM(Date_Type_Flag) > 0
	AND COUNT(DISTINCT Date_Type_Flag) = 1
	)


, MiniMax (LNK_T4_ID, Low_Column_Value, Low_Type_Flag, High_Column_Value, High_Type_Flag)
	AS (
	SELECT S1.LNK_T4_ID, S1.Column_Value
	, S1.Numeric_Type_Flag
	, ISNULL(S2.Column_Value, S1.Column_Value)
	, ISNULL(S2.Numeric_Type_Flag,0)
	FROM (
		SELECT TBL_ID, Column_Value, LNK_T4_ID, Numeric_Type_Flag
		FROM (
			SELECT VH1.TBL_ID 
				, VH1.Column_Value
				, VH1.LNK_T4_ID
				, Numeric_Type_Flag
				, rowid = DENSE_RANK() OVER (PARTITION BY VH1.LNK_T4_ID ORDER BY 
					CASE WHEN Numeric_Type_Flag = 1 THEN CAST(Column_Value AS float)
					ELSE CAST(CAST(CAST(Column_Value as datetime) as int) as float) END
				--, TBL_ID
				)
			FROM #ValueSources AS VH1 WITH(NOLOCK)
			JOIN NumChars
			ON NumChars.LNK_T4_ID = VH1.LNK_T4_ID
			) AS SUB
		WHERE rowid = 1
		) AS S1
	LEFT JOIN (	
		SELECT TBL_ID, Column_Value, LNK_T4_ID, Numeric_Type_Flag
		FROM (
			SELECT VH1.TBL_ID
				, VH1.Column_Value
				, VH1.LNK_T4_ID
				, Numeric_Type_Flag
				, rowid = DENSE_RANK() OVER (PARTITION BY VH1.LNK_T4_ID ORDER BY 
					CASE WHEN Numeric_Type_Flag = 1 THEN CAST(Column_Value AS float)
					ELSE CAST(CAST(CAST(Column_Value as datetime) as int) as float) END
				 DESC, TBL_ID)
			FROM #ValueSources AS VH1 WITH(NOLOCK)
			JOIN NumChars
			ON NumChars.LNK_T4_ID = VH1.LNK_T4_ID
			) AS SUB
		WHERE rowid = 1
		) AS S2
	ON S2.TBL_ID <> S1.TBL_ID
	AND S2.LNK_T4_ID = S1.LNK_T4_ID
	)


SELECT V1.REG_Object_Name, V1.REG_Column_Name, V1.Column_Definition, SUB.Max_Data_Length, V1.REG_Column_Rank
, TRK_total_values, TRK_Column_nulls, TRK_distinct_values
, TRK_density, TRK_uniqueness
, TRK_density * TRK_uniqueness AS Adjusted_Quality
, TMP.Typical_Values
FROM #TopValues AS TMP
JOIN CAT.VI_0200_Column_Tier_Latches AS V1
ON V1.LNK_T4_ID = TMP.LNK_T4_ID
JOIN (
	SELECT LNK_T4_ID, Max_Data_Length, MAX(ROWID) as RowID
	FROM #TopValues
	GROUP BY LNK_T4_ID, Max_Data_Length
	) AS SUB
ON SUB.LNK_T4_ID = TMP.LNK_T4_ID
AND SUB.ROWID = TMP.ROWID
LEFT JOIN NumChars
ON NumChars.LNK_T4_ID = TMP.LNK_T4_ID
LEFT JOIN CAT.VI_0354_Object_Data_Profile AS V2
ON V2.LNK_T4_ID = TMP.LNK_T4_ID
WHERE Numchars.LNK_T4_ID IS NULL

UNION

SELECT DISTINCT V1.REG_Object_Name, V1.REG_Column_Name, V1.Column_Definition
,  20 
, V1.REG_Column_Rank
, TRK_total_values, TRK_Column_nulls, TRK_distinct_values
, TRK_density, TRK_uniqueness
, TRK_density * TRK_uniqueness AS Adjusted_Quality
, 'Value Ranges - Minimum:  '
+ CASE WHEN cte.Low_Type_Flag = 1 AND CHARINDEX('.', cte.Low_Column_Value) > 0 THEN CAST(CAST(ISNULL(cte.Low_Column_Value,0) as float) as NVARCHAR)
	WHEN cte.Low_Type_Flag = 1 AND CHARINDEX('.', cte.Low_Column_Value) = 0 THEN CAST(CAST(ISNULL(cte.Low_Column_Value,0) as bigint) as NVARCHAR)
	WHEN cte.Low_Type_Flag = 2 AND cte.Low_Column_Value = '' THEN '<NULL/Empty>'
	WHEN cte.Low_Type_Flag = 2 AND cte.Low_Column_Value <> '' THEN CAST(CAST(ISNULL(cte.Low_Column_Value,-1) as datetime) as NVARCHAR)
	ELSE ' - ' END
+'   Maximum:  '
+ CASE WHEN cte.High_Type_Flag = 0 THEN 'Single Value'
	WHEN cte.High_Type_Flag = 1 AND CHARINDEX('.', cte.High_Column_Value) > 0 THEN CAST(CAST(ISNULL(cte.High_Column_Value,0) as float) as NVARCHAR)
	WHEN cte.High_Type_Flag = 1 AND CHARINDEX('.', cte.High_Column_Value) = 0 THEN CAST(CAST(ISNULL(cte.High_Column_Value,0) as bigint) as NVARCHAR)
	WHEN cte.High_Type_Flag = 2 AND cte.High_Column_Value = '' THEN '<NULL/Empty>'
	WHEN cte.High_Type_Flag = 2 AND cte.High_Column_Value <> '' THEN CAST(CAST(ISNULL(cte.High_Column_Value,-1) as datetime) as NVARCHAR)
	ELSE ' - ' END
FROM CAT.VI_0200_Column_Tier_Latches AS V1
JOIN MiniMax AS cte
ON cte.LNK_T4_ID = V1.LNK_T4_ID
LEFT JOIN CAT.VI_0354_Object_Data_Profile AS T1
ON T1.LNK_T4_ID = V1.LNK_T4_ID

order by 1,5
