use AdventureWorks2012
go


select *
from [Production].[cvProductAndDescription]

insert into DWMgmt.TMP.TRK_0354_Long_String_Values (LNK_T4_ID, Value_Count, String, Source_ID, Batch_ID)

select crp.LNK_T4_ID
, count(*) as Value_Count
, pad.Description as String
, -1 as Source_ID
, 'Arabic' as Batch_ID
from [Production].[cvProductAndDescription] as pad
cross apply (
	select LNK_T4_ID
	from DWMgmt.CAT.VI_0200_Column_Tier_Latches
	where Schema_Bound_Name = '[Production].[cvProductAndDescription]'
	and REG_Column_Name = 'Description'
	) as crp
where pad.Language = 'Arabic'
group by crp.LNK_T4_ID
, pad.Description


--truncate table DWMgmt.TMP.TRK_0354_Long_String_Values

INSERT INTO DWMgmt.LIB.REG_Dictionary (Word)
SELECT Chunk
FROM DWMgmt.TMP.TRK_0354_Long_String_Values 
CROSS APPLY DWMgmt.LIB.SplitTable(' ',1, 256, String, LNK_T4_ID)
WHERE chunk != ''



INSERT INTO DWMgmt.LIB.REG_Collections (Name)

SELECT DISTINCT Batch_ID
FROM DWMgmt.TMP.TRK_0354_Long_String_Values



INSERT INTO DWMgmt.LIB.HSH_Collection_Hierarchy (Link_Type, RK_Collection_ID, FK_Collection_ID)

SELECT DISTINCT 1, RKc.Collection_ID, fkc.Collection_ID
FROM DWMgmt.TMP.TRK_0354_Long_String_Values as lsv
JOIN DWMgmt.LIB.REG_Collections as FKc
ON FKc.Name = lsv.Batch_ID
CROSS APPLY DWMgmt.LIB.REG_Collections as RKc
WHERE RKc.Name = 'Languages'


INSERT INTO DWMgmt.LIB.HSH_Collection_Lexicon (Collection_ID, Source_ID, Column_ID, Word_ID)


select col.Collection_ID, -1, lnk_t4_id, Word_ID
from (
	SELECT Chunk, LNK_T4_ID, Batch_ID
	FROM DWMgmt.TMP.TRK_0354_Long_String_Values 
	CROSS APPLY DWMgmt.LIB.SplitTable(' ',1, 256, String, LNK_T4_ID)
	WHERE chunk != ''
	) as dom
left join DWMgmt.LIB.REG_Collections as col
ON col.Name = dom.Batch_ID
left join DWMgmt.LIB.REG_Dictionary as dic
ON dic.Word = dom.Chunk


