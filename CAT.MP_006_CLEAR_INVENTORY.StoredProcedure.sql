USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_006_CLEAR_INVENTORY]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[MP_006_CLEAR_INVENTORY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_006_CLEAR_INVENTORY]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [CAT].[MP_006_CLEAR_INVENTORY]
@ExecuteStatus tinyint = 2
, @SourceDBLocation NVARCHAR(65) = N''DWMgmt''

AS

DECLARE @SQL nvarchar(max)
, @SQL1 nvarchar(4000) = ''''
, @SQL2 nvarchar(4000) = ''''
, @SQL3 nvarchar(4000) = ''''
, @SQL4 nvarchar(4000) = ''''
, @ExecuteSQL nvarchar(500)


/* 20150916:4est 
	ToDo: Replace this with replication DSQL procecdure to replicate missing tables
*/

SET @SQL1 = ''
IF NOT EXISTS (SELECT name FROM ''+@SourceDBLocation+''.sys.tables WHERE name = ''''REG_0203_Insert'''')
CREATE TABLE ''+@SourceDBLocation+''.TMP.REG_0203_Insert (REG_0203_ID INT, Server_ID INT NOT NULL DEFAULT 0, Database_ID INT, size INT, max_Size BIGINT, growth BIGINT
, physical_Name NVARCHAR(256), File_ID INT, type TINYINT, Database_File_Name NVARCHAR(256))

IF NOT EXISTS (SELECT name FROM ''+@SourceDBLocation+''.sys.tables WHERE name = ''''REG_0204_0300_Insert'''')
CREATE TABLE ''+@SourceDBLocation+''.TMP.REG_0204_0300_Insert (LNK_T2_ID INT, LNK_T3_ID INT, REG_0204_ID INT, REG_0300_ID INT, Server_ID INT, Database_ID INT, Schema_ID INT
, Schema_Name NVARCHAR(256), Object_ID INT, Sub_Object_Rank INT NOT NULL DEFAULT 0, Object_Name NVARCHAR(256), Object_Type NVARCHAR(25), Create_Date DATETIME)

IF NOT EXISTS (SELECT name FROM ''+@SourceDBLocation+''.sys.tables WHERE name = ''''REG_Index_Insert'''')
CREATE TABLE ''+@SourceDBLocation+''.TMP.REG_Index_Insert (LNK_T2_ID INT, LNK_T3_ID INT, LNK_T4_ID INT, REG_0204_ID INT, REG_0300_Ref_ID INT, REG_0300_Prm_ID INT, REG_0301_ID INT, REG_0400_ID INT
, REG_0402_ID INT, Server_ID INT NOT NULL DEFAULT 0, Database_ID INT, Schema_ID INT, Parent_Object_ID INT, Parent_Object_Name NVARCHAR(256), Parent_Object_Type nvarchar(5)
, Index_Name NVARCHAR(256), Index_Type VARCHAR(2), Index_Rank INT, Is_Unique BIT, data_space_ID INT, Ignore_Dup_Key BIT, Is_Primary_Key BIT, Is_Unique_Constraint BIT
, Fill_Factor INT, Is_padded BIT, Is_Disabled BIT, Is_hypothetical BIT, Allow_Row_Locks BIT, Allow_Page_Locks BIT, Parent_Column_Name NVARCHAR(256), Parent_Column_Type INT
, Index_Column_ID INT, Column_ID INT, Is_Descending_Key BIT, Is_Included_Column BIT, Key_ordinal SMALLINT, Partition_Ordinal SMALLINT)

IF NOT EXISTS (SELECT name FROM ''+@SourceDBLocation+''.sys.tables WHERE name = ''''REG_Foreign_Key_Insert'''')
CREATE TABLE ''+@SourceDBLocation+''.TMP.REG_Foreign_Key_Insert (LNK_T2_ID int NOT NULL, LNK_T3_ID int NOT NULL, LNK_T4_ID int NOT NULL, REG_0204_ID int NOT NULL, REG_0300_Prm_ID int NOT NULL
, REG_0300_Ref_ID int NOT NULL, REG_0302_ID int NOT NULL, REG_0400_ID int NOT NULL, REG_0403_ID int NOT NULL, Server_ID smallint NOT NULL DEFAULT 0
, Database_ID smallint NULL, Schema_ID int NOT NULL, Key_Object_ID int NOT NULL, Sub_Object_Rank bigint NULL, Key_Name nvarchar(225) NOT NULL
, Key_Type nvarchar(30) NULL, Key_Column_ID int NOT NULL, Referenced_Object_Name nvarchar(225) NOT NULL, Referenced_Object_ID int NOT NULL
, Referenced_Column_Name nvarchar(225) NOT NULL, Referenced_Column_Type int NOT NULL, Referenced_Column_ID int NOT NULL, Create_Date datetime NOT NULL
, Is_ms_shipped bit NOT NULL, Is_Published bit NOT NULL, Is_Schema_Published bit NOT NULL, Key_Index_ID int NULL, Is_Disabled bit NOT NULL
, Is_not_for_replication bit NOT NULL, Is_not_trusted bit NOT NULL, delete_referential_action tinyint NULL, delete_referential_action_Desc nvarchar(60) NULL
, update_referential_action tinyint NULL, update_referential_action_Desc nvarchar(60) NULL, Is_System_Named bit NOT NULL)

IF NOT EXISTS (SELECT name FROM ''+@SourceDBLocation+''.sys.tables WHERE name = ''''REG_Constraint_Insert'''')
CREATE TABLE ''+@SourceDBLocation+''.TMP.REG_Constraint_Insert (LNK_T2_ID INT, LNK_T3_ID INT, LNK_T4_ID INT, REG_0204_ID INT, REG_0300_Ref_ID INT, REG_0300_Prm_ID INT, REG_0302_ID INT, REG_0400_ID INT
, Server_ID INT NOT NULL DEFAULT 0, Database_ID INT, Schema_ID INT, Schema_Name NVARCHAR(256), Parent_Object_ID INT, Parent_Object_Name NVARCHAR(256), Parent_Object_Type nvarchar(5)
, Parent_Column_Name NVARCHAR(256), Parent_Column_Type INT, Parent_Column_ID INT, Constraint_Object_ID INT, Constraint_Name NVARCHAR(256), Constraint_Type VARCHAR(2)
, Code_Hash VARBINARY(20), Constraint_Definition NVARCHAR(4000), Is_ms_shipped BIT, Is_Published BIT, Is_Schema_Published BIT, Is_System_Named BIT)
''

SET @SQL2 = ''
IF NOT EXISTS (SELECT name FROM ''+@SourceDBLocation+''.sys.tables WHERE name = ''''REG_Trigger_Insert'''')
CREATE TABLE ''+@SourceDBLocation+''.TMP.REG_Trigger_Insert (LNK_T2_ID INT DEFAULT 0, LNK_T3_ID INT DEFAULT 0, REG_0204_ID INT DEFAULT 0, REG_0300_Prm_ID INT DEFAULT 0
, REG_0300_Ref_ID INT DEFAULT 0, Server_ID INT DEFAULT 0, Database_ID INT, Schema_ID INT, Schema_Name NVARCHAR(256), Parent_Object_ID INT, Parent_Object_Name NVARCHAR(256), Sub_Object_Rank TINYINT
, Trigger_Object_ID INT, Trigger_Name NVARCHAR(256), Trigger_Type NVARCHAR(65), Is_ms_shipped BIT, Is_Disabled BIT, Is_not_for_replication BIT
, Is_instead_of_trigger BIT, Create_Date DATETIME)
 
IF NOT EXISTS (SELECT name FROM ''+@SourceDBLocation+''.sys.tables WHERE name = ''''REG_0300_0401_Insert'''')
CREATE TABLE ''+@SourceDBLocation+''.TMP.REG_0300_0401_Insert (LNK_T2_ID INT, LNK_T3_ID INT, LNK_T4_ID INT, REG_0300_ID INT, REG_0400_ID INT
, REG_0401_ID INT, Server_ID INT NOT NULL DEFAULT 0, Database_ID INT, Schema_ID int, Object_ID INT, Object_Type NVARCHAR(15)
, Column_Name NVARCHAR(256), Column_Type VARCHAR(3), Column_Rank INT, Is_Identity BIT, Is_Nullable BIT
, Is_Default_Collation BIT, Is_Primary_Key BIT, Column_Size INT, Column_Scale INT)

IF NOT EXISTS (SELECT name FROM ''+@SourceDBLocation+''.sys.tables WHERE name = ''''REG_0500_0501_Insert'''')
CREATE TABLE ''+@SourceDBLocation+''.TMP.REG_0500_0501_Insert (LNK_T2_ID INT, LNK_T3_ID INT, REG_0300_ID INT, REG_0500_ID INT, REG_0501_ID INT
, Server_ID INT NOT NULL DEFAULT 0, Database_ID INT, Object_ID INT, Parameter_Name NVARCHAR(256), Parameter_Type INT
, rank INT, size INT, scale INT, Is_Input BIT, Is_Output BIT, Is_cursor_ref BIT, has_Default_Value BIT, Is_xml_document BIT
, Is_readonly BIT, default_Value NVARCHAR(max), xml_collection_ID INT)

IF NOT EXISTS (SELECT name FROM ''+@SourceDBLocation+''.sys.tables WHERE name = ''''REG_0600_Insert'''')
CREATE TABLE ''+@SourceDBLocation+''.TMP.REG_0600_Insert (LNK_T3_ID INT, REG_0300_ID INT, REG_0600_ID INT, Server_ID INT NOT NULL DEFAULT 0, Database_ID INT, Schema_ID INT
, Schema_Name NVARCHAR(256), Object_ID INT, Object_Name NVARCHAR(256), Object_Type NVARCHAR(65), Type_Desc NVARCHAR(256), Code_Hash VARBINARY(20), definition NVARCHAR(max)
, uses_ANSI_nulls BIT, uses_quoted_Identifier BIT, uses_Database_Collation BIT, Is_Schema_bound BIT, Is_recompiled BIT, null_on_null_Input BIT, execute_as_principal_ID BIT
, Create_Date DATETIME)

IF NOT EXISTS (SELECT name FROM ''+@SourceDBLocation+''.sys.tables WHERE name = ''''REG_0101_Insert'''')
CREATE TABLE ''+@SourceDBLocation+''.TMP.REG_0101_Insert (REG_0101_ID INT NOT NULL, Server_ID INT NOT NULL, Is_linked BIT NOT NULL, Is_remote_login_enabled BIT NOT NULL
, Is_rpc_out_enabled BIT NOT NULL, Is_data_access_enabled BIT NOT NULL, Is_Collation_compatible BIT NOT NULL, uses_remote_Collation BIT NOT NULL
, collation_Name SYSNAME NULL, connect_timeout INT NULL, query_timeout INT NULL, Is_System BIT NOT NULL, Is_remote_proc_transaction_promotion_enabled BIT NULL)

IF NOT EXISTS (SELECT name FROM ''+@SourceDBLocation+''.sys.tables WHERE name = ''''REG_0102_Insert'''')
CREATE TABLE ''+@SourceDBLocation+''.TMP.REG_0102_Insert (REG_0102_ID INT NOT NULL, Server_ID INT NOT NULL, lazy_Schema_validation BIT NOT NULL
, Is_publisher BIT NOT NULL, Is_subscriber BIT NULL, Is_distributor BIT NULL, Is_nonsql_subscriber BIT NULL)

IF NOT EXISTS (SELECT name FROM ''+@SourceDBLocation+''.sys.tables WHERE name = ''''REG_0103_Insert'''')
CREATE TABLE ''+@SourceDBLocation+''.TMP.REG_0103_Insert (REG_0103_ID INT NOT NULL, Server_ID INT NOT NULL, provider SYSNAME NOT NULL, data_source NVARCHAR(256) NULL, provider_string NVARCHAR(256) NULL, catalog SYSNAME NULL)
''

SET @SQL3 = ''
IF NOT EXISTS (SELECT name FROM ''+@SourceDBLocation+''.sys.tables WHERE name = ''''REG_0100_0200_Insert'''')
CREATE TABLE ''+@SourceDBLocation+''.TMP.REG_0100_0200_Insert (LNK_T2_ID INT NOT NULL, REG_0100_ID INT NOT NULL, REG_0200_ID INT NOT NULL, Server_ID INT NOT NULL
, Server_Name SYSNAME NOT NULL, product SYSNAME NOT NULL, Database_ID INT NULL, Database_Name SYSNAME NULL, compatibility_level TINYINT NULL
, collation_Name SYSNAME NULL, recovery_model_Desc NVARCHAR(65) NULL, Create_Date DATETIME NOT NULL)

IF NOT EXISTS (SELECT name FROM ''+@SourceDBLocation+''.sys.tables WHERE name = ''''REG_0201_Insert'''')
CREATE TABLE ''+@SourceDBLocation+''.TMP.REG_0201_Insert (REG_0201_ID INT NOT NULL, Server_ID INT NOT NULL, Database_ID INT NOT NULL, page_verify_option tinyINT NULL
, Is_Auto_close_on BIT NOT NULL, Is_Auto_shrink_on BIT NULL, Is_supplemental_logging_enabled BIT NULL, Is_read_committed_snapshot_on BIT NULL
, Is_Auto_Create_stats_on BIT NULL,	Is_Auto_update_stats_on BIT NULL, Is_Auto_update_stats_async_on BIT NULL, Is_ANSI_null_Default_on BIT NULL
, Is_ANSI_nulls_on BIT NULL, Is_ANSI_padding_on BIT NULL, Is_ANSI_warnings_on BIT NULL, Is_arithabort_on BIT NULL, Is_concat_null_yields_null_on BIT NULL
, Is_numeric_roundabort_on BIT NULL, Is_quoted_Identifier_on BIT NULL)

IF NOT EXISTS (SELECT name FROM ''+@SourceDBLocation+''.sys.tables WHERE name = ''''REG_0202_Insert'''')
CREATE TABLE ''+@SourceDBLocation+''.TMP.REG_0202_Insert(REG_0202_ID INT NOT NULL, Server_ID INT NOT NULL, Database_ID INT NOT NULL, Is_recursive_triggers_on BIT NULL
, Is_cursor_close_on_commit_on BIT NULL, Is_local_cursor_Default BIT NULL, Is_fulltext_enabled BIT NULL, Is_trustworthy_on BIT NULL
, Is_db_chaining_on BIT NULL, Is_parameterization_forced BIT NULL, Is_master_Key_encrypted_by_server BIT NOT NULL, Is_Published BIT NOT NULL
, Is_subscribed BIT NOT NULL, Is_merge_Published BIT NOT NULL, Is_distributor BIT NOT NULL, Is_sync_with_backup BIT NOT NULL
, Is_broker_enabled BIT NOT NULL, Is_Date_correlation_on BIT NOT NULL)

IF NOT EXISTS (SELECT name FROM ''+@SourceDBLocation+''.sys.tables WHERE name = ''''REG_0300_0300_Insert'''')
CREATE TABLE ''+@SourceDBLocation+''.TMP.REG_0300_0300_Insert(LNK_T3P_ID INT NULL, LNK_T3R_ID INT NULL, LNK_Latch_Type NVARCHAR(65) NULL, 
LNK_0300_Prm_ID INT NULL, LNK_0300_Ref_ID INT NULL, LNK_Schema_Bound_Object NVARCHAR(256) NULL, LNK_Rank INT NULL
, Ref_Schema_Name NVARCHAR(65) NULL, Ref_Object_Name NVARCHAR(65) NULL, Ref_Object_ID INT NULL, Ref_Caller_Dependent BIT NULL)
''

/* 20150916:4est 
	ToDo: Use a mechanism to auto-magically clear these out after use by process,
	or as regular scheduled maintenance trigger, job, or proc-call.
*/

SET @SQL4 = ''
/* Truncate all tables in preparation for load */
TRUNCATE TABLE TMP.REG_0100_0200_Insert
TRUNCATE TABLE TMP.REG_0101_Insert
TRUNCATE TABLE TMP.REG_0102_Insert
TRUNCATE TABLE TMP.REG_0103_Insert
TRUNCATE TABLE TMP.REG_0201_Insert
TRUNCATE TABLE TMP.REG_0202_Insert
TRUNCATE TABLE TMP.REG_0203_Insert
TRUNCATE TABLE TMP.REG_0204_0300_Insert
TRUNCATE TABLE TMP.REG_0300_0300_Insert
TRUNCATE TABLE TMP.REG_0300_0401_Insert
TRUNCATE TABLE TMP.REG_0500_0501_Insert
TRUNCATE TABLE TMP.REG_0600_Insert
TRUNCATE TABLE TMP.REG_Index_Insert
TRUNCATE TABLE TMP.REG_Constraint_Insert
TRUNCATE TABLE TMP.REG_Foreign_Key_Insert
TRUNCATE TABLE TMP.REG_Trigger_Insert
TRUNCATE TABLE TMP.Database_Latch_Insert
TRUNCATE TABLE TMP.Object_Latch_Insert
TRUNCATE TABLE TMP.Column_Latch_Insert
TRUNCATE TABLE TMP.TRK_0300_Utiliztion_Insert
''


IF @ExecuteStatus in (0,1)
BEGIN
	PRINT @SQl1
	PRINT @SQL2
	PRINT @SQL3
	PRINT @SQL4
END


IF @ExecuteStatus in (1,2)
BEGIN
	SET @SQL = cast(@SQL1 as nvarchar(max))+cast(@SQL2 as nvarchar(max))+cast(@SQL3 as nvarchar(max))
	+CAST(@SQL4 as nvarchar(max))
	EXEC sp_executeSQL @SQL
END
' 
END
GO
