

/* A simple list of compiled plans by type. Identifies volume and utilization of a particular plan handle.
	Plug in as a resource to the procedure performance analysis routines.
	ToDo: Collect usecounts and Size_in_bytes by plan handle as a tracking device.
		Use the following code:
		SELECT Plan_Handle
		, COUNT(DISTINCT objtype) as Object_Type_Count
		, SUM(usecounts) as Use_Counts
		, SUM(size_in_bytes) as Size_In_Bytes
		FROM sys.dm_exec_cached_plans
		GROUP BY Plan_Handle
*/



/* This source provides all relevant stats for a given object identified by plan or SQL handle, or database and object ID.
	ToDo: Reform procedure performance scrap with SQL/Plan handle focus. This will allow identifying bad or slow or heavilly used code.
		Code below illustrates table content.
		Use the following code: select * from sys.dm_exec_procedure_stats


		SELECT 0 as REG_0601_ID, 0 as server_id
		, database_id, object_id, type
		, sql_handle, plan_handle
		, cached_time as post_date
		, execution_count as current_execution_count
		, last_execution_time
		, last_worker_time
		, last_physical_reads
		, last_logical_writes
		, last_logical_reads
		, last_elapsed_time
		INTO tmp.TRK_0601_Performance_Tracking
		FROM sys.dm_exec_procedure_stats
		

*/



/* Figure out how to use these attributes to solve performance issues */
select distinct attribute
from sys.dm_exec_cached_plans as t1
cross apply sys.dm_exec_plan_attributes (t1.plan_handle) as func
order by attribute



/* A cross reference of SQL and Plan Handles by database_id and object_id 
	The following is prototype code for importing this information into the registry tracking collection.
	A fundamental unit of identity is established that can be tracked back to each item's
	performance profile and cross-referenced by reg_ID vs. Object_Id. 
	Objects with fundamentally identical seek logic may be tuned and combined
	if all selective logic between plans are identical or similar, the better performing version should be
	applied to enhance over-all system performance.
*/

SELECT 0 AS REG_0602_ID
, P1.dbid_execute as Exec_Target_DBId
, DB_NAME(CAST(P1.dbid_execute as INT)) as Exec_Target_DBName
, P1.dbid as Exec_Source_DBId
, DB_NAME(CAST(P1.dbid as INT)) as Exec_Source_DBName
, P1.objectid as Object_Id
, OBJECT_NAME(CAST(P1.objectid as INT), CAST(p1.dbid as INT)) as Exec_Object_Name
, P1.compat_level as SQL_Compatibility
, T1.sql_handle
, P1.plan_handle
, T1.execution_count
, T1.cached_time as post_date
, T1.last_execution_time
, T1.last_worker_time
, T1.last_physical_reads
, T1.last_logical_writes
, T1.last_logical_reads
, T1.last_elapsed_time
--INTO TMP.trk_0602_SQL_Plan_Tracking
FROM (
	SELECT plan_handle, value, Attribute 
	select *
	FROM sys.dm_exec_cached_plans as t1
	CROSS APPLY sys.dm_exec_plan_attributes (t1.plan_handle) as func
	WHERE t1.objtype <> 'Adhoc'
	) AS S1
PIVOT (
MAX(value)
FOR Attribute IN (dbid_execute, dbid, objectid, compat_level, sql_handle, Use_Counts)
) as P1
JOIN sys.dm_exec_procedure_stats AS T1
ON P1.objectid = T1.object_id
AND P1.dbid = t1.database_id


/* Other Query Plan cross-apply functions
	sys.dm_exec_sql_text
	sys.dm_exec_query_plan
*/


/*
	SELECT plan_handle, pvt.set_options, pvt.sql_handle
	FROM (
		  SELECT plan_handle, epa.attribute, epa.value 
		  FROM sys.dm_exec_cached_plans 
		  OUTER APPLY sys.dm_exec_plan_attributes(plan_handle) AS epa
		  WHERE cacheobjtype = 'Compiled Plan'
		  ) AS ecpa 
	PIVOT (MAX(ecpa.value) FOR ecpa.attribute IN ("set_options", "sql_handle")) AS pvt;


	SELECT usecounts, cacheobjtype, objtype, text 
	FROM sys.dm_exec_cached_plans 
	CROSS APPLY sys.dm_exec_sql_text(plan_handle) 
	--WHERE usecounts > 1 
	--AND objtype <> 'Prepared'
	ORDER BY usecounts DESC;


*/



--select * from tmp.trk_0602_SQL_Plan_Handles
--drop table tmp.trk_0602_SQL_Plan_Handles


/* Code to detect information about missing indexes. Try to extract "Statement" as a SQL Blob to apply in a lab environment.
	There are currently no "missing" indexes availble to review, but a column comparison with a value hash would be interesting.
	Can a value hash predict an index? Can a value-hash analysis drive index-creation on demand?
	
	UseTheFollowingCode:
		SELECT *
		FROM sys.dm_db_missing_index_details as idx
		CROSS APPLY sys.dm_db_missing_index_columns (idx.index_handle)
*/


