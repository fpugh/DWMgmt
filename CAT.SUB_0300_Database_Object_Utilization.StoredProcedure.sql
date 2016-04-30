USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[SUB_0300_Database_Object_Utilization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[SUB_0300_Database_Object_Utilization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[SUB_0300_Database_Object_Utilization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [CAT].[SUB_0300_Database_Object_Utilization]
@TargetDBLocation NVARCHAR(256)
, @SourceDBLocation NVARCHAR(256) = N''DWMgmt''
, @ExecuteStatus TINYINT = 1

AS

DECLARE @SQL NVARCHAR(MAX) 
, @SQL1 NVARCHAR(4000) = ''INSERT INTO ''+@SourceDBLocation+''[TMP].[TRK_0300_Utiliztion_Insert] (Server_ID, Database_ID, Object_ID
, TRK_Last_Action_Type, TRK_Last_Action_Date, TRK_Action_Weight
, Total_Seeks, Total_Scans, Total_Lookups, Total_Updates)''

, @SQL2 NVARCHAR(4000) = ''
SELECT DISTINCT 0 as server_id, t1.database_id, t1.object_id, T1.action_type AS TRK_Last_Action_Type
, T1.action_date AS TRK_Last_Action_Date, T1.Action_Weight AS TRK_Action_Weight
, T3.total_seeks, T3.total_scans, T3.total_lookups, T3.total_updates
FROM (
	SELECT DISTINCT database_id, object_id
	, piv.Action_Type
	, CASE WHEN piv.Action_Type like ''''%seek'''' THEN 1
		WHEN piv.Action_Type like ''''%scan'''' THEN 2
		WHEN piv.Action_Type like ''''%lookup'''' THEN 3
		WHEN piv.Action_Type like ''''%update'''' THEN 4
		END AS Action_Weight
	, piv.Action_Date
	FROM ''+@TargetDBLocation+''.sys.dm_db_index_usage_stats
	UNPIVOT (Action_Date FOR Action_Type IN 
	(last_user_seek,last_user_scan,last_user_lookup,last_user_update
	,last_system_seek,last_system_scan,last_system_lookup,last_system_update)) AS piv
	) AS t1
JOIN (
	SELECT database_id
	, OBJECT_ID, MAX(action_weight) as action_weight
	, MAX(Action_Date) as action_date
	FROM (	SELECT DISTINCT database_id, object_id
	, piv.Action_Type
	, CASE WHEN piv.Action_Type like ''''%seek'''' THEN 1
		WHEN piv.Action_Type like ''''%scan'''' THEN 2
		WHEN piv.Action_Type like ''''%lookup'''' THEN 3
		WHEN piv.Action_Type like ''''%update'''' THEN 4
		END AS Action_Weight
	, piv.Action_Date
	FROM ''+@TargetDBLocation+''.sys.dm_db_index_usage_stats
	UNPIVOT (Action_Date FOR Action_Type IN 
	(last_user_seek,last_user_scan,last_user_lookup,last_user_update
	,last_system_seek,last_system_scan,last_system_lookup,last_system_update)) AS piv) AS laz
	GROUP BY database_id, OBJECT_ID
	) AS T2
ON T2.action_weight = T1.action_weight
AND T2.database_id = T1.database_id
AND T2.object_id = T1.object_id
AND T2.action_date = T1.action_date
JOIN (
	SELECT database_id, object_id
	, SUM(user_seeks)+SUM(system_seeks) as total_seeks 
	, SUM(user_scans)+SUM(system_scans) as total_scans
	, SUM(user_lookups)+SUM(system_lookups) as total_lookups
	, SUM(user_updates)+SUM(system_updates) as total_updates
	FROM ''+@TargetDBLocation+''.sys.dm_db_index_usage_stats
	GROUP BY database_id, object_id
	) AS T3
ON T3.database_id = T1.database_id
AND T3.object_id = T1.object_id''


IF @ExecuteStatus IN (0,1)
BEGIN
	PRINT @SQL1
	PRINT @SQL2
END

IF @ExecuteStatus IN (1,2)
BEGIN
	SET @SQL = CAST(@SQL1 AS NVARCHAR(MAX))+CAST(@SQL2 AS NVARCHAR(MAX))
	EXECUTE SP_ExecuteSQL @SQL
END

' 
END
GO
