
CREATE PROCEDURE [CAT].[MP_003_CENTRAL_REGISTRY_PROCESS]
@SourceDBLocation NVARCHAR(256) = N'DWMgmt'
, @TargetDBLocation NVARCHAR(256) = N'DWMgmt'
, @SourceCollation NVARCHAR(64) = N'SQL_Latin1_General_CP1_CI_AS'
, @ExecuteStatus INT = 2

AS

IF @ExecuteStatus IN (0,2) SET NOCOUNT ON

DECLARE @SQL NVARCHAR(MAX)
, @SQL1 NVARCHAR(4000), @SQL2 NVARCHAR(4000), @SQL3 NVARCHAR(4000), @SQL4 NVARCHAR(4000), @SQL5 NVARCHAR(4000)
, @SQL6 NVARCHAR(4000), @SQL7 NVARCHAR(4000), @SQL8 NVARCHAR(4000), @SQL9 NVARCHAR(4000), @SQL10 NVARCHAR(4000)
, @SQL11 NVARCHAR(4000), @SQL12 NVARCHAR(4000), @SQL13 NVARCHAR(4000), @SQL14 NVARCHAR(4000), @SQL15 NVARCHAR(4000)
, @SQL16 NVARCHAR(4000), @SQL17 NVARCHAR(4000), @SQL18 NVARCHAR(4000), @SQL19 NVARCHAR(4000), @SQL20 NVARCHAR(4000)
, @SQL21 NVARCHAR(4000), @SQL22 NVARCHAR(4000)


/* !! WHY IS THERE (APPARENTLY) UNECESSARY DYNAMIC SQL HERE ?? 

	The initial concept of the code was designed to work across linked servers; therefor dynamic SQL is required.
	Additionally dynamic SQL provides the ability to deploy and execute in several modes including (@ExecuteStatus):
	0 = TSQL Debug Mode - Prints the complete statement for manaual execution/debug
	1 - TSQL Debug with Execute - Prints AND executes the statement for cases where unit testing/validation is desired
	2 - TSQL Execute Only - Executes the code with NOCOUNT ON option set; fastest execution for production-confirmed code
	3 - SSIS Prepared Statement - Presents the code in a format consumable by an SSIS package
*/


/** Primary insert section: All staging tables merged into the registry **/

/* Insert for all server level primary structural elements */

SET @SQL1 = '
INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0100_Server_Registry(REG_Server_Name, REG_Product, REG_Create_Date)

SELECT DISTINCT Server_Name, product, GETDATE()
FROM ['+@SourceDBLocation+'].TMP.REG_0100_0200_Insert AS t1 WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0100_Server_Registry AS t2 WITH(NOLOCK)
ON T2.REG_Server_Name = t1.Server_Name
AND T2.REG_Product = t1.product
WHERE T2.REG_0100_ID is null


INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0101_Linked_Server_Settings (REG_Linked_Flag, REG_Remote_Login_Flag, REG_RPC_Out_Flag
, REG_Data_Access_Flag, REG_Collation_Compatible, REG_Remote_Collation_Flag, REG_Collation_Name, REG_Connection_TO
, REG_Query_TO, REG_System_Flag, REG_RPT_TPE_Flag)

SELECT DISTINCT TMP.Is_Linked, TMP.Is_Remote_Login_enabled, TMP.Is_rpc_out_enabled, TMP.Is_data_access_enabled
, TMP.Is_Collation_compatible, TMP.uses_Remote_Collation, TMP.collation_Name, TMP.connect_timeout, TMP.query_timeout
, TMP.Is_System, TMP.Is_Remote_proc_transaction_promotion_enabled
FROM ['+@SourceDBLocation+'].TMP.REG_0101_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0101_Linked_Server_Settings AS reg WITH(NOLOCK)
ON TMP.Is_Linked = reg.REG_Linked_Flag
AND TMP.Is_Remote_Login_enabled = reg.REG_Remote_Login_Flag
AND TMP.Is_rpc_out_enabled = reg.REG_RPC_Out_Flag
AND TMP.Is_data_access_enabled = reg.REG_Data_Access_Flag
AND TMP.Is_Collation_compatible = reg.REG_Collation_Compatible
AND TMP.uses_Remote_Collation = reg.REG_Remote_Collation_Flag
AND TMP.collation_Name = reg.REG_Collation_Name COLLATE '+@SourceCollation+'
AND TMP.connect_timeout = reg.REG_Connection_TO
AND TMP.query_timeout = reg.REG_Query_TO
AND TMP.Is_System = reg.REG_System_Flag
AND TMP.Is_Remote_proc_transaction_promotion_enabled = reg.REG_RPT_TPE_Flag
WHERE reg.REG_0101_ID IS NULL


INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0102_Publication_Replication_Server_Settings (REG_Lazy_Schema_Flag
, REG_Publisher_Flag, REG_Subscriber_Flag, REG_Distributor_Flag, REG_NonSQL_Subcriber_Flag)

SELECT DISTINCT TMP.lazy_Schema_validation, TMP.Is_publisher, TMP.Is_subscriber, TMP.Is_distributor, TMP.Is_nonsql_subscriber
FROM ['+@SourceDBLocation+'].TMP.REG_0102_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0102_Publication_Replication_Server_Settings AS reg WITH(NOLOCK)
ON TMP.lazy_Schema_validation = reg.REG_Lazy_Schema_Flag
AND TMP.Is_publisher = reg.REG_Publisher_Flag
AND TMP.Is_subscriber = reg.REG_Subscriber_Flag
AND TMP.Is_distributor = reg.REG_Distributor_Flag
AND TMP.Is_nonsql_subscriber = reg.REG_NonSQL_Subcriber_Flag
WHERE reg.REG_0102_ID IS NULL


INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0103_Server_Providers (REG_Provider, REG_data_source, REG_Provider_string, REG_catalog)

SELECT DISTINCT TMP.provider, TMP.data_source, isnull(TMP.provider_string,''''), isnull(TMP.catalog,'''')
FROM ['+@SourceDBLocation+'].TMP.REG_0103_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0103_Server_Providers AS reg WITH(NOLOCK)
ON TMP.provider = reg.REG_Provider COLLATE '+@SourceCollation+'
AND TMP.data_source = reg.REG_Data_Source COLLATE '+@SourceCollation+'
AND isnull(TMP.provider_string,'''') = reg.REG_Provider_String COLLATE '+@SourceCollation+'
AND isnull(TMP.catalog,'''') = reg.REG_Catalog COLLATE '+@SourceCollation+'
WHERE reg.REG_0103_ID IS NULL
'


/* Insert for all database primary structural elements */

SET @SQL2 = '

INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0200_Database_Registry (REG_Database_Name, REG_Compatibility
, REG_Collation, REG_Recovery_Model, REG_Create_Date)

SELECT TMP.Database_Name, TMP.compatibility_level, ISNULL(TMP.collation_Name, ''Database_Default''), TMP.recovery_model_Desc, min(TMP.Create_Date) as Create_Date
FROM ['+@SourceDBLocation+'].TMP.REG_0100_0200_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0200_Database_Registry AS reg WITH(NOLOCK)
ON TMP.Database_Name = reg.REG_Database_Name COLLATE Database_Default
WHERE reg.REG_0200_ID IS NULL
GROUP BY TMP.Database_Name, TMP.compatibility_level, TMP.collation_Name, TMP.recovery_model_Desc


INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0201_Database_Extended_Properties_A (page_verify_option
, Is_Auto_close_on, Is_Auto_shrink_on, Is_supplemental_logging_enabled, Is_read_committed_snapshot_on, Is_Auto_Create_stats_on
, Is_Auto_update_stats_on, Is_Auto_update_stats_async_on, Is_ANSI_null_Default_on, Is_ANSI_nulls_on, Is_ANSI_padding_on
, Is_ANSI_warnings_on, Is_arithabort_on, Is_concat_null_yields_null_on, Is_numeric_roundabort_on, Is_quoted_Identifier_on)

SELECT DISTINCT TMP.page_verify_option, TMP.Is_Auto_close_on, TMP.Is_Auto_shrink_on, TMP.Is_supplemental_logging_enabled
, TMP.Is_read_committed_snapshot_on, TMP.Is_Auto_Create_stats_on, TMP.Is_Auto_update_stats_on, TMP.Is_Auto_update_stats_async_on
, TMP.Is_ANSI_null_Default_on, TMP.Is_ANSI_nulls_on, TMP.Is_ANSI_padding_on, TMP.Is_ANSI_warnings_on, TMP.Is_arithabort_on
, TMP.Is_concat_null_yields_null_on, TMP.Is_numeric_roundabort_on, TMP.Is_quoted_Identifier_on
FROM ['+@SourceDBLocation+'].TMP.REG_0201_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0201_Database_Extended_Properties_A AS reg WITH(NOLOCK)
ON TMP.page_verify_option = reg.page_verify_option 
AND TMP.Is_Auto_close_on = reg.Is_Auto_close_on
AND TMP.Is_Auto_shrink_on = reg.Is_Auto_shrink_on
AND TMP.Is_supplemental_logging_enabled = reg.Is_supplemental_logging_enabled
AND TMP.Is_read_committed_snapshot_on = reg.Is_read_committed_snapshot_on
AND TMP.Is_Auto_Create_stats_on = reg.Is_Auto_Create_stats_on
AND TMP.Is_Auto_update_stats_on = reg.Is_Auto_update_stats_on
AND TMP.Is_Auto_update_stats_async_on = reg.Is_Auto_update_stats_async_on
AND TMP.Is_ANSI_null_Default_on = reg.Is_ANSI_null_Default_on
AND TMP.Is_ANSI_nulls_on = reg.Is_ANSI_nulls_on
AND TMP.Is_ANSI_padding_on = reg.Is_ANSI_padding_on
AND TMP.Is_ANSI_warnings_on = reg.Is_ANSI_warnings_on
AND TMP.Is_arithabort_on = reg.Is_arithabort_on
AND TMP.Is_concat_null_yields_null_on = reg.Is_concat_null_yields_null_on
AND TMP.Is_numeric_roundabort_on = reg.Is_numeric_roundabort_on
AND TMP.Is_quoted_Identifier_on = reg.Is_quoted_Identifier_on
WHERE reg.REG_0201_ID IS NULL
'

/* Continuation of SQL2 due to large insert statement exceeding 4000 characters together */

SET @SQL3 = '

INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0202_Database_Extended_Properties_B (Is_recursive_triggers_on
, Is_cursor_close_on_commit_on, Is_local_cursor_Default, Is_fulltext_enabled, Is_trustworthy_on, Is_db_chaining_on
, Is_parameterization_forced, Is_master_Key_encrypted_by_Server, Is_Published, Is_subscribed, Is_merge_Published
, Is_distributor, Is_sync_with_backup, Is_broker_enabled, Is_Date_correlation_on)

SELECT DISTINCT TMP.Is_recursive_triggers_on, TMP.Is_cursor_close_on_commit_on, TMP.Is_local_cursor_Default
, TMP.Is_fulltext_enabled, TMP.Is_trustworthy_on, TMP.Is_db_chaining_on, TMP.Is_parameterization_forced
, TMP.Is_master_Key_encrypted_by_Server, TMP.Is_Published, TMP.Is_subscribed, TMP.Is_merge_Published
, TMP.Is_distributor, TMP.Is_sync_with_backup, TMP.Is_broker_enabled, TMP.Is_Date_correlation_on
FROM ['+@SourceDBLocation+'].TMP.REG_0202_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0202_Database_Extended_Properties_B AS reg WITH(NOLOCK)
ON TMP.Is_recursive_triggers_on = reg.Is_recursive_triggers_on
AND TMP.Is_cursor_close_on_commit_on = reg.Is_cursor_close_on_commit_on 
AND TMP.Is_local_cursor_Default = reg.Is_local_cursor_Default
AND TMP.Is_fulltext_enabled = reg.Is_fulltext_enabled
AND TMP.Is_trustworthy_on = reg.Is_trustworthy_on
AND TMP.Is_db_chaining_on = reg.Is_db_chaining_on
AND TMP.Is_parameterization_forced = reg.Is_parameterization_forced
AND TMP.Is_master_Key_encrypted_by_Server = reg.Is_master_Key_encrypted_by_Server
AND TMP.Is_Published = reg.Is_Published
AND TMP.Is_subscribed = reg.Is_subscribed
AND TMP.Is_merge_Published = reg.Is_merge_Published
AND TMP.Is_distributor = reg.Is_distributor
AND TMP.Is_sync_with_backup = reg.Is_sync_with_backup
AND TMP.Is_broker_enabled = reg.Is_broker_enabled
AND TMP.Is_Date_correlation_on = reg.Is_Date_correlation_on
WHERE reg.REG_0202_ID IS NULL


INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0203_Database_Files (REG_File_ID, REG_File_Type
, REG_File_Name, REG_File_Location, REG_File_Max_Size, REG_File_Growth)

SELECT DISTINCT TMP.File_ID, TMP.type, TMP.Database_File_Name, TMP.physical_Name --, TMP.max_Size, TMP.growth
, min(TMP.max_Size), min(TMP.growth)	-- The CORRECT way to do this is to eliminate the Size/Growth part here as TRK_0203 maintains this.
FROM ['+@SourceDBLocation+'].TMP.REG_0203_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0203_Database_Files AS reg WITH(NOLOCK)
ON TMP.File_ID = reg.REG_File_ID
AND TMP.Database_File_Name = reg.REG_File_Name COLLATE '+@SourceCollation+'
AND TMP.physical_Name = reg.REG_File_Location COLLATE '+@SourceCollation+'
WHERE reg.REG_0203_ID IS NULL
GROUP BY TMP.File_ID, TMP.type, TMP.Database_File_Name, TMP.physical_Name


INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0204_Database_Schemas (REG_Schema_Name)

SELECT DISTINCT TMP.Schema_Name
FROM ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0204_Database_Schemas AS Reg WITH(NOLOCK)
ON TMP.Schema_Name = reg.REG_Schema_Name COLLATE '+@SourceCollation+'
WHERE reg.REG_0204_ID IS NULL
'


/* Insert for all object level structural elements */

SET @SQL4 = '

INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0300_Object_Registry (REG_Object_Name, REG_Object_Type, REG_Create_Date)

SELECT TMP.Object_Name, TMP.Object_Type, ISNULL(MAX(TMP.Create_Date), getdate())
FROM ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0300_Object_Registry AS reg WITH(NOLOCK)
ON reg.REG_Object_Name = TMP.Object_Name COLLATE '+@SourceCollation+'
AND reg.REG_Object_Type = TMP.Object_Type COLLATE '+@SourceCollation+'
WHERE reg.REG_0300_ID IS NULL
GROUP BY TMP.Object_Name, TMP.Object_Type


INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0300_Object_Registry (REG_Object_Name, REG_Object_Type)

SELECT DISTINCT TMP.Index_Name, TMP.Index_Type
FROM ['+@SourceDBLocation+'].TMP.REG_Index_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0300_Object_Registry AS reg WITH(NOLOCK)
ON reg.REG_Object_Name = TMP.Index_Name COLLATE '+@SourceCollation+'
AND reg.REG_Object_Type = TMP.Index_Type COLLATE '+@SourceCollation+'
WHERE reg.REG_0300_ID IS NULL


INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0300_Object_Registry (REG_Object_Name, REG_Object_Type)

SELECT DISTINCT TMP.Key_Name, TMP.Key_Type
FROM ['+@SourceDBLocation+'].TMP.REG_Foreign_Key_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0300_Object_Registry AS reg WITH(NOLOCK)
ON reg.REG_Object_Name = TMP.Key_Name COLLATE '+@SourceCollation+'
AND reg.REG_Object_Type = TMP.Key_Type COLLATE '+@SourceCollation+'
WHERE reg.REG_0300_ID IS NULL


INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0300_Object_Registry (REG_Object_Name, REG_Object_Type)

SELECT DISTINCT TMP.Constraint_Name, TMP.Constraint_Type
FROM ['+@SourceDBLocation+'].TMP.REG_Constraint_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0300_Object_Registry AS reg WITH(NOLOCK)
ON reg.REG_Object_Name = TMP.Constraint_Name COLLATE '+@SourceCollation+'
AND reg.REG_Object_Type = TMP.Constraint_Type COLLATE '+@SourceCollation+'
WHERE reg.REG_0300_ID IS NULL


INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0300_Object_Registry (REG_Object_Name, REG_Object_Type)

SELECT DISTINCT TMP.Trigger_Name, TMP.Trigger_Type
FROM ['+@SourceDBLocation+'].TMP.REG_Trigger_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0300_Object_Registry AS reg WITH(NOLOCK)
ON reg.REG_Object_Name = TMP.Trigger_Name COLLATE '+@SourceCollation+'
AND reg.REG_Object_Type = TMP.Trigger_Type COLLATE '+@SourceCollation+'
WHERE reg.REG_0300_ID IS NULL
'


SET @SQL5 = '

INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0301_Index_Details (Is_Unique
, data_space_ID, Ignore_Dup_Key, Is_Primary_Key, Is_Unique_Constraint, Fill_Factor, Is_padded
, Is_Disabled, Is_hypothetical, Allow_Row_Locks, Allow_Page_Locks)

SELECT DISTINCT TMP.Is_Unique, TMP.data_space_ID, TMP.Ignore_Dup_Key, TMP.Is_Primary_Key
, TMP.Is_Unique_Constraint, TMP.Fill_Factor, TMP.Is_padded, TMP.Is_Disabled, TMP.Is_hypothetical
, TMP.Allow_Row_Locks, TMP.Allow_Page_Locks
FROM ['+@SourceDBLocation+'].TMP.REG_Index_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0301_Index_Details AS reg WITH(NOLOCK)
ON TMP.data_space_ID = reg.data_space_ID
AND TMP.Fill_Factor = reg.Fill_Factor
AND TMP.Is_Unique = reg.Is_Unique
AND TMP.Ignore_Dup_Key = reg.Ignore_Dup_Key
AND TMP.Is_Primary_Key = reg.Is_Primary_Key
AND TMP.Is_Unique_Constraint = reg.Is_Unique_Constraint
AND TMP.Is_padded = reg.Is_padded
AND TMP.Is_Disabled = reg.Is_Disabled
AND TMP.Is_hypothetical = reg.Is_hypothetical
AND TMP.Allow_Row_Locks = reg.Allow_Row_Locks
AND TMP.Allow_Page_Locks = reg.Allow_Page_Locks
WHERE reg.REG_0301_ID IS NULL


INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0302_Foreign_Key_Details (Is_ms_Shipped, Is_Published
, Is_Schema_Published, Is_Disabled, Is_not_trusted, Is_not_for_Replication, Is_System_Named, delete_referential_action
, update_referential_action, Key_Index_ID)

SELECT DISTINCT TMP.Is_ms_Shipped, TMP.Is_Published, TMP.Is_Schema_Published, TMP.Is_Disabled, TMP.Is_not_trusted, TMP.Is_not_for_Replication
, TMP.Is_System_Named, TMP.delete_referential_action, TMP.update_referential_action, TMP.Key_Index_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Foreign_Key_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0302_Foreign_Key_Details AS reg3 WITH(NOLOCK)
ON TMP.Is_ms_Shipped = reg3.Is_ms_Shipped
AND TMP.Is_Published = reg3.Is_Published
AND TMP.Is_Schema_Published = reg3.Is_Schema_Published
AND TMP.Is_Disabled = reg3.Is_Disabled
AND TMP.Is_not_trusted = reg3.Is_not_trusted
AND TMP.Is_not_for_Replication = reg3.Is_not_for_Replication
AND TMP.Is_System_Named = reg3.Is_System_Named
AND TMP.delete_referential_action = reg3.delete_referential_action
AND TMP.update_referential_action = reg3.update_referential_action
AND TMP.Key_Index_ID = reg3.Key_Index_ID
WHERE reg3.REG_0302_ID IS NULL
'


/* Insert for all column level structural elements */

SET @SQL6 = '

INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0302_Foreign_Key_Details (Is_ms_Shipped, Is_Published, Is_Schema_Published, Is_System_Named, Key_Index_ID)

SELECT DISTINCT TMP.Is_ms_Shipped, TMP.Is_Published, TMP.Is_Schema_Published, TMP.Is_System_Named, 0
FROM ['+@SourceDBLocation+'].TMP.REG_Constraint_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0302_Foreign_Key_Details AS reg WITH(NOLOCK)
ON TMP.Is_ms_Shipped = reg.Is_ms_Shipped
AND TMP.Is_Published = reg.Is_Published
AND TMP.Is_Schema_Published = reg.Is_Schema_Published
AND TMP.Is_System_Named = reg.Is_System_Named
AND reg.Key_Index_ID = 0
WHERE reg.REG_0302_ID IS NULL


INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0400_Column_Registry (REG_Column_Name, REG_Column_Type)

SELECT DISTINCT TMP.Column_Name, TMP.Column_Type
FROM ['+@SourceDBLocation+'].TMP.REG_0300_0401_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0400_Column_Registry AS reg WITH(NOLOCK)
ON reg.REG_Column_Type = TMP.Column_Type COLLATE '+@SourceCollation+' 
AND reg.REG_Column_Name = TMP.Column_Name COLLATE '+@SourceCollation+' 
WHERE reg.REG_0400_ID IS NULL


INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0401_Column_Properties (REG_Size
, REG_Scale, Is_Identity, Is_Nullable, Is_Default_Collation)

SELECT DISTINCT TMP.Column_Size, TMP.Column_Scale, TMP.Is_Identity, TMP.Is_Nullable, TMP.Is_Default_Collation
FROM ['+@SourceDBLocation+'].TMP.REG_0300_0401_Insert AS tmp WITH(NOLOCK)
LEFT OUTER JOIN ['+@SourceDBLocation+'].CAT.REG_0401_Column_Properties AS reg WITH(NOLOCK)
ON TMP.Column_Size = reg.REG_Size
AND TMP.Column_Scale = reg.REG_Scale
AND TMP.Is_Identity = reg.Is_Identity
AND TMP.Is_Nullable = reg.Is_Nullable
AND TMP.Is_Default_Collation = reg.Is_Default_Collation
WHERE reg.REG_0401_ID IS NULL


INSERT INTO ['+@TargetDBLocation+'].CAT.REG_0402_Column_Index_Details (Index_Column_ID, Partition_Ordinal, Is_Descending_Key, Is_Included_Column)

SELECT DISTINCT TMP.Index_Column_ID, TMP.Partition_Ordinal, TMP.Is_Descending_Key, TMP.Is_Included_Column
FROM ['+@SourceDBLocation+'].TMP.REG_Index_Insert AS tmp WITH(NOLOCK)
LEFT OUTER JOIN ['+@SourceDBLocation+'].CAT.REG_0402_Column_Index_Details AS reg WITH(NOLOCK)
ON TMP.Index_Column_ID = reg.Index_Column_ID
AND TMP.Partition_Ordinal = reg.Partition_Ordinal
AND TMP.Is_Descending_Key = reg.Is_Descending_Key
AND TMP.Is_Included_Column = reg.Is_Included_Column
WHERE reg.REG_0402_ID IS NULL
'


/** Primary Update Section: All staging tables stamped with their tier member identifiers **/

/* Update server level staging tables */

SET @SQL7 = '

UPDATE tmp SET REG_0100_ID = reg1.REG_0100_ID 
	, REG_0200_ID = reg2.REG_0200_ID
FROM ['+@SourceDBLocation+'].TMP.REG_0100_0200_Insert AS tmp
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0100_Server_Registry as reg1 WITH(NOLOCK)
ON TMP.Server_Name = reg1.REG_Server_Name COLLATE '+@SourceCollation+'
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0200_Database_Registry AS reg2 WITH(NOLOCK)
ON TMP.Database_Name = reg2.REG_Database_Name COLLATE '+@SourceCollation+'
WHERE reg1.REG_0100_ID IS NOT NULL
AND reg2.REG_0200_ID IS NOT NULL


UPDATE tmp1 SET REG_0101_ID = reg.REG_0101_ID 
FROM ['+@SourceDBLocation+'].TMP.REG_0101_Insert AS tmp1
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0101_Linked_Server_Settings AS reg WITH(NOLOCK)
ON tmp1.Is_Linked = reg.REG_Linked_Flag
AND tmp1.Is_Remote_Login_enabled = reg.REG_Remote_Login_Flag
AND tmp1.Is_rpc_out_enabled = reg.REG_RPC_Out_Flag
AND tmp1.Is_data_access_enabled = reg.REG_Data_Access_Flag
AND tmp1.Is_Collation_compatible = reg.REG_Collation_Compatible
AND tmp1.uses_Remote_Collation = reg.REG_Remote_Collation_Flag
AND tmp1.collation_Name = reg.REG_Collation_Name COLLATE '+@SourceCollation+'
AND tmp1.connect_timeout = reg.REG_Connection_TO
AND tmp1.query_timeout = reg.REG_Query_TO
AND tmp1.Is_System = reg.REG_System_Flag
AND tmp1.Is_Remote_proc_transaction_promotion_enabled = reg.REG_RPT_TPE_Flag
WHERE reg.REG_0101_ID IS NOT NULL


UPDATE tmp1 SET REG_0102_ID = reg.REG_0102_ID 
FROM ['+@SourceDBLocation+'].TMP.REG_0102_Insert AS tmp1
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0102_Publication_Replication_Server_Settings as reg WITH(NOLOCK)
ON tmp1.lazy_Schema_validation = reg.REG_Lazy_Schema_Flag
AND tmp1.Is_publisher = reg.REG_Publisher_Flag
AND tmp1.Is_subscriber = reg.REG_Subscriber_Flag
AND tmp1.Is_distributor = reg.REG_Distributor_Flag
AND tmp1.Is_nonsql_subscriber = reg.REG_NonSQL_Subcriber_Flag
WHERE reg.REG_0102_ID IS NOT NULL


UPDATE tmp SET REG_0103_ID = reg.REG_0103_ID 
FROM ['+@SourceDBLocation+'].TMP.REG_0103_Insert AS tmp
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0103_Server_Providers as reg WITH(NOLOCK)
ON TMP.Provider = reg.REG_Provider COLLATE '+@SourceCollation+'
AND TMP.Data_Source = reg.REG_Data_Source COLLATE '+@SourceCollation+'
AND isnull(TMP.Provider_String,'''') = reg.REG_Provider_String COLLATE '+@SourceCollation+'
AND isnull(TMP.Catalog,'''') = reg.REG_Catalog COLLATE '+@SourceCollation+'
WHERE reg.REG_0103_ID IS NOT NULL
'


/* Update database level staging tables */

SET @SQL8 = '

UPDATE tmp1 SET REG_0201_ID = reg.REG_0201_ID
FROM ['+@SourceDBLocation+'].TMP.REG_0201_Insert AS tmp1
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0201_Database_Extended_Properties_A AS reg WITH(NOLOCK)
ON tmp1.page_verify_option = reg.page_verify_option 
AND tmp1.Is_Auto_close_on = reg.Is_Auto_close_on
AND tmp1.Is_Auto_shrink_on = reg.Is_Auto_shrink_on
AND tmp1.Is_supplemental_logging_enabled = reg.Is_supplemental_logging_enabled
AND tmp1.Is_read_committed_snapshot_on = reg.Is_read_committed_snapshot_on
AND tmp1.Is_Auto_Create_stats_on = reg.Is_Auto_Create_stats_on
AND tmp1.Is_Auto_update_stats_on = reg.Is_Auto_update_stats_on
AND tmp1.Is_Auto_update_stats_async_on = reg.Is_Auto_update_stats_async_on
AND tmp1.Is_ANSI_null_Default_on = reg.Is_ANSI_null_Default_on
AND tmp1.Is_ANSI_nulls_on = reg.Is_ANSI_nulls_on
AND tmp1.Is_ANSI_padding_on = reg.Is_ANSI_padding_on
AND tmp1.Is_ANSI_warnings_on = reg.Is_ANSI_warnings_on
AND tmp1.Is_arithabort_on = reg.Is_arithabort_on
AND tmp1.Is_concat_null_yields_null_on = reg.Is_concat_null_yields_null_on
AND tmp1.Is_numeric_roundabort_on = reg.Is_numeric_roundabort_on
AND tmp1.Is_quoted_Identifier_on = reg.Is_quoted_Identifier_on
WHERE reg.REG_0201_ID IS NOT NULL


UPDATE tmp1 SET REG_0202_ID = reg.REG_0202_ID
FROM ['+@SourceDBLocation+'].TMP.REG_0202_Insert AS tmp1
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0202_Database_Extended_Properties_B AS reg WITH(NOLOCK)
ON tmp1.Is_recursive_triggers_on = reg.Is_recursive_triggers_on
AND tmp1.Is_cursor_close_on_commit_on = reg.Is_cursor_close_on_commit_on 
AND tmp1.Is_local_cursor_Default = reg.Is_local_cursor_Default
AND tmp1.Is_fulltext_enabled = reg.Is_fulltext_enabled
AND tmp1.Is_trustworthy_on = reg.Is_trustworthy_on
AND tmp1.Is_db_chaining_on = reg.Is_db_chaining_on
AND tmp1.Is_parameterization_forced = reg.Is_parameterization_forced
AND tmp1.Is_master_Key_encrypted_by_Server = reg.Is_master_Key_encrypted_by_Server
AND tmp1.Is_Published = reg.Is_Published
AND tmp1.Is_subscribed = reg.Is_subscribed
AND tmp1.Is_merge_Published = reg.Is_merge_Published
AND tmp1.Is_distributor = reg.Is_distributor
AND tmp1.Is_sync_with_backup = reg.Is_sync_with_backup
AND tmp1.Is_broker_enabled = reg.Is_broker_enabled
AND tmp1.Is_Date_correlation_on = reg.Is_Date_correlation_on
WHERE reg.REG_0202_ID IS NOT NULL


UPDATE tmp SET REG_0203_ID = reg.REG_0203_ID
FROM ['+@SourceDBLocation+'].TMP.REG_0203_Insert AS tmp
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0203_Database_Files AS reg WITH(NOLOCK)
ON TMP.File_ID = reg.REG_File_ID
AND TMP.Database_File_Name = reg.REG_File_Name COLLATE '+@SourceCollation+'
AND TMP.physical_Name = reg.REG_File_Location COLLATE '+@SourceCollation+'
WHERE reg.REG_0203_ID IS NOT NULL


UPDATE I1 SET REG_0204_ID = reg1.REG_0204_ID
	, REG_0300_ID = reg2.REG_0300_ID
FROM ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS I1
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0204_Database_Schemas AS reg1 WITH(NOLOCK)
ON I1.Schema_Name = reg1.REG_Schema_Name COLLATE '+@SourceCollation+'
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0300_Object_Registry AS reg2 WITH(NOLOCK)
ON reg2.REG_Object_Name = I1.Object_Name COLLATE '+@SourceCollation+'
AND reg2.REG_Object_Type = I1.Object_Type COLLATE '+@SourceCollation+'
WHERE reg1.REG_0204_ID IS NOT NULL
AND reg2.REG_0300_ID IS NOT NULL
'

/* Update column level staging tables */

SET @SQL9 = '

UPDATE tmp SET REG_0400_ID = reg1.REG_0400_ID
, REG_0401_ID = reg2.REG_0401_ID
FROM ['+@SourceDBLocation+'].TMP.REG_0300_0401_Insert AS tmp
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0400_Column_Registry AS reg1 WITH(NOLOCK)
ON reg1.REG_Column_Type = TMP.Column_Type COLLATE '+@SourceCollation+' 
AND reg1.REG_Column_Name = TMP.Column_Name COLLATE '+@SourceCollation+'
LEFT OUTER JOIN ['+@SourceDBLocation+'].CAT.REG_0401_Column_Properties AS reg2 WITH(NOLOCK)
ON TMP.Column_Size = reg2.REG_Size
AND TMP.Column_Scale = reg2.REG_Scale
AND TMP.Is_Identity = reg2.Is_Identity
AND TMP.Is_Nullable = reg2.Is_Nullable
AND TMP.Is_Default_Collation = reg2.Is_Default_Collation
WHERE reg1.REG_0400_ID IS NOT NULL
OR reg2.REG_0401_ID IS NOT NULL
'


/* Link server level members */

SET @SQL10 = '

INSERT INTO ['+@TargetDBLocation+'].TMP.Database_Latch_Insert (LNK_T2_ID, REG_0100_ID, REG_0200_ID, LNK_db_Rank, REG_0201_ID, REG_0202_ID, REG_0203_ID, REG_0204_ID)

SELECT DISTINCT I1.LNK_T2_ID, I1.REG_0100_ID, I1.REG_0200_ID, isnull(I1.Database_ID,0) as Database_ID, I2.REG_0201_ID, I3.REG_0202_ID, ISNULL(I4.REG_0203_ID,0), ISNULL(I5.REG_0204_ID,0)
FROM ['+@SourceDBLocation+'].TMP.REG_0100_0200_Insert as I1 WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].TMP.REG_0201_Insert as I2 WITH(NOLOCK)
ON I1.Server_ID = I2.Server_ID
AND I1.Database_ID = I2.Database_ID
LEFT JOIN ['+@SourceDBLocation+'].TMP.REG_0202_Insert as I3 WITH(NOLOCK)
ON I1.Server_ID = I3.Server_ID
AND I1.Database_ID = I3.Database_ID
LEFT JOIN ['+@SourceDBLocation+'].TMP.REG_0203_Insert as I4 WITH(NOLOCK)
ON I1.Server_ID = I4.Server_ID
AND I1.Database_ID = I4.Database_ID
LEFT JOIN ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert as I5 WITH(NOLOCK)
ON I1.Server_ID = I5.Server_ID
AND I1.Database_ID = I5.Database_ID


INSERT INTO ['+@TargetDBLocation+'].CAT.LNK_0100_0200_Server_Databases (LNK_FK_0100_ID, LNK_FK_0200_ID, LNK_db_Rank)

SELECT DISTINCT TMP.REG_0100_ID, TMP.REG_0200_ID, TMP.LNK_db_Rank
FROM ['+@SourceDBLocation+'].TMP.Database_Latch_Insert AS tmp WITH(NOLOCK)


UPDATE tmp SET LNK_T2_ID = lat.LNK_T2_ID
FROM ['+@SourceDBLocation+'].TMP.Database_Latch_Insert AS tmp
LEFT JOIN ['+@SourceDBLocation+'].CAT.LNK_0100_0200_Server_Databases AS lat WITH(NOLOCK)
ON lat.LNK_FK_0100_ID = TMP.REG_0100_ID
AND lat.LNK_FK_0200_ID = TMP.REG_0200_ID
AND lat.LNK_db_Rank = TMP.LNK_db_Rank
WHERE lat.LNK_T2_ID IS NOT NULL
AND lat.LNK_Term_Date >= GETDATE()


UPDATE tmp SET LNK_T2_ID = lat.LNK_T2_ID
FROM ['+@SourceDBLocation+'].TMP.REG_0100_0200_Insert AS tmp
LEFT JOIN ['+@SourceDBLocation+'].CAT.LNK_0100_0200_Server_Databases AS lat WITH(NOLOCK)
ON lat.LNK_FK_0100_ID = TMP.REG_0100_ID
AND lat.LNK_FK_0200_ID = TMP.REG_0200_ID
AND lat.LNK_db_Rank = TMP.Database_ID
WHERE lat.LNK_Term_Date >= GETDATE()


UPDATE I1 SET LNK_T2_ID = I2.LNK_T2_ID
FROM ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS I1
JOIN ['+@SourceDBLocation+'].TMP.REG_0100_0200_Insert AS I2 WITH(NOLOCK)
ON I1.Server_ID = I2.Server_ID
AND I2.Database_ID = I1.Database_ID
'


/* Update component insert modules */

SET @SQL11 = '

UPDATE tmp SET LNK_T2_ID = toi.LNK_T2_ID
, REG_0204_ID = toi.REG_0204_ID
, REG_0300_Prm_ID = par.REG_0300_ID
, REG_0300_Ref_ID = toi.REG_0300_ID
, REG_0301_ID = rid.REG_0301_ID
, REG_0400_ID = col.REG_0400_ID
, REG_0402_ID = cid.REG_0402_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Index_Insert AS tmp
JOIN ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS toi WITH(NOLOCK)
ON toi.Server_ID = TMP.Server_ID
AND toi.Database_ID = TMP.Database_ID
AND toi.Schema_ID = TMP.Schema_ID
AND toi.Object_ID = TMP.Parent_Object_ID
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0300_Object_Registry AS par WITH(NOLOCK)
ON par.REG_Object_Name = TMP.Index_Name COLLATE '+@SourceCollation+'
AND par.REG_Object_Type = TMP.Index_Type COLLATE '+@SourceCollation+'
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0301_Index_Details AS rid WITH(NOLOCK)
ON TMP.data_space_ID = rid.data_space_ID
AND TMP.Fill_Factor = rid.Fill_Factor
AND TMP.Is_Unique = rid.Is_Unique
AND TMP.Ignore_Dup_Key = rid.Ignore_Dup_Key
AND TMP.Is_Primary_Key = rid.Is_Primary_Key
AND TMP.Is_Unique_Constraint = rid.Is_Unique_Constraint
AND TMP.Is_padded = rid.Is_padded
AND TMP.Is_Disabled = rid.Is_Disabled
AND TMP.Is_hypothetical = rid.Is_hypothetical
AND TMP.Allow_Row_Locks = rid.Allow_Row_Locks
AND TMP.Allow_Page_Locks = rid.Allow_Page_Locks
LEFT OUTER JOIN ['+@SourceDBLocation+'].CAT.REG_0400_Column_Registry AS col WITH(NOLOCK)
ON TMP.Parent_Column_Name = col.REG_Column_Name
AND TMP.Parent_Column_Type = col.REG_Column_Type
LEFT OUTER JOIN ['+@SourceDBLocation+'].CAT.REG_0402_Column_Index_Details AS cid WITH(NOLOCK)
ON TMP.Index_Column_ID = cid.Index_Column_ID
AND TMP.Partition_Ordinal = cid.Partition_Ordinal
AND TMP.Is_Descending_Key = cid.Is_Descending_Key
AND TMP.Is_Included_Column = cid.Is_Included_Column
'


SET @SQL12 = '

UPDATE tmp SET LNK_T2_ID = toi.LNK_T2_ID
, REG_0204_ID = toi.REG_0204_ID
, REG_0300_Prm_ID = par.REG_0300_ID
, REG_0300_Ref_ID = toi.REG_0300_ID
, REG_0400_ID = crf.REG_0400_ID
, REG_0302_ID = fkd.REG_0302_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Foreign_Key_Insert AS tmp
JOIN ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS toi WITH(NOLOCK)
ON toi.Server_ID = TMP.Server_ID
AND toi.Database_ID = TMP.Database_ID
AND toi.Schema_ID = TMP.Schema_ID
AND toi.Object_ID = TMP.Referenced_Object_ID
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0300_Object_Registry AS par WITH(NOLOCK)
ON par.REG_Object_Name = TMP.Key_Name COLLATE Database_Default
AND par.REG_Object_Type = ''F''
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0400_Column_Registry AS crf WITH(NOLOCK)
ON crf.REG_Column_Name = TMP.Referenced_Column_Name COLLATE '+@SourceCollation+'
AND crf.REG_Column_Type = TMP.Referenced_Column_Type
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0302_Foreign_Key_Details AS fkd WITH(NOLOCK)
ON fkd.Is_ms_Shipped = TMP.Is_ms_Shipped
AND fkd.Is_Published = TMP.Is_Published
AND fkd.Is_Schema_Published = TMP.Is_Schema_Published
AND fkd.Is_Disabled = TMP.Is_Disabled
AND fkd.Is_not_trusted = TMP.Is_not_trusted
AND fkd.Is_not_for_Replication = TMP.Is_not_for_Replication
AND fkd.Is_System_Named = TMP.Is_System_Named
AND fkd.delete_referential_action = TMP.delete_referential_action
AND fkd.update_referential_action = TMP.update_referential_action
AND fkd.Key_Index_ID = TMP.Key_Index_ID
'


SET @SQL13 = '

UPDATE tmp SET LNK_T2_ID = toi.LNK_T2_ID
, REG_0204_ID = toi.REG_0204_ID
, REG_0300_Ref_ID = toi.REG_0300_ID
, REG_0300_Prm_ID = ror.REG_0300_ID
, REG_0302_ID = cod.REG_0302_ID
, REG_0400_ID = col.REG_0400_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Constraint_Insert AS tmp
JOIN ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS toi WITH(NOLOCK)
ON toi.Server_ID = TMP.Server_ID
AND toi.Database_ID = TMP.Database_ID
AND toi.Schema_ID = TMP.Schema_ID
AND toi.Object_ID = TMP.Parent_Object_ID
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0300_Object_Registry AS ror WITH(NOLOCK)
ON ror.REG_Object_Name = TMP.Constraint_Name COLLATE '+@SourceCollation+'
AND ror.REG_Object_Type = TMP.Constraint_Type COLLATE '+@SourceCollation+'
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0302_Foreign_Key_Details AS cod WITH(NOLOCK)
ON cod.Is_ms_Shipped = TMP.Is_ms_Shipped
AND cod.Is_Published = TMP.Is_Published
AND cod.Is_Schema_Published = TMP.Is_Schema_Published
AND cod.Is_System_Named = TMP.Is_System_Named
AND cod.Key_Index_ID = 0
LEFT OUTER JOIN ['+@SourceDBLocation+'].CAT.REG_0400_Column_Registry AS col WITH(NOLOCK)
ON TMP.Parent_Column_Name = col.REG_Column_Name
AND TMP.Parent_Column_Type = col.REG_Column_Type


UPDATE tmp SET LNK_T2_ID = toi.LNK_T2_ID
, REG_0204_ID = toi.REG_0204_ID
, REG_0300_Ref_ID = toi.REG_0300_ID
, REG_0300_Prm_ID = ror.REG_0300_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Trigger_Insert AS tmp
JOIN ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS toi WITH(NOLOCK)
ON toi.Server_ID = TMP.Server_ID
AND toi.Database_ID = TMP.Database_ID
AND toi.Schema_ID = TMP.Schema_ID
AND toi.Object_ID = TMP.Parent_Object_ID
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0300_Object_Registry AS ror WITH(NOLOCK)
ON ror.REG_Object_Name = TMP.Trigger_Name COLLATE '+@SourceCollation+'
AND ror.REG_Object_Type = TMP.Trigger_Type COLLATE '+@SourceCollation+'
'


/* Link object level members */

SET @SQL14 = '

INSERT INTO ['+@TargetDBLocation+'].TMP.Object_Latch_Insert (LNK_T2_ID, LNK_T3_ID, REG_0204_ID, REG_0300_ID)

SELECT DISTINCT I1.LNK_T2_ID, 0, I1.REG_0204_ID, I1.REG_0300_ID
FROM ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS I1 WITH(NOLOCK)
UNION
SELECT DISTINCT I2.LNK_T2_ID, 0, I2.REG_0204_ID, I2.REG_0300_Prm_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Index_Insert AS I2 WITH(NOLOCK)
WHERE I2.REG_0300_Prm_ID > 0
UNION
SELECT DISTINCT I3.LNK_T2_ID, 0, I3.REG_0204_ID, I3.REG_0300_Prm_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Foreign_Key_Insert AS I3 WITH(NOLOCK)
WHERE I3.REG_0300_Prm_ID > 0
UNION
SELECT DISTINCT I4.LNK_T2_ID, 0, I4.REG_0204_ID, I4.REG_0300_Prm_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Constraint_Insert AS I4 WITH(NOLOCK)
WHERE I4.REG_0300_Prm_ID > 0
UNION
SELECT DISTINCT I4.LNK_T2_ID, 0, I4.REG_0204_ID, I4.REG_0300_Prm_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Trigger_Insert AS I4 WITH(NOLOCK)
WHERE I4.REG_0300_Prm_ID > 0


INSERT INTO ['+@TargetDBLocation+'].CAT.LNK_0204_0300_Schema_Binding (LNK_FK_T2_ID, LNK_FK_0204_ID, LNK_FK_0300_ID)

SELECT DISTINCT LNK_T2_ID, REG_0204_ID, REG_0300_ID 
FROM ['+@SourceDBLocation+'].TMP.Object_Latch_Insert
WHERE LNK_T2_ID <> 0


UPDATE tmp SET LNK_T3_ID = lat.LNK_T3_ID
FROM ['+@SourceDBLocation+'].TMP.Object_Latch_Insert AS tmp
LEFT JOIN ['+@SourceDBLocation+'].CAT.LNK_0204_0300_Schema_Binding AS lat WITH(NOLOCK)
ON lat.LNK_FK_T2_ID = TMP.LNK_T2_ID
AND lat.LNK_FK_0204_ID = TMP.REG_0204_ID
AND lat.LNK_FK_0300_ID = TMP.REG_0300_ID
WHERE lat.LNK_T3_ID IS NOT NULL
AND lat.LNK_Term_Date >= GETDATE()


UPDATE tmp SET LNK_T3_ID = lat.LNK_T3_ID
FROM ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS tmp
LEFT JOIN ['+@SourceDBLocation+'].CAT.LNK_0204_0300_Schema_Binding AS lat WITH(NOLOCK)
ON lat.LNK_FK_T2_ID = TMP.LNK_T2_ID
AND lat.LNK_FK_0204_ID = TMP.REG_0204_ID
AND lat.LNK_FK_0300_ID = TMP.REG_0300_ID
WHERE lat.LNK_T3_ID > 0
AND lat.LNK_Term_Date >= GETDATE()


UPDATE I1 SET REG_0300_ID = I2.REG_0300_ID
, LNK_T2_ID = I2.LNK_T2_ID
, LNK_T3_ID = I2.LNK_T3_ID
FROM ['+@SourceDBLocation+'].TMP.REG_0300_0401_Insert AS I1
LEFT JOIN ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS I2 WITH(NOLOCK)
ON I2.Server_ID = I1.Server_ID
AND I2.Database_ID = I1.Database_ID
AND I2.Schema_ID = I1.Schema_ID
AND I2.Object_ID = I1.Object_ID
AND I2.Object_Type = I1.Object_Type
WHERE I2.REG_0300_ID > 0


UPDATE tmp SET LNK_T3_ID = lat3.LNK_T3_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Index_Insert AS tmp
LEFT JOIN ['+@SourceDBLocation+'].CAT.LNK_0204_0300_Schema_Binding as lat3 WITH(NOLOCK)
ON lat3.LNK_FK_T2_ID = TMP.LNK_T2_ID
AND lat3.LNK_FK_0204_ID = TMP.REG_0204_ID
AND lat3.LNK_FK_0300_ID = TMP.REG_0300_Prm_ID
AND lat3.LNK_Term_Date >= GETDATE()
WHERE lat3.LNK_T3_ID IS NOT NULL


UPDATE tmp SET LNK_T3_ID = lat3.LNK_T3_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Foreign_Key_Insert AS tmp
LEFT JOIN ['+@SourceDBLocation+'].CAT.LNK_0204_0300_Schema_Binding as lat3 WITH(NOLOCK)
ON lat3.LNK_FK_T2_ID = TMP.LNK_T2_ID
AND lat3.LNK_FK_0204_ID = TMP.REG_0204_ID
AND lat3.LNK_FK_0300_ID = TMP.REG_0300_Prm_ID
AND lat3.LNK_Term_Date >= GETDATE()
WHERE lat3.LNK_T3_ID IS NOT NULL


UPDATE tmp SET LNK_T3_ID = lat3.LNK_T3_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Constraint_Insert AS tmp
LEFT JOIN ['+@SourceDBLocation+'].CAT.LNK_0204_0300_Schema_Binding as lat3 WITH(NOLOCK)
ON lat3.LNK_FK_T2_ID = TMP.LNK_T2_ID
AND lat3.LNK_FK_0204_ID = TMP.REG_0204_ID
AND lat3.LNK_FK_0300_ID = TMP.REG_0300_Prm_ID
AND lat3.LNK_Term_Date >= GETDATE()
WHERE lat3.LNK_T3_ID IS NOT NULL


UPDATE tmp SET LNK_T3_ID = lat3.LNK_T3_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Trigger_Insert AS tmp
LEFT JOIN ['+@SourceDBLocation+'].CAT.LNK_0204_0300_Schema_Binding as lat3 WITH(NOLOCK)
ON lat3.LNK_FK_T2_ID = TMP.LNK_T2_ID
AND lat3.LNK_FK_0204_ID = TMP.REG_0204_ID
AND lat3.LNK_FK_0300_ID = TMP.REG_0300_Prm_ID
AND lat3.LNK_Term_Date >= GETDATE()
WHERE lat3.LNK_T3_ID IS NOT NULL
'


/* Link column level members */

SET @SQL15 = '

UPDATE tmp SET LNK_T3R_ID = lnk.LNK_T3_ID
, LNK_0300_Ref_ID = lnk.REG_0300_ID
, LNK_Latch_Type = lnk.Object_Type
FROM ['+@SourceDBLocation+'].TMP.REG_0300_0300_Insert AS tmp
JOIN ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS lnk
ON lnk.Schema_Name = TMP.LNK_Ref_Schema_Name
AND lnk.Object_ID = TMP.LNK_Ref_Object_ID


UPDATE tmp SET LNK_T3P_ID = lnk.LNK_T3_ID
, LNK_0300_Prm_ID = lnk.REG_0300_ID
, LNK_Latch_Type = lnk.Object_Type
FROM ['+@SourceDBLocation+'].TMP.REG_0300_0300_Insert AS tmp
JOIN ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS lnk
ON lnk.Schema_Name = TMP.LNK_Prm_Schema_Name
AND lnk.Object_ID = TMP.LNK_Prm_Object_ID


INSERT INTO ['+@TargetDBLocation+'].TMP.Column_Latch_Insert (LNK_T2_ID, LNK_T3_ID, LNK_T4_ID, REG_0300_ID, REG_0400_ID, T4_Rank)

SELECT DISTINCT T3.LNK_T2_ID, T3.LNK_T3_ID, 0 as LNK_T4_ID, T3.REG_0300_ID, T4.REG_0400_ID, T4.Column_Rank
FROM ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS T3 WITH(NOLOCK)
JOIN ['+@SourceDBLocation+'].TMP.REG_0300_0401_Insert AS T4 WITH(NOLOCK)
ON T3.Server_ID = T4.Server_ID
AND T3.Database_ID = T4.Database_ID
AND T3.Schema_ID = T4.Schema_ID
AND T3.Object_ID = T4.Object_ID
AND T3.Object_Type = T4.Object_Type
UNION
SELECT DISTINCT idx.LNK_T2_ID, idx.LNK_T3_ID, 0, idx.REG_0300_Prm_ID, idx.REG_0400_ID, idx.Index_Column_ID 
FROM ['+@SourceDBLocation+'].TMP.REG_Index_Insert AS idx WITH(NOLOCK)
JOIN ['+@SourceDBLocation+'].TMP.REG_0300_0401_Insert AS T4 WITH(NOLOCK)
ON idx.Server_ID = T4.Server_ID
AND idx.Database_ID = T4.Database_ID
AND idx.Schema_ID = T4.Schema_ID
AND idx.Parent_Object_ID = T4.Object_ID
AND idx.Column_ID = T4.Column_Rank
WHERE  idx.LNK_T2_ID > 0
AND idx.LNK_T3_ID > 0
AND idx.REG_0300_Prm_ID > 0
AND idx.REG_0400_ID > 0
UNION
SELECT DISTINCT fks.LNK_T2_ID, fks.LNK_T3_ID, fks.LNK_T4_ID, fks.REG_0300_Prm_ID, T4.REG_0400_ID, fks.Key_Column_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Foreign_Key_Insert AS fks WITH(NOLOCK)
JOIN ['+@SourceDBLocation+'].TMP.REG_0300_0401_Insert AS T4 WITH(NOLOCK)
ON fks.Server_ID = T4.Server_ID
AND fks.Database_ID = T4.Database_ID
AND fks.Schema_ID = T4.Schema_ID
AND fks.Referenced_Object_ID = T4.Object_ID
AND fks.Referenced_Column_ID = T4.Column_Rank
WHERE  fks.LNK_T2_ID > 0
AND fks.LNK_T3_ID > 0
AND fks.REG_0300_Ref_ID > 0
AND fks.REG_0400_ID > 0
UNION
SELECT DISTINCT cst.LNK_T2_ID, cst.LNK_T3_ID, cst.LNK_T4_ID, cst.REG_0300_Prm_ID, T4.REG_0400_ID, 1
FROM ['+@SourceDBLocation+'].TMP.REG_Constraint_Insert AS cst WITH(NOLOCK)
JOIN ['+@SourceDBLocation+'].TMP.REG_0300_0401_Insert AS T4 WITH(NOLOCK)
ON cst.Server_ID = T4.Server_ID
AND cst.Database_ID = T4.Database_ID
AND cst.Schema_ID = T4.Schema_ID
AND cst.Parent_Object_ID = T4.Object_ID
AND cst.Parent_Column_ID = T4.Column_Rank
WHERE  cst.LNK_T2_ID > 0
AND cst.LNK_T3_ID > 0
AND cst.REG_0300_Prm_ID > 0
AND cst.REG_0400_ID > 0


INSERT INTO ['+@TargetDBLocation+'].CAT.LNK_0300_0400_Object_Column_Collection 
(LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0400_ID, LNK_Rank)

SELECT DISTINCT LNK_T3_ID, REG_0300_ID, REG_0400_ID, T4_Rank
FROM ['+@SourceDBLocation+'].TMP.Column_Latch_Insert AS tmp WITH(NOLOCK)
WHERE LNK_T3_ID <> 0


UPDATE tmp SET LNK_T4_ID = lat.LNK_T4_ID
FROM ['+@SourceDBLocation+'].TMP.Column_Latch_Insert AS tmp
LEFT JOIN ['+@SourceDBLocation+'].CAT.LNK_0300_0400_Object_Column_Collection AS lat WITH(NOLOCK)
ON lat.LNK_FK_T3_ID = TMP.LNK_T3_ID
AND lat.LNK_FK_0300_ID = TMP.REG_0300_ID
AND lat.LNK_FK_0400_ID = TMP.REG_0400_ID
WHERE lat.LNK_T4_ID IS NOT NULL
AND lat.LNK_Term_Date >= GETDATE()
'


/* Component insert modules combined and loaded into depenencies */

SET @SQL16 = '

UPDATE I1 SET LNK_T4_ID = I2.LNK_T4_ID
FROM ['+@SourceDBLocation+'].TMP.REG_0300_0401_Insert AS I1
LEFT JOIN ['+@SourceDBLocation+'].TMP.Column_Latch_Insert AS I2 WITH(NOLOCK)
ON I2.LNK_T2_ID = I1.LNK_T2_ID
AND I2.LNK_T3_ID = I1.LNK_T3_ID
AND I2.REG_0300_ID = I1.REG_0300_ID
AND I2.REG_0400_ID = I1.REG_0400_ID
WHERE I2.LNK_T3_ID > 0


UPDATE tmp SET LNK_T4_ID = lat4.LNK_T4_ID 
FROM ['+@SourceDBLocation+'].TMP.REG_Index_Insert AS tmp
LEFT JOIN ['+@SourceDBLocation+'].CAT.LNK_0300_0400_Object_Column_Collection as lat4 WITH(NOLOCK)
ON lat4.LNK_FK_T3_ID = TMP.LNK_T3_ID
AND lat4.LNK_FK_0300_ID = TMP.REG_0300_Prm_ID
AND lat4.LNK_FK_0400_ID = TMP.REG_0400_ID
AND lat4.LNK_Rank = TMP.Index_Column_ID
AND lat4.LNK_Term_Date >= GETDATE()
WHERE lat4.LNK_T4_ID IS NOT NULL


UPDATE tmp SET LNK_T4_ID = lat4.LNK_T4_ID 
FROM ['+@SourceDBLocation+'].TMP.REG_Foreign_Key_Insert AS tmp
LEFT JOIN ['+@SourceDBLocation+'].CAT.LNK_0300_0400_Object_Column_Collection as lat4 WITH(NOLOCK)
ON lat4.LNK_FK_T3_ID = TMP.LNK_T3_ID
AND lat4.LNK_FK_0300_ID = TMP.REG_0300_Prm_ID
AND lat4.LNK_FK_0400_ID = TMP.REG_0400_ID
AND lat4.LNK_Rank = TMP.Key_Column_ID
AND lat4.LNK_Term_Date >= GETDATE()
WHERE lat4.LNK_T4_ID IS NOT NULL


UPDATE tmp SET LNK_T4_ID = lat4.LNK_T4_ID 
FROM ['+@SourceDBLocation+'].TMP.REG_Constraint_Insert AS tmp
LEFT JOIN ['+@SourceDBLocation+'].CAT.LNK_0300_0400_Object_Column_Collection as lat4 WITH(NOLOCK)
ON lat4.LNK_FK_T3_ID = TMP.LNK_T3_ID
AND lat4.LNK_FK_0300_ID = TMP.REG_0300_Prm_ID
AND lat4.LNK_FK_0400_ID = TMP.REG_0400_ID
AND lat4.LNK_Term_Date >= GETDATE()
WHERE lat4.LNK_T4_ID IS NOT NULL
'

SET @SQL17 = '

INSERT INTO ['+@TargetDBLocation+'].CAT.LNK_0300_0300_Object_Dependencies (LNK_FK_T3P_ID, LNK_FK_T3R_ID
, LNK_Latch_Type, LNK_FK_0300_Prm_ID, LNK_FK_0300_Ref_ID, LNK_Rank)

SELECT DISTINCT TMP.LNK_T3_ID, lat.LNK_T3_ID
, TMP.Index_Type
, TMP.REG_0300_Prm_ID
, TMP.REG_0300_Ref_ID, TMP.Index_Rank
FROM ['+@SourceDBLocation+'].TMP.REG_Index_Insert AS tmp WITH(NOLOCK)
JOIN ['+@SourceDBLocation+'].CAT.LNK_0204_0300_Schema_Binding AS lat WITH(NOLOCK)
ON lat.LNK_FK_T2_ID = TMP.LNK_T2_ID
AND lat.LNK_FK_0204_ID = TMP.REG_0204_ID
AND lat.LNK_FK_0300_ID = TMP.REG_0300_Ref_ID
AND lat.LNK_Term_Date >= GETDATE()
UNION
SELECT DISTINCT TMP.LNK_T3_ID, lat.LNK_T3_ID
, TMP.Constraint_Type
, TMP.REG_0300_Prm_ID
, TMP.REG_0300_Ref_ID, 1
FROM ['+@SourceDBLocation+'].TMP.REG_Constraint_Insert AS tmp WITH(NOLOCK)
JOIN ['+@SourceDBLocation+'].CAT.LNK_0204_0300_Schema_Binding AS lat WITH(NOLOCK)
ON lat.LNK_FK_T2_ID = TMP.LNK_T2_ID
AND lat.LNK_FK_0204_ID = TMP.REG_0204_ID
AND lat.LNK_FK_0300_ID = TMP.REG_0300_Ref_ID
AND lat.LNK_Term_Date >= GETDATE()
UNION
SELECT DISTINCT TMP.LNK_T3_ID, lat.LNK_T3_ID
, TMP.Key_Type
, TMP.REG_0300_Prm_ID
, TMP.REG_0300_Ref_ID, TMP.Key_Column_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Foreign_Key_Insert AS tmp WITH(NOLOCK)
JOIN ['+@SourceDBLocation+'].CAT.LNK_0204_0300_Schema_Binding AS lat WITH(NOLOCK)
ON lat.LNK_FK_T2_ID = TMP.LNK_T2_ID
AND lat.LNK_FK_0204_ID = TMP.REG_0204_ID
AND lat.LNK_FK_0300_ID = TMP.REG_0300_Ref_ID
AND lat.LNK_Term_Date >= GETDATE()
UNION
SELECT DISTINCT TMP.LNK_T3_ID, lat.LNK_T3_ID
, TMP.Trigger_Type
, TMP.REG_0300_Prm_ID
, TMP.REG_0300_Ref_ID, 0
FROM ['+@SourceDBLocation+'].TMP.REG_Trigger_Insert AS tmp WITH(NOLOCK)
JOIN ['+@SourceDBLocation+'].CAT.LNK_0204_0300_Schema_Binding AS lat WITH(NOLOCK)
ON lat.LNK_FK_T2_ID = TMP.LNK_T2_ID
AND lat.LNK_FK_0204_ID = TMP.REG_0204_ID
AND lat.LNK_FK_0300_ID = TMP.REG_0300_Ref_ID
AND lat.LNK_Term_Date >= GETDATE()
UNION
SELECT DISTINCT TMP.LNK_T3P_ID, TMP.LNK_T3R_ID, LNK_Latch_Type
, LNK_0300_Prm_ID, LNK_0300_Ref_ID, LNK_Rank
FROM ['+@SourceDBLocation+'].TMP.REG_0300_0300_Insert AS tmp WITH(NOLOCK)
WHERE ISNULL(LNK_T3P_ID,0) <> 0
AND ISNULL(LNK_0300_Prm_ID,0) <> 0
AND ISNULL(LNK_T3R_ID,0) <> 0
AND ISNULL(LNK_0300_Ref_ID,0) <> 0
'

/** Link tier level members: This is performed here because there are additional checks performed,
    and tier linkages can change without destroying or invalidating the primary structure. **/

SET @SQL18 = '

INSERT INTO ['+@TargetDBLocation+'].CAT.LNK_Tier1_Peers (LNK_FK_0100_ID, LNK_FK_0101_ID, LNK_FK_0102_ID, LNK_FK_0103_ID)

SELECT DISTINCT I1.REG_0100_ID, I2.REG_0101_ID, I3.REG_0102_ID, isnull(I4.REG_0103_ID,0)
FROM ['+@SourceDBLocation+'].TMP.REG_0100_0200_Insert AS I1 WITH(NOLOCK)
JOIN ['+@SourceDBLocation+'].TMP.REG_0101_Insert AS I2
ON I1.Server_ID = I2.Server_ID
JOIN ['+@SourceDBLocation+'].TMP.REG_0102_Insert AS I3 WITH(NOLOCK)
ON I1.Server_ID = I3.Server_ID
LEFT JOIN ['+@SourceDBLocation+'].TMP.REG_0103_Insert AS I4 WITH(NOLOCK)
ON I1.Server_ID = I4.Server_ID


INSERT INTO ['+@SourceDBLocation+'].CAT.LNK_Tier2_Peers (LNK_FK_T2_ID, LNK_FK_0200_ID, LNK_FK_0201_ID
, LNK_FK_0202_ID, LNK_FK_0203_ID, LNK_FK_0204_ID, LNK_FK_0205_ID)

SELECT DISTINCT TMP.LNK_T2_ID, TMP.REG_0200_ID, TMP.REG_0201_ID, TMP.REG_0202_ID, TMP.REG_0203_ID, TMP.REG_0204_ID, 0
FROM ['+@SourceDBLocation+'].TMP.Database_Latch_Insert AS tmp
WHERE TMP.REG_0203_ID > 0
AND TMP.REG_0204_ID > 0


INSERT INTO ['+@TargetDBLocation+'].CAT.LNK_Tier3_Peers (LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0301_ID, LNK_FK_0302_FK_ID, LNK_FK_0302_CD_ID)

SELECT DISTINCT obj.LNK_T3_ID, obj.REG_0300_ID, isnull(idx.REG_0301_ID,0), isnull(fks.REG_0302_ID,0), isnull(cds.REG_0302_ID,0)
FROM ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS obj WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].TMP.REG_Index_Insert AS idx WITH(NOLOCK)
ON idx.REG_0204_ID = obj.REG_0204_ID
AND idx.REG_0300_Ref_ID = obj.REG_0300_ID
LEFT JOIN ['+@SourceDBLocation+'].TMP.REG_Constraint_Insert AS cds WITH(NOLOCK)
ON cds.REG_0204_ID = obj.REG_0204_ID
AND cds.REG_0300_Ref_ID = obj.REG_0300_ID
LEFT JOIN ['+@SourceDBLocation+'].TMP.REG_Foreign_Key_Insert AS fks WITH(NOLOCK)
ON fks.REG_0204_ID = obj.REG_0204_ID
AND fks.REG_0300_Ref_ID = obj.REG_0300_ID
WHERE obj.LNK_T3_ID <> 0


INSERT INTO ['+@TargetDBLocation+'].CAT.LNK_Tier4_Peers (LNK_FK_T4_ID, LNK_FK_0400_ID, LNK_FK_0401_ID, LNK_FK_0402_ID)

SELECT DISTINCT obj.LNK_T4_ID, obj.REG_0400_ID, ocl.REG_0401_ID, 0
FROM ['+@SourceDBLocation+'].TMP.Column_Latch_Insert as obj WITH(NOLOCK)
JOIN ['+@SourceDBLocation+'].TMP.REG_0300_0401_Insert as ocl WITH(NOLOCK)
ON ocl.LNK_T3_ID = obj.LNK_T3_ID
AND ocl.REG_0300_ID = obj.REG_0300_ID
AND ocl.REG_0400_ID = obj.REG_0400_ID
WHERE isnull(obj.LNK_T4_ID,0) <> 0
UNION
SELECT DISTINCT idx.LNK_T4_ID, idx.REG_0400_ID, ocl.REG_0401_ID, idx.REG_0402_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Index_Insert AS idx WITH(NOLOCK)
JOIN ['+@SourceDBLocation+'].TMP.REG_0300_0401_Insert AS ocl WITH(NOLOCK)
ON ocl.REG_0300_ID = idx.REG_0300_Ref_ID
AND ocl.REG_0400_ID = idx.REG_0400_ID
WHERE isnull(idx.LNK_T4_ID,0) <> 0
UNION
SELECT DISTINCT fks.LNK_T4_ID, fks.REG_0400_ID, ocl.REG_0401_ID, isnull(idx.REG_0402_ID,0)
FROM ['+@SourceDBLocation+'].TMP.REG_Foreign_Key_Insert AS fks WITH(NOLOCK)
JOIN ['+@SourceDBLocation+'].TMP.REG_0300_0401_Insert AS ocl WITH(NOLOCK)
ON ocl.REG_0300_ID = fks.REG_0300_Ref_ID
AND ocl.REG_0400_ID = fks.REG_0400_ID
LEFT JOIN ['+@SourceDBLocation+'].TMP.REG_Index_Insert AS idx WITH(NOLOCK)
ON ocl.REG_0300_ID = idx.REG_0300_Ref_ID
AND ocl.REG_0400_ID = idx.REG_0400_ID
WHERE isnull(fks.LNK_T4_ID,0) <> 0
UNION
SELECT DISTINCT cst.LNK_T4_ID, cst.REG_0400_ID, ocl.REG_0401_ID, isnull(idx.REG_0402_ID,0)
FROM ['+@SourceDBLocation+'].TMP.REG_Constraint_Insert AS cst WITH(NOLOCK)
JOIN ['+@SourceDBLocation+'].TMP.REG_0300_0401_Insert AS ocl WITH(NOLOCK)
ON ocl.REG_0300_ID = cst.REG_0300_Ref_ID
AND ocl.REG_0400_ID = cst.REG_0400_ID
LEFT JOIN ['+@SourceDBLocation+'].TMP.REG_Index_Insert AS idx WITH(NOLOCK)
ON ocl.REG_0300_ID = idx.REG_0300_Ref_ID
AND ocl.REG_0400_ID = idx.REG_0400_ID
WHERE isnull(cst.LNK_T4_ID,0) <> 0
'


/** All SQL code is hashed to a processing table where it can be assessed for libary catalogging. The formal process of entering
	the code to the libary will be handeled in a seperate job-batch. Registry table for REG_0600_Object_Code_Library will be loaded
	from this alternate process. **/
	
	
SET @SQL19 = '

UPDATE T1 SET LNK_T3_ID = T2.LNK_T3_ID
, REG_0300_ID = T2.REG_0300_ID 
FROM ['+@SourceDBLocation+'].TMP.REG_0600_Insert AS T1
JOIN ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS T2 WITH(NOLOCK)
ON t2.Server_ID = t1.Server_ID
AND t2.Database_ID = t1.Database_ID
AND t2.Schema_ID = t1.Schema_ID
AND t2.Object_ID = t1.Object_ID


UPDATE T1 SET LNK_T3_ID = T2.LNK_T3_ID
, REG_0300_ID = T2.REG_0300_Prm_ID 
FROM ['+@SourceDBLocation+'].TMP.REG_0600_Insert AS T1
JOIN ['+@SourceDBLocation+'].TMP.REG_Trigger_Insert AS T2 WITH(NOLOCK)
ON T1.Object_ID = T2.Trigger_Object_ID
AND T1.Object_Type = T2.Trigger_Type


INSERT INTO ['+@SourceDBLocation+'].LIB.Internal_String_Intake_Stack (Server_ID, Database_ID, Database_Name
, Schema_ID, Schema_Name, Object_ID, Object_Name, Object_Type, Create_Date, Code_Content)

SELECT DISTINCT Server_ID, Database_ID, Database_Name, Schema_ID, Schema_Name, Object_ID, Object_Name
, Object_Type, Create_Date, Code_Content
FROM ['+@SourceDBLocation+'].TMP.REG_0600_Insert AS tmp WITH(NOLOCK)
WHERE Code_Content IS NOT NULL


INSERT INTO ['+@SourceDBLocation+'].CAT.REG_0600_Object_Code_Library (REG_Code_Base, REG_Code_Content)

SELECT DISTINCT ''TSQL''
, Constraint_Definition
FROM ['+@SourceDBLocation+'].TMP.REG_Constraint_Insert WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0600_Object_Code_Library AS lib WITH(NOLOCK)
ON LIB.REG_Code_Content  COLLATE Latin1_General_CS_AS = Constraint_Definition  COLLATE Latin1_General_CS_AS
AND LIB.REG_Code_Base = ''TSQL''
WHERE LIB.REG_0600_ID IS NULL
AND Constraint_Definition IS NOT NULL


INSERT INTO ['+@SourceDBLocation+'].CAT.LNK_0300_0600_Object_Code_Sections (LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0600_ID)

SELECT LNK_T3_ID, REG_0300_Prm_ID, REG_0600_ID
FROM ['+@SourceDBLocation+'].TMP.REG_Constraint_Insert AS tmp WITH(NOLOCK)
JOIN ['+@SourceDBLocation+'].CAT.REG_0600_Object_Code_Library AS reg WITH(NOLOCK)
ON reg.REG_Code_Content COLLATE Latin1_General_CS_AS = Constraint_Definition COLLATE Latin1_General_CS_AS
WHERE LNK_T3_ID IS NOT NULL


INSERT INTO ['+@SourceDBLocation+'].CAT.LNK_0300_0300_Object_Dependencies (LNK_FK_T3P_ID, LNK_FK_0300_Prm_ID, LNK_Latch_Type, LNK_FK_T3R_ID, LNK_FK_0300_Ref_ID, LNK_Rank)

SELECT LNK_FK_T3P_ID, LNK_FK_0300_Prm_ID, REG_Object_Type
, LNK_FK_T3R_ID, LNK_FK_0300_Ref_ID, LNK_Rank
FROM ['+@SourceDBLocation+'].CAT.VI_0361_Code_Object_Reference
'

SET @SQL20 = '

INSERT INTO ['+@SourceDBLocation+'].CAT.REG_0500_Parameter_Registry (REG_Parameter_Name, REG_Parameter_Type)

SELECT DISTINCT Parameter_Name, Parameter_Type
FROM ['+@SourceDBLocation+'].TMP.REG_0500_0501_Insert WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0500_Parameter_Registry AS reg WITH(NOLOCK)
ON REG_Parameter_Name = Parameter_Name
AND REG_Parameter_Type = Parameter_Type
WHERE isnull(Parameter_Name, '''') <> ''''
AND reg.REG_0500_ID IS NULL


INSERT INTO ['+@SourceDBLocation+'].CAT.REG_0501_Parameter_Properties (REG_Size, REG_Scale, Is_Output, Is_cursor_ref, has_Default_Value, Is_XML_document, Is_readonly)

SELECT DISTINCT TMP.size, TMP.scale, TMP.Is_Output, TMP.Is_cursor_ref, TMP.has_Default_Value, TMP.Is_XML_document, TMP.Is_readonly
FROM ['+@SourceDBLocation+'].TMP.REG_0500_0501_Insert AS tmp WITH(NOLOCK)
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0501_Parameter_Properties AS reg WITH(NOLOCK)
ON REG_Size = size
AND REG_Scale = scale
AND reg.Is_Input = TMP.Is_Input
AND reg.Is_Output = TMP.Is_Output
AND reg.Is_cursor_ref = TMP.Is_cursor_ref
AND reg.has_Default_Value = TMP.has_Default_Value
AND reg.Is_XML_document = TMP.Is_XML_document
AND reg.Is_readonly = TMP.Is_readonly
WHERE reg.REG_0501_ID IS NULL


UPDATE t1 SET LNK_T2_ID = t2.LNK_T2_ID
, LNK_T3_ID = t2.LNK_T3_ID
, REG_0300_ID = t2.REG_0300_ID
, REG_0500_ID = reg1.REG_0500_ID
, REG_0501_ID = reg2.REG_0501_ID
FROM ['+@SourceDBLocation+'].TMP.REG_0500_0501_Insert AS t1
LEFT JOIN ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert t2 WITH(NOLOCK)
ON t2.Database_ID = t1.Database_ID
AND t2.Object_ID = t1.Object_ID
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0500_Parameter_Registry AS reg1 WITH(NOLOCK)
ON reg1.REG_Parameter_Name = t1.Parameter_Name COLLATE '+@SourceCollation+'
AND reg1.REG_Parameter_Type = t1.Parameter_Type
LEFT JOIN ['+@SourceDBLocation+'].CAT.REG_0501_Parameter_Properties AS reg2 WITH(NOLOCK)
ON reg2.REG_Size = t1.size
AND reg2.REG_Scale = t1.scale
AND reg2.Is_Input = t1.Is_Input
AND reg2.Is_Output = t1.Is_Output
AND reg2.Is_cursor_ref = t1.Is_cursor_ref
AND reg2.has_Default_Value = t1.has_Default_Value
AND reg2.Is_XML_document = t1.Is_XML_document
AND reg2.Is_readonly = t1.Is_readonly


INSERT INTO ['+@SourceDBLocation+'].CAT.LNK_0300_0500_Object_Parameter_Collection (LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0500_ID, LNK_Rank)

SELECT DISTINCT LNK_T3_ID, REG_0300_ID, REG_0500_ID, rank
FROM ['+@SourceDBLocation+'].TMP.REG_0500_0501_Insert WITH(NOLOCK)


INSERT INTO ['+@SourceDBLocation+'].CAT.LNK_T500_Peers (LNK_FK_T3_ID, LNK_FK_0500_ID, LNK_FK_0501_ID)

SELECT DISTINCT LNK_T3_ID, REG_0500_ID, REG_0501_ID
FROM ['+@SourceDBLocation+'].TMP.REG_0500_0501_Insert WITH(NOLOCK)
'


SET @SQL21 = '
EXEC	CAT.SUB_0203_Database_File_Change_Capture_and_Load
		@SourceDBLocation = N'''+@SourceDBLocation+''',
		@ExecuteStatus = '+CAST(@ExecuteStatus AS NVARCHAR)+'
'


SET @SQL22 = '
EXEC	CAT.SUB_0300_Object_Utilization_Capture_and_Load
		@SourceDBLocation = N'''+@SourceDBLocation+''',
		@ExecuteStatus = '+CAST(@ExecuteStatus AS NVARCHAR)+'
'


IF @ExecuteStatus in (0,1)
BEGIN
	PRINT @SQL1
	PRINT @SQL2
	PRINT @SQL3
	PRINT @SQL4
	PRINT @SQL5
	PRINT @SQL6
	PRINT @SQL7
	PRINT @SQL8
	PRINT @SQL9
	PRINT @SQL10
	PRINT @SQL11
	PRINT @SQL12
	PRINT @SQL13
	PRINT @SQL14
	PRINT @SQL15
	PRINT @SQL16
	PRINT @SQL17
	PRINT @SQL18
	PRINT @SQL19
	PRINT @SQL20
	PRINT @SQL21
	PRINT @SQL22
END


IF @ExecuteStatus in (1,2)
BEGIN
	SET @SQL = CAST(@SQL1 AS nvarchar(MAX))+CAST(@SQL2 AS nvarchar(MAX))+CAST(@SQL3 AS nvarchar(MAX))
	+CAST(@SQL4 AS nvarchar(MAX))+CAST(@SQL5 AS nvarchar(MAX))+CAST(@SQL6 AS nvarchar(MAX))
	+CAST(@SQL7 AS nvarchar(MAX))+CAST(@SQL8 AS nvarchar(MAX))+CAST(@SQL9 AS nvarchar(MAX))
	+CAST(@SQL10 AS nvarchar(MAX))+CAST(@SQL11 AS nvarchar(MAX))+CAST(@SQL12 AS nvarchar(MAX))
	+CAST(@SQL13 AS nvarchar(MAX))+CAST(@SQL14 AS nvarchar(MAX))+CAST(@SQL15 AS nvarchar(MAX))
	+CAST(@SQL16 AS nvarchar(MAX))+CAST(@SQL17 AS nvarchar(MAX))+CAST(@SQL18 AS nvarchar(MAX))
	+CAST(@SQL19 AS nvarchar(MAX))+CAST(@SQL20 AS nvarchar(MAX))+CAST(@SQL21 AS nvarchar(MAX))
	+CAST(@SQL22 AS nvarchar(MAX))
	EXEC sp_executeSQL @SQL
END