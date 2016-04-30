USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_Tier2_Full_Current]'))
DROP VIEW [CAT].[VI_Tier2_Full_Current]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_Tier2_Full_Current]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [CAT].[VI_Tier2_Full_Current]
AS
SELECT lnk.T2P_ID, lnk.LNK_FK_T2_ID as LNK_T2_ID
, lnk.LNK_FK_0200_ID, lnk.LNK_FK_0201_ID, lnk.LNK_FK_0202_ID, lnk.LNK_FK_0203_ID, lnk.LNK_FK_0204_ID
, reg1.REG_Database_Name, reg1.REG_Recovery_Model, reg1.REG_Collation, reg1.REG_Compatibility
, reg2.page_verify_option, reg2.Is_auto_close_on, reg2.Is_auto_shrink_on, reg2.Is_supplemental_logging_enabled
, reg2.Is_read_committed_snapshot_on, reg2.Is_auto_Create_stats_on, reg2.Is_auto_update_stats_on, reg2.Is_auto_update_stats_async_on
, reg2.Is_ansi_null_Default_on, reg2.Is_ansi_nulls_on, reg2.Is_ansi_padding_on, reg2.Is_ansi_warnings_on, reg2.Is_arithabort_on
, reg2.Is_concat_null_yields_null_on, reg2.Is_numeric_roundabort_on, reg2.Is_quoted_IDentifier_on
, reg3.REG_0202_ID, reg3.Is_recursive_triggers_on, reg3.Is_cursor_close_on_commit_on, reg3.Is_local_cursor_Default
, reg3.Is_fulltext_enabled, reg3.Is_trustworthy_on, reg3.Is_db_chaining_on, reg3.Is_parameterization_forced
, reg3.Is_master_Key_encrypted_by_server, reg3.Is_Published, reg3.Is_subscribed, reg3.Is_merge_Published, reg3.Is_distributor
, reg3.Is_sync_with_backup, reg3.Is_broker_enabled, reg3.Is_Date_correlation_on, reg3.REG_Create_Date
, reg4.REG_File_Name, reg4.REG_File_Type, reg4.REG_File_ID, reg4.REG_File_Max_Size, reg4.REG_File_Growth
, reg5.REG_Schema_Name
FROM CAT.LNK_Tier2_Peers AS lnk WITH(NOLOCK)
JOIN [CAT].[REG_0200_Database_registry] AS reg1 WITH(NOLOCK)
ON lnk.LNK_FK_0200_ID = reg1.REG_0200_ID
JOIN [CAT].[REG_0201_Database_extended_properties_A] AS reg2 WITH(NOLOCK)
ON lnk.LNK_FK_0201_ID = reg2.REG_0201_ID
JOIN [CAT].[REG_0202_Database_extended_properties_B] AS reg3 WITH(NOLOCK)
ON lnk.LNK_FK_0202_ID = reg3.REG_0202_ID
JOIN [CAT].[REG_0203_Database_Files] AS reg4 WITH(NOLOCK)
ON lnk.LNK_FK_0203_ID = reg4.REG_0203_ID
JOIN [CAT].[REG_0204_Database_Schemas] AS reg5 WITH(NOLOCK)
ON lnk.LNK_FK_0204_ID = reg5.REG_0204_ID
WHERE GETDATE() BETWEEN lnk.LNK_Post_Date AND isnull(lnk.LNK_Term_Date, getdate())
' 
GO
