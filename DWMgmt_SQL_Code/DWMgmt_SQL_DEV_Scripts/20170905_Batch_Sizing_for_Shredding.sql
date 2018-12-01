
/* All Stack Content Review

select STK_ID, File_Path, File_Name, File_Status, File_Type, File_Size, File_Encoding, File_Author, Code_Page, File_Created, Post_Date, Version_Stamp, Batch_ID
from LIB.External_String_Intake_Stack as stk with(nolock)

*/


/* By Group Summaries 

select File_Type, count(stk_id) as FileCount, sum(File_Size) as TotalSize
from LIB.External_String_Intake_Stack as stk with(nolock)
group by File_Type

-- File_Type is a very good grouping mechanism, as it tends to strongly associate with the format of file content. 
-- Known delimited file types can be quickly processed without full text shredding required.

select File_Size, count(stk_id) as FileCount, sum(File_Size) as TotalSize
from LIB.External_String_Intake_Stack as stk with(nolock)
group by File_Size

-- File_Size is not useful, but quartiles of this may be. 

select sub.Size_Bracket, count(stk.stk_id) as FileCount, sum(stk.File_Size) as TotalSize
from LIB.External_String_Intake_Stack as stk with(nolock)
join (
	select ntile(5) over (order by File_Size) as Size_Bracket, STK_ID
	from LIB.External_String_Intake_Stack as stk with(nolock)
	) as sub
on stk.STK_ID = sub.STK_ID
group by sub.Size_Bracket

select File_Encoding, count(stk_id) as FileCount, sum(File_Size) as TotalSize
from LIB.External_String_Intake_Stack as stk with(nolock)
group by File_Encoding

-- Probably not useful as a grouping value, but possibly as a criterion.

select File_Author, count(stk_id) as FileCount, sum(File_Size) as TotalSize
from LIB.External_String_Intake_Stack as stk with(nolock)
group by File_Author

-- Probably not useful as a grouping value, but possibly as a criterion.

select Code_Page, count(stk_id) as FileCount, sum(File_Size) as TotalSize
from LIB.External_String_Intake_Stack as stk with(nolock)
group by Code_Page

-- Probably not useful as a grouping value, but possibly as a criterion.

select File_Created, count(stk_id) as FileCount, sum(File_Size) as TotalSize
from LIB.External_String_Intake_Stack as stk with(nolock)
group by File_Created

-- May be useful when time ordered processing is required, but possibly better as a criterion.

select Post_Date, count(stk_id) as FileCount, sum(File_Size) as TotalSize
from LIB.External_String_Intake_Stack as stk with(nolock)
group by Post_Date

-- May be useful when time ordered processing is required, but possibly better as a criterion.

*/



/* By File Path and Type
	
	-- Inner queries of CTE statements can usually be run directly to see the values returned.
	-- File batches appear to be best grouped by a combination of type as a criterion, and path as a batch group
 */

; with PartialPath (Id, PartialPath) 
as (
	select distinct dds.Id, dds.Value as PartialPath
	from LIB.External_String_Intake_Stack as stk with(nolock) 
	cross apply LIB.Document_Directory_Structure(stk.File_Path) as dds
	)

, PathSegment (Id, PathSegment)
as (
	select Id, PartialPath
	from PartialPath
	where Id = 1
	union all
	select p.Id, c.PathSegment + p.PartialPath
	from PathSegment c
	join PartialPath p
	on p.id = c.Id+1
	)

--select *
--from PathSegment

, PathSummary (Id, PathSegment, FileCount, TotalSize)
as (
	select seg.Id, seg.PathSegment, count(stk.STK_ID) as FileCount, sum(stk.File_Size) as TotalSize
	from LIB.External_String_Intake_Stack as stk with(nolock) 
	join PathSegment as seg
	on seg.PathSegment = left(stk.File_Path, len(seg.Pathsegment))
	group by seg.Id, seg.PathSegment
	)

--select sub.Id, sub.PathSegment, stk.File_Type, sub.FileCount, sub.TotalSize
--, count(stk.STK_ID) as FileCount_Stack
--, count(distinct stk.File_Type) as FileTypes_Stack
--, sum(stk.File_Size) as TotalSize_Stack
--, min(stk.File_Size) as MinSize_Stack
--, avg(stk.File_Size) as AvgSize_Stack
--, max(stk.File_Size) as MaxSize_Stack
--, lowcrp.File_Name as SmallFileName
--, lowcrp.File_Type as SmallFileType
--, hghcrp.File_Name as HighFileName
--, hghcrp.File_Type as HighFileType
--from LIB.External_String_Intake_Stack as stk with(nolock)
--join (
--	select distinct dom.Id, dom.PathSegment, dom.FileCount, dom.TotalSize
--	from PathSummary as dom
--	join (
--		select max(Id) as Id
--		from PathSummary
--		group by FileCount, TotalSize
--		) as sub
--	on sub.Id = dom.Id
--	) as sub
--on sub.PathSegment = replace(stk.File_Path, stk.File_Name,'')
--cross apply (
--	select File_Size, File_Name, File_Type
--	from LIB.External_String_Intake_Stack as stk with(nolock)
--	) as lowcrp
--cross apply (
--	select File_Size, File_Name, File_Type
--	from LIB.External_String_Intake_Stack as stk with(nolock)
--	) as hghcrp
--group by sub.Id, sub.PathSegment, stk.File_Type, sub.FileCount, sub.TotalSize
--, lowcrp.File_Name, lowcrp.File_Type, lowcrp.File_Size
--, hghcrp.File_Name, hghcrp.File_Type, hghcrp.File_Size
--having lowcrp.File_Size = min(stk.File_Size)
--and hghcrp.File_Size = max(stk.File_Size)



select seg.PathSegment
, stk.STK_ID, File_Path, File_Name, File_Status, File_Type, File_Size, File_Encoding, File_Author, Code_Page, File_Created, Post_Date, Version_Stamp, Batch_ID
, CAST(CASE WHEN LEFT(stk.File_Content,2) = 'ÿþ' THEN (stk.File_Size)/2 ELSE stk.File_Size 
	END AS INT) + 1 as StringLength
, CAST(ROUND(CASE WHEN LEFT(stk.File_Content,2) = 'ÿþ' THEN (stk.File_Size)/2 ELSE stk.File_Size 
	END/4000.000,0) AS INT) + 1 as StringSegments
--into #Batching
from LIB.External_String_Intake_Stack as stk with(nolock) 
join PathSummary as seg
on seg.PathSegment = replace(stk.File_Path, File_Name,'')
where File_Type = ''


select sub.BatchId
, com.*
from #Batching as com
join (
	select ntile(4) over (order by File_Size) as BatchID, STK_ID
	from #Batching
	) as sub
on sub.STK_ID = com.STK_ID
--where com.StringSegments <  (8*8*2)
order by File_Size, BatchID, Stk_ID



update stk set Batch_ID = 'TXTL999'
from LIB.External_String_Intake_Stack as stk with(nolock)
where STK_ID in (153,139,155,142,156,145)
-- Fails: 136, 146, 135, 140


