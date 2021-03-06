use DWMgmt
go

drop table #JunctionKeys
drop table #JunctionSets

select Vals.[Column_Value], [LNK_T4_ID], [Value_Count]
into #JunctionKeys
from [DWMgmt].[TMP].[TRK_0354_Value_Hash] AS Vals WITH (NOLOCK)
join (
	select [Column_Value]
	, CASE WHEN REG_Index_Type IN ('UQ','PK') THEN -2 
		WHEN REG_Index_Type IN ('NC','CI') AND Is_Included_Column = 0 THEN -1
		ELSE 0 END
	+ CASE WHEN vw2.VID IS NOT NULL THEN -1 ELSE 0 END
	 as ScoreModifier
	from [DWMgmt].[TMP].[TRK_0354_Value_Hash] AS hsh WITH (NOLOCK)
	join [DWMgmt].[CAT].[VH_0343_Index_Column_Latches] AS vw1 WITH(NOLOCK)
	ON hsh.LNK_T4_ID = vw1.LNK_T4P_ID
	
	left join  [DWMgmt].[CAT].[VH_0345_Foreign_Key_Column_Latches] AS vw2 WITH(NOLOCK)
	ON hsh.LNK_T4_ID = vw2.LNK_T4P_ID

	where RTRIM(LTRIM(ISNULL([Value_Count],'')))!=''	-- This is a fundamental exclusion
	group by [Column_Value]
	 , CASE WHEN REG_Index_Type IN ('UQ','PK') THEN -2 
		WHEN REG_Index_Type IN ('NC','CI') AND Is_Included_Column = 0 THEN -1
		ELSE 0 END
	+ CASE WHEN vw2.VID IS NOT NULL THEN -1 ELSE 0 END
	having count(distinct [LNK_T4_ID]) > 1
	) as Keys
on Keys.[Column_Value] = Vals.[Column_Value]


create clustered index tdx_ci_JKey_K2_K3D 
ON [dbo].[#JunctionKeys] ([LNK_T4_ID], [Value_Count] DESC)

CREATE NONCLUSTERED INDEX tdx_nc_JKey_K3_I1_I2
ON [dbo].[#JunctionKeys] ([Value_Count])
INCLUDE ([Column_Value],[LNK_T4_ID])






select ref1.Schema_Bound_Name as CardinalObjectName, replace(replace(ref1.Column_Name,']',''),'[','') as CardinalColumNName
, ref1.Column_Type as CardinalDataType
, ref2.Schema_Bound_Name as ReferenceObjectName, replace(replace(ref2.Column_Name,']',''),'[','') as ReferenceColumnName
, ref2.Column_Type as ReferenceDataType
into #JunctionSets
from (
	select distinct tbl1.LNK_T4_ID as LNK_T4_ID_1
	, tbl2.LNK_T4_ID as LNK_T4_ID_2
	from #JunctionKeys as tbl1 with(nolock)
	join #JunctionKeys as tbl2 with(nolock)
	on ISNULL(tbl1.Column_Value,'') = ISNULL(tbl2.Column_Value,'')
	and tbl1.LNK_T4_ID != tbl2.LNK_T4_ID
	and tbl1.Value_Count < tbl2.Value_Count
	) as sub
join [DWMgmt].[TMP].[TRK_0354_Value_Hash_Objects] as ref1 with(nolock)
on ref1.LNK_T4_ID = sub.LNK_T4_ID_1
join [DWMgmt].[TMP].[TRK_0354_Value_Hash_Objects] as ref2 with(nolock)
on ref2.LNK_T4_ID = sub.LNK_T4_ID_2


/* VICTORY IS MINE!!! 

This has identified the approximate metric to positively identify models of data.
The JunctionKey table created above might be possible to optimize.
	- The simple math is sum(A.Records==B.Records)/sum(A.Records+B.Records)
	- Some datatypes do not count: date/time, auto-increment w/o foreign key reference.
	- Columns with foreign keys are explicit junctions.
	- Columns with clustered or unique indexes are exceptional candidates.
	- Columns with nonclustered nonunique indexes are +potential candidates.
	- Columns with char data types are +potential candidates.
*/


select CardinalObjectName, CardinalColumNName
, ReferenceObjectName, ReferenceColumnName
, LIB.Levenshtein(CardinalColumNName, ReferenceColumnName) as LevenshteinScore
, charindex(CardinalColumNName, ReferenceColumnName) as ContextualScoreA
, charindex(ReferenceColumnName, CardinalColumNName) as ContextualScoreB
, LIB.Levenshtein(CardinalColumNName, ReferenceColumnName)
	- charindex(CardinalColumNName, ReferenceColumnName)
	- charindex(ReferenceColumnName, CardinalColumNName) as SimpleScore
	
from #JunctionSets
where LIB.Levenshtein(CardinalColumNName, ReferenceColumnName) < 50
or charindex(CardinalColumNName, ReferenceColumnName) > 0
or charindex(ReferenceColumnName, CardinalColumNName) > 0
order by CardinalObjectName, CardinalColumNName, SimpleScore DESC
option(recompile)





--select [Server_Name], [Schema_Bound_Name], [Column_Name], [Column_Type]
--, [Column_Value], ASCII([Column_Value]) as ASCIIVal
--, [Value_Count]
--from [DWMgmt].[TMP].[TRK_0354_Value_Hash_Objects] AS VHO WITH(NOLOCK)
--join #JunctionKeys as JKey WITH(NOLOCK)
--on JKey.LNK_T4_ID = VHO.LNK_T4_ID
--order by 5, 7 desc, 1, 2, 3


--select [Server_Name], [Schema_Bound_Name], [Column_Name], [Column_Type], COUNT(DISTINCT [Column_Value]) AS SetMembers, SUM([Value_Count]) AS Instances
--from [DWMgmt].[TMP].[TRK_0354_Value_Hash_Objects] AS VHO WITH(NOLOCK)
--join #JunctionKeys as JKey WITH(NOLOCK)
--ON JKey.LNK_T4_ID = VHO.LNK_T4_ID
--group by [Server_Name], [Schema_Bound_Name], [Column_Name], [Column_Type]