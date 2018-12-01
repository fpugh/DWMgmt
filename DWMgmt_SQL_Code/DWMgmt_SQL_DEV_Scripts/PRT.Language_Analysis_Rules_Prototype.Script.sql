
/* Character Postion and Utilization 
	Source_ID is aggregated in the first step.
	All subsequent tests should use this a the
	base rule strength.
*/

select col.Collection_ID
, col.Name
, map.Char_Pos
, alf.ASCII_Char
, alf.Char_Val
, alf.Class_VCNS
, count(*) as Source_Count
into #CidChrPosUtiliztaion
from TMP.TXT_String_Map as map with(nolock)
left join TMP.TXT_Process_Hash as hsh with(nolock)
on hsh.Source_ID = map.Source_ID
left join LIB.REG_Alphabet as alf with(nolock)
on alf.ASCII_Char = map.ASCII_Char
left join LIB.REG_Collections as col with(nolock)
on col.Collection_ID = hsh.Collection_ID
group by col.Collection_ID
, col.Name
, map.Char_Pos
, alf.ASCII_Char
, alf.Char_Val
, alf.Class_VCNS


--select * 
--from #CidChrPosUtiliztaion 
--order by 1, 7 desc, 4


/* Summary by Character and Class
	This query introduces the name
	of the the class and collection
*/

select Collection_ID
, Name
, ASCII_Char
, Char_Val
, Class_VCNS
, sum(Source_Count) as Source_Count
into #UtilizationClassSummary
from #CidChrPosUtiliztaion as tmp
group by Collection_ID
, Name
, ASCII_Char
, Char_Val
, Class_VCNS
order by Collection_ID
, Class_VCNS
, Source_Count desc
, Char_Val


--select * 
--from #UtilizationClassSummary 
--order by 1,5,6 desc



/* Identify Top Character per Class 
	Derive set delimiter from Class 'S'
*/

select dom.Collection_ID
, dom.Name
, dom.Class_VCNS
, dom.ASCII_Char
, dom.Char_Val
, dom.Source_Count
from #UtilizationClassSummary as dom with(nolock) 
join (
	select Collection_ID
	, Class_VCNS
	, max(Source_Count) as Source_Count
	from #UtilizationClassSummary with(nolock) 
	group by Collection_ID
	, Class_VCNS
	) as sub
on dom.Collection_ID = sub.Collection_ID
and dom.Class_VCNS = sub.Class_VCNS
and dom.Source_Count = sub.Source_Count


/* Get Top Consonants and Vowels
	Keys determine which style is tested.
	T3C - Top three consonants per collection
	T3V - Top three vowels per collection
	T5M - The top five mixed characters (CVCVC) aka. Collection Phoneme.
	T1S - The top 1 symbolic character, or "universal delimiter" for the set.
*/

SELECT CASE WHEN dom.Class_VCNS = 'C' THEN 'T3C' ELSE 'T3V' END as Phoneme_Class
, dom.Collection_ID, dom.Name, dom.ASCII_Char, dom.Char_Val, dom.Class_VCNS, dom.Source_Count
, sub.Rank_Value
, ROW_NUMBER() OVER(PARTITION BY dom.Collection_ID ORDER BY sub.Rank_Value, sub.Class_VCNS, sub.Source_Count DESC) AS Relative_Rank
FROM #UtilizationClassSummary AS dom WITH(NOLOCK)
JOIN (
	SELECT ROW_NUMBER() OVER(PARTITION BY Collection_ID, Class_VCNS ORDER BY Source_Count DESC) AS Rank_Value
	, Collection_ID
	, Class_VCNS
	, Source_Count
	FROM #UtilizationClassSummary WITH(NOLOCK)
	WHERE CLass_VCNS IN ('C','V')
	) AS sub
ON sub.Collection_ID = dom.Collection_ID
AND sub.Class_VCNS = dom.Class_VCNS
AND sub.Source_Count = dom.Source_Count
WHERE sub.Rank_Value < 4

UNION

SELECT 'T5M' as Phoneme_Class
, dom.Collection_ID, dom.Name, dom.ASCII_Char, dom.Char_Val, dom.Class_VCNS, dom.Source_Count
, agg.Rank_Value
, agg.Relative_Rank
FROM #UtilizationClassSummary AS dom WITH(NOLOCK)
JOIN (
	SELECT dom.Collection_ID
	, dom.Class_VCNS
	, dom.Source_Count
	, sub.Rank_Value
	, ROW_NUMBER() OVER(PARTITION BY dom.Collection_ID ORDER BY sub.Rank_Value, sub.Class_VCNS, sub.Source_Count DESC) AS Relative_Rank
	FROM #UtilizationClassSummary AS dom WITH(NOLOCK)
	JOIN (
		SELECT ROW_NUMBER() OVER(PARTITION BY Collection_ID, Class_VCNS ORDER BY Source_Count DESC) AS Rank_Value
		, ROW_NUMBER() OVER(PARTITION BY Collection_ID ORDER BY Source_Count DESC) AS Absolute_Rank
		, Collection_ID
		, Class_VCNS
		, Source_Count
		FROM #UtilizationClassSummary WITH(NOLOCK)
		WHERE CLass_VCNS IN ('C','V')
		) AS sub
	ON sub.Collection_ID = dom.Collection_ID
	AND sub.Class_VCNS = dom.Class_VCNS
	AND sub.Source_Count = dom.Source_Count
	) AS agg
ON agg.Collection_ID = dom.Collection_ID
AND agg.Class_VCNS = dom.Class_VCNS
AND agg.Source_Count = dom.Source_Count
WHERE Relative_Rank < 6

UNION

SELECT 'T1S' as Phoneme_Class
, dom.Collection_ID, dom.Name, dom.ASCII_Char, dom.Char_Val, dom.Class_VCNS, dom.Source_Count
,1,1
FROM #UtilizationClassSummary AS dom WITH(NOLOCK)
JOIN (
	SELECT ROW_NUMBER() OVER(PARTITION BY Collection_ID ORDER BY Source_Count DESC) AS Absolute_Rank
	, Collection_ID
	, Class_VCNS
	, Source_Count
	FROM #UtilizationClassSummary WITH(NOLOCK)
	WHERE CLass_VCNS IN ('S')
	) AS sub
ON sub.Collection_ID = dom.Collection_ID
AND sub.Class_VCNS = dom.Class_VCNS
AND sub.Source_Count = dom.Source_Count
AND sub.Absolute_Rank = 1
ORDER BY Collection_ID, Phoneme_Class, Rank_Value, Class_VCNS


/* Character Recurrance Distance and Frequency 
	Use this base for deriving language rules
	based on postion, sequence, etc.
*/

--drop table #CidCharPosDistance

select cpu1.Collection_ID
, cpu1.ASCII_Char
, cpu1.Char_Val
, cpu1.Char_Pos as Low_Pos
, min(cpu2.Char_Pos) as High_Pos
into #CidCharPosDistance
from #CidChrPosUtiliztaion as cpu1 with(nolock)
join #CidChrPosUtiliztaion as cpu2 with(nolock)
on cpu1.ASCII_Char = cpu2.ASCII_Char
and cpu1.Collection_ID = cpu2.Collection_ID
and cpu1.Char_Pos < cpu2.Char_Pos
group by cpu1.Collection_ID
, cpu1.ASCII_Char
, cpu1.Char_Val
, cpu1.Char_Pos




select Collection_ID
, ASCII_Char
, Char_Val
, count(*) as Set_Instances
, min(Low_Pos) as Min_Low_Pos
, max(High_Pos) as Max_High_Pos
, min(High_Pos-Low_Pos) as Min_Distance
, avg(High_Pos-Low_Pos) as Avg_Distance
, max(High_Pos-Low_Pos) as Max_Distance
, (max(High_Pos) - min(Low_Pos)) / count(*) as Limit_Check
, max(High_Pos) - min(Low_Pos) as Actual_Bounds
, count(*) * avg(High_Pos-Low_Pos) as Estimate_Bounds
, (count(*) * avg(High_Pos-Low_Pos)) - (max(High_Pos) - min(Low_Pos)) as Estimate_Skewness
from #CidCharPosDistance
group by Collection_ID, ASCII_Char, Char_Val
--order by Collection_ID, Set_Instances desc
--order by Collection_ID, Min_Distance desc
order by Collection_ID, Avg_Distance desc
--order by Collection_ID, Max_Instances desc





