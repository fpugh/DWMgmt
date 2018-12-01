
/* Run a standard profile on the data
	- Perform statistical analysis on the pertinent subsets
	- Recursive, Tree, etc.




/* How big is the source? */
-- drop table #Profile

SELECT vho.Database_Name, vho.Schema_Bound_Name, vho.Column_Name, vho.Column_Type, vho.LNK_T4_ID
, SUM(dom.Distinct_Values) as Distinct_Values
, SUM(dom.Value_Count)+SUM(ISNULL(lac.Value_Count,0)) AS Total_Value_Count
, SUM(ISNULL(lac.Value_Count,0)) AS Null_Values
, CASE WHEN SUM(lac.Value_Count) = 0 THEN 1 ELSE SUM(dom.Value_Count) / (SUM(dom.value_Count)+SUM(ISNULL(lac.Value_Count,0)) * 1.0000) END AS Data_Density
, SUM(dom.Distinct_Values) / (SUM(dom.Value_Count) * 1.0000) AS Cardinality
, SUM(CASE WHEN dom.Value_Stack = 'LSV' THEN 1 ELSE 0 END) AS Long_String_Flag
, NTILE(5) OVER(ORDER BY SUM(dom.Distinct_Values) / (SUM(dom.Value_Count) * 1.0000)) as Strata
INTO #Profile
FROM (
	SELECT LNK_T4_ID, COUNT(DISTINCT Column_Value) as Distinct_Values, SUM(Value_Count) as Value_Count, 'Hash' as Value_Stack
	FROM TMP.TRK_0354_Value_Hash
	WHERE Column_Value not in ('','<NULL>','NULL')
	GROUP BY LNK_T4_ID
	UNION
	SELECT LNK_T4_ID, COUNT(DISTINCT String) as Distinct_Values, SUM(Value_Count) as Value_Count, 'LSV' as Value_Stack
	FROM TMP.TRK_0354_Long_String_Values
	GROUP BY LNK_T4_ID
	) AS dom
LEFT JOIN (
	SELECT LNK_T4_ID, COUNT(DISTINCT Column_Value) as Distinct_Values, SUM(Value_Count) as Value_Count, 'Hash' as Value_Stack
	FROM TMP.TRK_0354_Value_Hash
	WHERE Column_Value in ('','<NULL>','NULL')
	GROUP BY LNK_T4_ID
	) AS lac
ON dom.LNK_T4_ID = lac.LNK_T4_ID
LEFT JOIN TMP.TRK_0354_Value_Hash_Objects AS vho
ON vho.LNK_T4_ID = dom.LNK_T4_ID
GROUP BY vho.Database_Name, vho.Schema_Bound_Name, vho.Column_Name, vho.Column_Type, vho.LNK_T4_ID
ORDER BY Cardinality, LNK_T4_ID, Total_Value_Count


select *
from #Profile
order by Cardinality


/* Basis of Model 
	Throw out the lower bindary fields - too low cardinality - essentially all the same value.
	Throw out the upper identifier field - cardinality 100%, and distinct values = value count.
	* Five to seven groups to walk through. 
	* Seven or eight groups are for summarization/bucketing
	* Two or three groups are summarize only.

	Focus on the following columns:
		[OFFENSE_CODE_EXTENSION]	-	 25074
		[DISTRICT_ID]	-	1397
		[OFFENSE_CATEGORY_ID]	-	151214.1
		[PRECINCT_ID]	-	158195
		[NEIGHBORHOOD_ID]	-	54838.1
		[OFFENSE_CODE]	-	4329
		[OFFENSE_TYPE_ID]	-	156256.1

	Total Records
*/


/** Variables to consider 
	DomainCount - Total Records
	Estimators - the number of trees to use
	MaxFeatures - the number of features a RF is allowed to try per tree.
	MinLeafs - the number of leaf nodes in the sample.
**/

DECLARE @DomainCount NVARCHAR(25)
, @Strata NVARCHAR(25)
, @LNK_T4_ID NVARCHAR(25)
, @ColumnName NVARCHAR(256)
, @SQL NVARCHAR(4000)
, @I INT = 1

SELECT @DomainCount = Total_Value_Count
FROM #Profile as tmp

DECLARE Sampler CURSOR FOR
SELECT Column_Name, LNK_T4_ID, Strata
FROM #Profile
WHERE Strata in (2,3)
ORDER BY cardinality

OPEN Sampler

FETCH NEXT FROM Sampler
INTO @ColumnName, @LNK_T4_ID, @Strata

WHILE @@FETCH_STATUS = 0

BEGIN

SET @SQL = '
SELECT '''+@Strata+''' as Sample_Tier
, '''+@ColumnName+''' as Sample_Source
, Column_Value as Sample_Value
, SUM(Value_Count) as Sample_Value_Count
, SUM(Value_Count) / ('+@DomainCount+' * 1.00000) as Sample_Proportion
INTO ##Sample'+CAST(@I as NVARCHAR(5))+'Set
FROM (
	SELECT Column_Value, Value_Count
	FROM TMP.TRK_0354_Value_Hash
	WHERE LNK_T4_ID = '+@LNK_T4_ID+'
	UNION 
	SELECT String, Value_Count
	FROM TMP.TRK_0354_Long_String_Values
	WHERE LNK_T4_ID = '+@LNK_T4_ID+'
	) as Dom
GROUP BY Column_Value

SELECT Sample_Source
, COUNT(DISTINCT Sample_Value) as Distinct_Value_Count
, max(Sample_Proportion) - min(Sample_Proportion) as ProportionalVariance
, max(Sample_Value_Count) - min(Sample_Value_Count) as RecordCountVariance
, STDEV(Sample_Value_Count) as StdDevCheck
FROM ##Sample'+CAST(@I as NVARCHAR(5))+'Set
GROUP BY Sample_Source
'
PRINT @SQL

SET @I = @I+1

FETCH NEXT FROM Sampler
INTO @ColumnName, @LNK_T4_ID, @Strata

END

CLOSE Sampler
DEALLOCATE Sampler




/* Result of Sampler output applied against statistical eval */

select ss.Sample_Value
, ss.Sample_Proportion
, crp.Avg_Sample_Proportion
, crp.StdDvP_Sample_Proportion
, (ss.Sample_Proportion - crp.Avg_Sample_Proportion)/crp.StdDvP_Sample_Proportion as Ptile
, ss.Sample_Value_Count
, crp.Avg_Sample_Value_Count
, crp.StdDvP_Sample_Value_Count
, (ss.Sample_Value_Count - crp.Avg_Sample_Value_Count)/crp.StdDvP_Sample_Value_Count as Ztile
from ##Sample5Set as SS
cross apply (
	SELECT Sample_Source
	, COUNT(DISTINCT Sample_Value) as Distinct_Value_Count
	, avg(Sample_Proportion) as Avg_Sample_Proportion
	, STDEVP(Sample_Proportion) as StdDvP_Sample_Proportion
	, avg(Sample_Value_Count) as Avg_Sample_Value_Count
	, STDEVP(Sample_Value_Count) as StdDvP_Sample_Value_Count
	FROM ##Sample5Set
	GROUP BY Sample_Source
	) as crp
