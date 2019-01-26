

CREATE VIEW CAT.VI_Tier2_Full_Current
AS
SELECT t2p.T2P_ID, t2p.LNK_FK_T2_ID as LNK_T2_ID
, t2p.LNK_FK_0200_ID, t2p.LNK_FK_0201_ID, t2p.LNK_FK_0202_ID, t2p.LNK_FK_0203_ID, t2p.LNK_FK_0204_ID
, rdr.REG_Database_Name, rdr.REG_Recovery_Model, rdr.REG_Collation, rdr.REG_Compatibility
, epa.page_verify_option, epa.Is_auto_close_on, epa.Is_auto_shrink_on, epa.Is_supplemental_logging_enabled
, epa.Is_read_committed_snapshot_on, epa.Is_auto_Create_stats_on, epa.Is_auto_update_stats_on, epa.Is_auto_update_stats_async_on
, epa.Is_ansi_null_Default_on, epa.Is_ansi_nulls_on, epa.Is_ansi_padding_on, epa.Is_ansi_warnings_on, epa.Is_arithabort_on
, epa.Is_concat_null_yields_null_on, epa.Is_numeric_roundabort_on, epa.Is_quoted_IDentifier_on
, epb.REG_0202_ID, epb.Is_recursive_triggers_on, epb.Is_cursor_close_on_commit_on, epb.Is_local_cursor_Default
, epb.Is_fulltext_enabled, epb.Is_trustworthy_on, epb.Is_db_chaining_on, epb.Is_parameterization_forced
, epb.Is_master_Key_encrypted_by_server, epb.Is_Published, epb.Is_subscribed, epb.Is_merge_Published, epb.Is_distributor
, epb.Is_sync_with_backup, epb.Is_broker_enabled, epb.Is_Date_correlation_on, epb.REG_Create_Date
, rdf.REG_File_Name, rdf.REG_File_Type, rdf.REG_File_ID, rdf.REG_File_Max_Size, rdf.REG_File_Growth
, rds.REG_Schema_Name
FROM CAT.LNK_Tier2_Peers AS t2p WITH(NOLOCK)
JOIN CAT.REG_0200_Database_registry AS rdr WITH(NOLOCK)
ON t2p.LNK_FK_0200_ID = rdr.REG_0200_ID
JOIN CAT.REG_0201_Database_extended_properties_A AS epa WITH(NOLOCK)
ON t2p.LNK_FK_0201_ID = epa.REG_0201_ID
JOIN CAT.REG_0202_Database_extended_properties_B AS epb WITH(NOLOCK)
ON t2p.LNK_FK_0202_ID = epb.REG_0202_ID
JOIN CAT.REG_0203_Database_Files AS rdf WITH(NOLOCK)
ON t2p.LNK_FK_0203_ID = rdf.REG_0203_ID
JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
ON t2p.LNK_FK_0204_ID = rds.REG_0204_ID
WHERE GETDATE() BETWEEN t2p.LNK_Post_Date AND ISNULL(t2p.LNK_Term_Date, GETDATE())