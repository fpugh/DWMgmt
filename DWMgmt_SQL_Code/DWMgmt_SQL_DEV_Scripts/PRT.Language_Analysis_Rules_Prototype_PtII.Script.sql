
/* Character Postion and Utilization 
	Source_ID is aggregated in the first step.
	All subsequent tests should use this a the
	base rule strength.
*/

select col.Collection_ID
, map.Source_ID
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
, map.Source_ID
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
, Source_ID
, Name
, ASCII_Char
, Char_Val
, Class_VCNS
, sum(Source_Count) as Source_Count
into #UtilizationClassSummary
from #CidChrPosUtiliztaion as tmp
group by Collection_ID
, Source_ID
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
, dom.Source_ID
, dom.Name
, dom.Class_VCNS
, dom.ASCII_Char
, dom.Char_Val
, dom.Source_Count
from #UtilizationClassSummary as dom with(nolock) 
join (
	select Source_ID
	, Class_VCNS
	, max(Source_Count) as Source_Count
	from #UtilizationClassSummary with(nolock) 
	group by Source_ID
	, Class_VCNS
	) as sub
on dom.Source_ID = sub.Source_ID
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
, dom.Collection_ID, dom.Source_ID, dom.Name, dom.ASCII_Char, dom.Char_Val, dom.Class_VCNS, dom.Source_Count
, sub.Rank_Value
, ROW_NUMBER() OVER(PARTITION BY dom.Source_ID ORDER BY sub.Rank_Value, sub.Class_VCNS, sub.Source_Count DESC) AS Relative_Rank
INTO #UtilizationClassAggregation
FROM #UtilizationClassSummary AS dom WITH(NOLOCK)
JOIN (
	SELECT ROW_NUMBER() OVER(PARTITION BY Source_ID, Class_VCNS ORDER BY Source_Count DESC) AS Rank_Value
	, Source_ID
	, Class_VCNS
	, Source_Count
	FROM #UtilizationClassSummary WITH(NOLOCK)
	WHERE CLass_VCNS IN ('C','V')
	) AS sub
ON sub.Source_ID = dom.Source_ID
AND sub.Class_VCNS = dom.Class_VCNS
AND sub.Source_Count = dom.Source_Count
WHERE sub.Rank_Value < 4

UNION

SELECT 'T5M' as Phoneme_Class
, dom.Collection_ID, dom.Source_ID, dom.Name, dom.ASCII_Char, dom.Char_Val, dom.Class_VCNS, dom.Source_Count
, agg.Rank_Value
, agg.Relative_Rank
FROM #UtilizationClassSummary AS dom WITH(NOLOCK)
JOIN (
	SELECT dom.Source_ID
	, dom.Class_VCNS
	, dom.Source_Count
	, sub.Rank_Value
	, ROW_NUMBER() OVER(PARTITION BY dom.Source_ID ORDER BY sub.Rank_Value, sub.Class_VCNS, sub.Source_Count DESC) AS Relative_Rank
	FROM #UtilizationClassSummary AS dom WITH(NOLOCK)
	JOIN (
		SELECT ROW_NUMBER() OVER(PARTITION BY Source_ID, Class_VCNS ORDER BY Source_Count DESC) AS Rank_Value
		, ROW_NUMBER() OVER(PARTITION BY Source_ID ORDER BY Source_Count DESC) AS Absolute_Rank
		, Source_ID
		, Class_VCNS
		, Source_Count
		FROM #UtilizationClassSummary WITH(NOLOCK)
		WHERE CLass_VCNS IN ('C','V')
		) AS sub
	ON sub.Source_ID = dom.Source_ID
	AND sub.Class_VCNS = dom.Class_VCNS
	AND sub.Source_Count = dom.Source_Count
	) AS agg
ON agg.Source_ID = dom.Source_ID
AND agg.Class_VCNS = dom.Class_VCNS
AND agg.Source_Count = dom.Source_Count
WHERE Relative_Rank < 6

UNION

SELECT 'T1S' as Phoneme_Class
, dom.Collection_ID, dom.Source_ID, dom.Name, dom.ASCII_Char, dom.Char_Val, dom.Class_VCNS, dom.Source_Count
,1,1
FROM #UtilizationClassSummary AS dom WITH(NOLOCK)
JOIN (
	SELECT ROW_NUMBER() OVER(PARTITION BY Source_ID ORDER BY Source_Count DESC) AS Absolute_Rank
	
	, Source_ID
	, Class_VCNS
	, Source_Count
	FROM #UtilizationClassSummary WITH(NOLOCK)
	WHERE CLass_VCNS IN ('S')
	) AS sub
ON sub.Source_ID = dom.Source_ID
AND sub.Class_VCNS = dom.Class_VCNS
AND sub.Source_Count = dom.Source_Count
AND sub.Absolute_Rank = 1
ORDER BY Phoneme_Class, Rank_Value, Class_VCNS


SELECT *
FROM #UtilizationClassAggregation
ORDER BY Phoneme_Class, Class_VCNS, Source_ID, Source_Count desc



/* Character Recurrance Distance and Frequency 
	Use this base for deriving language rules
	based on postion, sequence, etc.
*/

--drop table #CidCharPosDistance

select cpu1.Collection_ID
, cpu1.Source_ID
, cpu1.ASCII_Char
, cpu1.Char_Val
, cpu1.Char_Pos as Low_Pos
, min(cpu2.Char_Pos) as High_Pos
into #CidCharPosDistance
from #CidChrPosUtiliztaion as cpu1 with(nolock)
join #CidChrPosUtiliztaion as cpu2 with(nolock)
on cpu1.ASCII_Char = cpu2.ASCII_Char
and cpu1.Collection_ID = cpu2.Collection_ID
and cpu1.Source_ID = cpu2.Source_ID
and cpu1.Char_Pos < cpu2.Char_Pos
group by cpu1.Collection_ID
, cpu1.Source_ID
, cpu1.ASCII_Char
, cpu1.Char_Val
, cpu1.Char_Pos






select case when ASCII_Char = 10 THEN 'Longest Line'
	when ASCII_Char = 124 THEN 'Widest Column'
	end as Use_Case
, Collection_ID, Source_ID
--, ASCII_Char, Char_Val
, count(*) as Set_Instances
, max(tmp.High_Pos - tmp.Low_Pos) as Set_Distance
from #CidCharPosDistance as tmp
where ASCII_Char in (124,10)
and High_Pos - Low_Pos > 1
group by Collection_ID, Source_ID
, ASCII_Char, Char_Val
order by Source_ID, Set_Distance desc


select Collection_ID, Source_ID, ExpectedColumns
, count(*) + 1 as ExpectedRows
from(
	select tmp.Collection_ID, tmp.Source_ID
	, count(crp.Char_Pos) + 1 as ExpectedColumns
	from #CidCharPosDistance as tmp
	cross apply (
		select Source_ID, Char_Pos
		from TMP.TXT_String_Map
		where ASCII_Char in (124)
		) as crp
	where tmp.ASCII_Char in (10)
	and crp.Source_ID = tmp.Source_ID
	and crp.Char_Pos between tmp.Low_Pos and tmp.High_Pos
	group by tmp.Collection_ID, tmp.Source_ID
	, tmp.High_Pos, tmp.Low_Pos
	) as sub
group by Collection_ID, Source_ID, ExpectedColumns
order by Source_ID, ExpectedColumns desc



select hsh.File_Name, stk.*
from TMP.TXT_Process_Hash as stk
left join LIB.External_String_Intake_Stack as hsh
on hsh.Version_Stamp = stk.Version_Stamp
where Source_ID = 19930







/* Algorithms to consider and apply 
-- decision tree
-- random forest
-- association rule mining
-- linear regression
-- k-means clustering
*/



--Collection_ID	Name	Class_VCNS	ASCII_Char	Char_Val	Source_Count
--7994					V			101			e			16209
--7994					S			124			|			16932
--7994					N			48			0			11023
--7994					C			110			n			11965



--Phoneme_Class	Collection_ID	Name	ASCII_Char	Char_Val	Class_VCNS	Source_Count	Rank_Value	Relative_Rank
--T1S			7994					124			|			S			16932			1			1
--T3C			7994					110			n			C			11965			1			1
--T3C			7994					116			t			C			11082			2			3
--T3C			7994					114			r			C			11040			3			5
--T3V			7994					101			e			V			16209			1			2
--T3V			7994					105			i			V			14360			2			4
--T3V			7994					97			a			V			13287			3			6
--T5M			7994					110			n			C			11965			1			1
--T5M			7994					116			t			C			11082			2			3
--T5M			7994					114			r			C			11040			3			5
--T5M			7994					101			e			V			16209			1			2
--T5M			7994					105			i			V			14360			2			4





/* Character Postion and Utilization 
	Source_ID is aggregated in the first step.
	All subsequent tests should use this a the
	base rule strength.

	DROP TABLE #CidGrphPosUtiliztaion
*/

; WITH Glyph_Map (Source_ID, ASCII_Char1, Char_Pos1, ASCII_Char2, Char_Pos2)
AS (
	SELECT map1.Source_ID, map1.ASCII_Char, map1.Char_Pos
	, map2.ASCII_Char, map2.Char_Pos
	FROM TMP.TXT_String_Map AS map1 WITH(NOLOCK)
	JOIN TMP.TXT_String_Map AS map2 WITH(NOLOCK)
	ON map1.Source_ID = map2.Source_ID
	AND map1.Char_Pos = map2.Char_Pos - 1
	)

SELECT col.Collection_ID, map.Source_ID
, map.Char_Pos1, map.Char_Pos2
, map.ASCII_Char1
, map.ASCII_Char2
, alf1.Char_Val+alf2.Char_Val as Graph_Val
, alf1.Class_VCNS+alf2.Class_VCNS as Graph_Class
, count(*) as Source_Count
INTO #CidGrphPosUtiliztaion
FROM Glyph_Map AS map with(nolock)
LEFT JOIN TMP.TXT_Process_Hash AS hsh with(nolock)
ON hsh.Source_ID = map.Source_ID
LEFT JOIN LIB.REG_Alphabet AS alf1 with(nolock)
ON alf1.ASCII_Char = map.ASCII_Char1
LEFT JOIN LIB.REG_Alphabet AS alf2 with(nolock)
ON alf2.ASCII_Char = map.ASCII_Char2
LEFT JOIN LIB.REG_Collections AS col with(nolock)
ON col.Collection_ID = hsh.Collection_ID
GROUP BY col.Collection_ID, map.Source_ID
, map.Char_Pos1, map.Char_Pos2
, map.ASCII_Char1
, map.ASCII_Char2
, alf1.Char_Val
, alf2.Char_Val
, alf1.Class_VCNS
, alf2.Class_VCNS

select * 
from #CidGrphPosUtiliztaion 
order by 2, 7 desc, 4


/* Summary by Character and Class
	This query introduces the name
	of the the class and collection
*/

select Collection_ID
, Source_ID
, ASCII_Char1
, ASCII_Char2
, Char_Pos1 as Char_Pos
, Graph_Val
, Graph_Class
, sum(Source_Count) as Source_Count
into #UtilizationGrphClassSummary
from #CidGrphPosUtiliztaion as tmp
group by Collection_ID
, Source_ID
, ASCII_Char1
, ASCII_Char2
, Char_Pos1
, Graph_Val
, Graph_Class
order by Collection_ID
, Graph_Class
, Source_Count desc
, Graph_Val

select * 
from #UtilizationGrphClassSummary 
order by 2,5,6 desc


/* Identify Top Grapheme per Graph Class
	Derive set delimiter where ASCII_Char1 or ASCII_Char2
	= T1S ASCII_Char.
*/

SELECT dom.Collection_ID
, dom.Source_ID
, agg.Char_Val as Delimiter
, dom.Graph_Class
, dom.ASCII_Char1
, dom.ASCII_Char2
, dom.Graph_Val
, SUM(dom.Source_Count) as Source_Count
FROM #UtilizationGrphClassSummary as dom WITH(NOLOCK)
JOIN #UtilizationClassAggregation as agg WITH(NOLOCK)
ON agg.Phoneme_Class = 'T1S'
AND agg.Collection_ID = dom.Collection_ID
AND (agg.ASCII_Char = dom.ASCII_Char1
OR agg.ASCII_Char = dom.ASCII_Char2)
GROUP BY dom.Collection_ID
, dom.Source_ID
, agg.Char_Val
, dom.Graph_Class
, dom.ASCII_Char1
, dom.ASCII_Char2
, dom.Graph_Val
ORDER BY Graph_Class, Source_Count DESC



/* Get Top Consonants and Vowels
	Keys determine which style is tested.
	T3C - Top three consonants per collection
	T3V - Top three vowels per collection
	T5M - The top five mixed characters (CVCVC) aka. Collection Phoneme.
	T1S - The top 1 symbolic character, or "universal delimiter" for the set.
*/

SELECT CASE WHEN CHARINDEX('C', dom.Graph_Class) > 0 THEN 'T3C' ELSE 'T3V' END as Phoneme_Class
, dom.Source_Count, dom.ASCII_Char1, dom.ASCII_Char2, dom.Graph_Val, dom.Graph_Class, dom.Source_Count
, sub.Rank_Value
, ROW_NUMBER() OVER(PARTITION BY dom.Collection_ID ORDER BY sub.Rank_Value, sub.Graph_Class, sub.Source_Count DESC) AS Relative_Rank
FROM #UtilizationGrphClassSummary AS dom WITH(NOLOCK)
JOIN (
	SELECT ROW_NUMBER() OVER(PARTITION BY Graph_Class ORDER BY Source_Count DESC) AS Rank_Value
	, Source_ID
	, Graph_Class
	, Source_Count
	FROM #UtilizationGrphClassSummary WITH(NOLOCK)
	WHERE CHARINDEX('V',Graph_Class) > 0
	OR CHARINDEX('C',Graph_Class) > 0
	) AS sub
ON sub.Source_ID = dom.Source_ID
AND sub.Graph_Class = dom.Graph_Class
AND sub.Source_Count = dom.Source_Count
WHERE sub.Rank_Value < 4

UNION

SELECT 'T5M' as Phoneme_Class
, dom.Source_ID, dom.ASCII_Char1, dom.ASCII_Char2, dom.Graph_Val, dom.Graph_Class, dom.Source_Count
, agg.Rank_Value
, agg.Relative_Rank
FROM #UtilizationGrphClassSummary AS dom WITH(NOLOCK)
JOIN (
	SELECT dom.Source_ID
	, dom.Graph_Class
	, dom.Source_Count
	, sub.Rank_Value
	, ROW_NUMBER() OVER(PARTITION BY dom.Collection_ID ORDER BY sub.Rank_Value, sub.Graph_Class, sub.Source_Count DESC) AS Relative_Rank
	FROM #UtilizationGrphClassSummary AS dom WITH(NOLOCK)
	JOIN (
		SELECT ROW_NUMBER() OVER(PARTITION BY Graph_Class ORDER BY Source_Count DESC) AS Rank_Value
		, ROW_NUMBER() OVER(PARTITION BY Collection_ID ORDER BY Source_Count DESC) AS Absolute_Rank
		, Source_ID
		, Graph_Class
		, Source_Count
		FROM #UtilizationGrphClassSummary WITH(NOLOCK)
		WHERE CHARINDEX('V',Graph_Class) > 0
		OR CHARINDEX('C',Graph_Class) > 0
		) AS sub
	ON sub.Source_ID = dom.Source_ID
	AND sub.Graph_Class = dom.Graph_Class
	AND sub.Source_Count = dom.Source_Count
	) AS agg
ON agg.Source_ID = dom.Source_ID
AND agg.Graph_Class = dom.Graph_Class
AND agg.Source_Count = dom.Source_Count
WHERE Relative_Rank < 6

UNION

SELECT 'T1S' as Phoneme_Class
, dom.Source_ID, dom.ASCII_Char1, dom.ASCII_Char2, dom.Graph_Val, dom.Graph_Class, dom.Source_Count
,1,1
FROM #UtilizationGrphClassSummary AS dom WITH(NOLOCK)
JOIN (
	SELECT ROW_NUMBER() OVER(PARTITION BY Collection_ID ORDER BY Source_Count DESC) AS Absolute_Rank
	, Source_ID
	, Graph_Class
	, Source_Count
	FROM #UtilizationGrphClassSummary WITH(NOLOCK)
	WHERE CHARINDEX('S',Graph_Class) > 0
	) AS sub
ON sub.Source_ID = dom.Source_ID
AND sub.Graph_Class = dom.Graph_Class
AND sub.Source_Count = dom.Source_Count
AND sub.Absolute_Rank = 1
ORDER BY Phoneme_Class, Rank_Value, Graph_Class


/* Character Recurrance Distance and Frequency 
	Use this base for deriving language rules
	based on postion, sequence, etc.
*/

--drop table #CidGrphPosDistance

select cpu1.Collection_ID
, cpu1.ASCII_Char1
, cpu1.ASCII_Char2
, cpu1.Graph_Val
, cpu1.Char_Pos as Low_Pos
, min(cpu2.Char_Pos) as High_Pos
into #CidGrphPosDistance
from #UtilizationGrphClassSummary as cpu1 with(nolock)
join #UtilizationGrphClassSummary as cpu2 with(nolock)
on cpu1.ASCII_Char1 = cpu2.ASCII_Char1
AND cpu1.ASCII_Char2 = cpu2.ASCII_Char2
and cpu1.Collection_ID = cpu2.Collection_ID
and cpu1.Char_Pos < cpu2.Char_Pos
group by cpu1.Collection_ID
, cpu1.ASCII_Char1
, cpu1.ASCII_Char2
, cpu1.Graph_Val
, cpu1.Char_Pos



select Collection_ID
, ASCII_Char1
, ASCII_Char2
, Graph_Val
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
from #CidGrphPosDistance
group by ASCII_Char1, ASCII_Char2, Graph_Val
--order by Set_Instances desc
--order by Min_Distance desc
order by Avg_Distance desc
--order by Max_Instances desc





