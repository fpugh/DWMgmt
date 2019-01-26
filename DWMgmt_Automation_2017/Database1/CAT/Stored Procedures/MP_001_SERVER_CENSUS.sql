

CREATE PROCEDURE [CAT].[MP_001_SERVER_CENSUS]
@TargetDBLocation NVARCHAR(200) = N'master'
, @SourceDBLocation NVARCHAR(200) = N'DWMgmt'
, @SourceCollation NVARCHAR(60) = N'SQL_Latin1_General_CP1_CI_AS'
, @ExecuteStatus TINYINT = 2
, @SystemStatus TINYINT = 0

AS

IF @ExecuteStatus IN (0,2) SET NOCOUNT ON

DECLARE @SQL NVARCHAR(max)
, @ServerID NVARCHAR(16) 
, @SQL1 NVARCHAR(4000)
, @SQL2 NVARCHAR(4000)
, @SQL3 NVARCHAR(4000)
, @SQL4 NVARCHAR(4000)
, @SQL5 NVARCHAR(4000)
, @SQL6 NVARCHAR(4000)
, @SQL7 NVARCHAR(4000)
, @ExecuteSQL NVARCHAR(500)
, @SystemFilter NVARCHAR(256)

SET @SystemFilter = CASE WHEN @SystemStatus = 1 THEN 'AND db.Database_ID NOT IN (1,2,3,4)' ELSE '' END

SELECT @ServerID = REG_0100_ID
FROM CAT.REG_0100_Server_Registry
WHERE REG_Server_Name = @@SERVERNAME

SET NOCOUNT ON

-----------------------------
-- REGISTER ONLINE SERVERS --
-----------------------------
SET @SQL1 = '
SELECT 0 AS REG_0103_ID
, srv.Server_ID
, provider COLLATE '+@SourceCollation+' AS provider
, data_source COLLATE '+@SourceCollation+' AS data_source
, provider_string COLLATE '+@SourceCollation+' AS provider_string
, catalog COLLATE '+@SourceCollation+' AS catalog
FROM ['+@TargetDBLocation+'].sys.servers AS srv WITH(NOLOCK)
'

IF @ExecuteStatus <> 3 SET @SQL1 = '
INSERT INTO ['+@SourceDBLocation+'].TMP.REG_0103_Insert (REG_0103_ID, Server_ID, provider, data_source, provider_string, catalog)
' + @SQL1


SET @SQL2 = '
SELECT 0 AS REG_0101_ID
, '+@ServerID+'
, srv.Is_Linked
, srv.Is_Remote_Login_enabled
, srv.Is_rpc_out_enabled
, srv.Is_data_access_enabled
, srv.Is_Collation_compatible
, srv.uses_Remote_Collation
, isnull(srv.collation_Name, cast(serverproperty(''Collation'') as NVARCHAR)) 
    COLLATE '+@SourceCollation+' as collation_Name
, srv.connect_timeout
, srv.query_timeout
, srv.Is_System
, srv.Is_Remote_proc_transaction_promotion_enabled
FROM ['+@TargetDBLocation+'].sys.servers AS srv WITH(NOLOCK)
'

IF @ExecuteStatus <> 3 SET @SQL2 = '
INSERT INTO ['+@SourceDBLocation+'].TMP.REG_0101_Insert (REG_0101_ID, Server_ID, Is_Linked, Is_Remote_Login_enabled 
, Is_rpc_out_enabled, Is_data_access_enabled, Is_Collation_compatible, uses_Remote_Collation 
, collation_Name, connect_timeout, query_timeout, Is_System, Is_Remote_proc_transaction_promotion_enabled)
' + @SQL2


SET @SQL3 = '
SELECT 0 AS REG_0102_ID
, '+@ServerID+'
, srv.lazy_Schema_validation
, srv.Is_publisher
, srv.Is_subscriber
, srv.Is_distributor
, srv.Is_nonsql_subscriber
FROM ['+@TargetDBLocation+'].sys.servers AS srv WITH(NOLOCK)
'

IF @ExecuteStatus <> 3 SET @SQL3 = '
INSERT INTO ['+@SourceDBLocation+'].TMP.REG_0102_Insert (REG_0102_ID, Server_ID, lazy_Schema_validation
, Is_publisher, Is_subscriber, Is_distributor, Is_nonsql_subscriber)
' + @SQL3


SET @SQL4 = '
SELECT DISTINCT 0 AS REG_0201_ID, '+@ServerID+'
, db.Database_ID, db.page_verify_option
, db.Is_Auto_close_on, db.Is_Auto_shrink_on, db.Is_supplemental_logging_enabled
, db.Is_read_committed_snapshot_on, db.Is_Auto_Create_stats_on, db.Is_Auto_update_stats_on
, db.Is_Auto_update_stats_async_on, db.Is_ANSI_null_Default_on, db.Is_ANSI_nulls_on
, db.Is_ANSI_padding_on, db.Is_ANSI_warnings_on, db.Is_arithabort_on
, db.Is_concat_null_yields_null_on, db.Is_numeric_roundabort_on, db.Is_quoted_Identifier_on
FROM ['+@TargetDBLocation+'].sys.databases AS db WITH(NOLOCK)
CROSS APPLY ['+@TargetDBLocation+'].sys.servers AS srv WITH(NOLOCK)
WHERE srv.name = @@SERVERNAME
'+@SystemFilter+'
'

IF @ExecuteStatus <> 3 SET @SQL4 = '
INSERT INTO ['+@SourceDBLocation+'].TMP.REG_0201_Insert (REG_0201_ID , Server_ID , Database_ID , page_verify_option
, Is_Auto_close_on , Is_Auto_shrink_on, Is_supplemental_logging_enabled, Is_read_committed_snapshot_on
, Is_Auto_Create_stats_on,	Is_Auto_update_stats_on, Is_Auto_update_stats_async_on, Is_ANSI_null_Default_on
, Is_ANSI_nulls_on, Is_ANSI_padding_on, Is_ANSI_warnings_on, Is_arithabort_on, Is_concat_null_yields_null_on
, Is_numeric_roundabort_on, Is_quoted_Identifier_on)
' + @SQL4


SET @SQL5 = '
SELECT DISTINCT 0 AS REG_0202_ID, '+@ServerID+'
, db.Database_ID, db.Is_recursive_triggers_on, db.Is_cursor_close_on_commit_on
, db.Is_local_cursor_Default, db.Is_fulltext_enabled, db.Is_trustworthy_on, db.Is_db_chaining_on
, db.Is_parameterization_forced, db.Is_master_Key_encrypted_by_Server, db.Is_Published, db.Is_subscribed
, db.Is_merge_Published, db.Is_distributor, db.Is_sync_with_backup, db.Is_broker_enabled, db.Is_Date_correlation_on
FROM ['+@TargetDBLocation+'].sys.databases AS db WITH(NOLOCK)
CROSS APPLY ['+@TargetDBLocation+'].sys.servers AS srv WITH(NOLOCK)
WHERE srv.name = @@SERVERNAME
'+@SystemFilter+'
'

IF @ExecuteStatus <> 3 SET @SQL5 = '
INSERT INTO ['+@SourceDBLocation+'].TMP.REG_0202_Insert (REG_0202_ID, Server_ID, Database_ID, Is_recursive_triggers_on
, Is_cursor_close_on_commit_on, Is_local_cursor_Default, Is_fulltext_enabled, Is_trustworthy_on
, Is_db_chaining_on, Is_parameterization_forced, Is_master_Key_encrypted_by_Server, Is_Published 
, Is_subscribed, Is_merge_Published, Is_distributor, Is_sync_with_backup 
, Is_broker_enabled, Is_Date_correlation_on)
' + @SQL5


SET @SQL6 = '
SELECT 0 AS LNK_T2_ID, 0 AS REG_0100_ID, 0 AS REG_0200_ID
, '+@ServerID+', srv.name COLLATE '+@SourceCollation+' as Server_Name, srv.product
, db.Database_ID, db.name as Database_Name, db.compatibility_level, db.collation_Name
, db.recovery_model_Desc, ISNULL(db.Create_Date, srv.modify_Date) 
FROM ['+@TargetDBLocation+'].sys.databases AS db WITH(NOLOCK)
CROSS APPLY ['+@TargetDBLocation+'].sys.servers AS srv WITH(NOLOCK)
WHERE srv.name = @@SERVERNAME
'+@SystemFilter+'
'

IF @ExecuteStatus <> 3 SET @SQL6 = '
INSERT INTO ['+@SourceDBLocation+'].TMP.REG_0100_0200_Insert (LNK_T2_ID, REG_0100_ID, REG_0200_ID, Server_ID, Server_Name
, product, Database_ID, Database_Name, compatibility_level, collation_Name, recovery_model_Desc, Create_Date)
' + @SQL6


SET @SQL7 = '
SELECT DISTINCT 0, 0, '+@ServerID+', t1.database_id, t1.object_id, T1.action_type
, T1.action_date, T3.total_seeks, T3.total_scans, T3.total_lookups, T3.total_updates
FROM (
	SELECT DISTINCT database_id, object_id
	, piv.Action_Type, piv.Action_Date
	FROM ['+@TargetDBLocation+'].sys.dm_db_index_usage_stats
	UNPIVOT (Action_Date FOR Action_Type IN 
	(last_user_seek,last_user_scan,last_user_lookup,last_user_update
	,last_system_seek,last_system_scan,last_system_lookup,last_system_update)) AS piv
	) AS t1
JOIN (
	SELECT database_id
	, OBJECT_ID, MAX(Action_Date) as action_date
	FROM (SELECT DISTINCT database_id, object_id
	, piv.Action_Type, piv.Action_Date
	FROM ['+@TargetDBLocation+'].sys.dm_db_index_usage_stats
	UNPIVOT (Action_Date FOR Action_Type IN 
	(last_user_seek,last_user_scan,last_user_lookup,last_user_update
	,last_system_seek,last_system_scan,last_system_lookup,last_system_update)) AS piv) AS laz
	GROUP BY database_id, OBJECT_ID
	) AS T2
ON T2.database_id = T1.database_id
AND T2.object_id = T1.object_id
AND T2.action_date = T1.action_date
JOIN (
	SELECT database_id, object_id
	, SUM(user_seeks)+SUM(system_seeks) as total_seeks 
	, SUM(user_scans)+SUM(system_scans) as total_scans
	, SUM(user_lookups)+SUM(system_lookups) as total_lookups
	, SUM(user_updates)+SUM(system_updates) as total_updates
	FROM ['+@TargetDBLocation+'].sys.dm_db_index_usage_stats
	GROUP BY database_id, object_id
	) AS T3
ON T3.database_id = T1.database_id
AND T3.object_id = T1.object_id
'

IF @ExecuteStatus <> 3 SET @SQL7 = '
INSERT INTO ['+@SourceDBLocation+'].TMP.TRK_0300_Utiliztion_Insert (TRK_fk_T2_ID, TRK_fk_T3_ID, Server_ID, Database_ID
, Object_ID, TRK_Last_Action_Type, TRK_Last_Action_Date, Total_Seeks, Total_Scans, Total_Lookups, Total_Updates)
' + @SQL7



IF @ExecuteStatus in (0,3)
BEGIN
	SELECT 'REG_0103_Insert' AS SQL_Object_Name, @SQL1
	SELECT 'REG_0101_Insert' AS SQL_Object_Name, @SQL2
	SELECT 'REG_0102_Insert' AS SQL_Object_Name, @SQL3
	SELECT 'REG_0201_Insert' AS SQL_Object_Name, @SQL4
	SELECT 'REG_0202_Insert' AS SQL_Object_Name, @SQL5
	SELECT 'REG_0100_0200_Insert' AS SQL_Object_Name, @SQL6
	SELECT 'TRK_0200_0300_Insert' AS SQL_Object_Name, @SQL7
END


IF @ExecuteStatus in (1)
BEGIN
	PRINT @SQL1
	PRINT @SQL2
	PRINT @SQL3
	PRINT @SQL4
	PRINT @SQL5
	PRINT @SQL6
	PRINT @SQL7
END


IF @ExecuteStatus in (1,2)
BEGIN
	SET @SQL = cast(@SQL1 as NVARCHAR(max))+cast(@SQL2 as NVARCHAR(max))+cast(@SQL3 as NVARCHAR(max))
	+cast(@SQL4 as NVARCHAR(max))+cast(@SQL5 as NVARCHAR(max))+cast(@SQL6 as NVARCHAR(max))+cast(@SQL7 as NVARCHAR(max))
	SET @ExecuteSQL = '['+@TargetDBLocation+']..sp_executesql' 
	EXEC @ExecuteSQL @SQL
END