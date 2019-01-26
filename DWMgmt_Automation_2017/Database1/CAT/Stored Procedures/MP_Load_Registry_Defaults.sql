

CREATE PROCEDURE [CAT].[MP_Load_Registry_Defaults]
AS

/* Create default hooks for system databases and base schemas 
	- additional database features and links will be created when the first system scan is run. */

SET IDENTITY_INSERT CAT.REG_0100_Server_Registry ON

INSERT INTO CAT.REG_0100_Server_Registry (REG_0100_ID, REG_Server_Name, REG_Product, REG_Monitored)

SELECT -2, 'File System', 'Unknown', 0
UNION
SELECT -1, 'Foreign Servers', 'Unknown', 0
UNION
SELECT DISTINCT Server_ID+1, name, product, 1
FROM sys.servers
ORDER BY 1

SET IDENTITY_INSERT CAT.REG_0100_Server_Registry OFF



SET IDENTITY_INSERT CAT.REG_0103_Server_Providers ON

INSERT INTO CAT.REG_0103_Server_Providers (REG_0103_ID, REG_Provider, REG_Data_Source, REG_Provider_String, REG_Catalog)

SELECT 0, 'Unknown', 'Unknown', '', ''

SET IDENTITY_INSERT CAT.REG_0103_Server_Providers OFF


/* This piece is WIP - Working on the concept of integrating non-SQL objects into the catalog
	via attribution to  */
SET IDENTITY_INSERT CAT.REG_0200_Database_Registry ON

INSERT INTO CAT.REG_0200_Database_Registry (REG_0200_ID, REG_Database_Name, REG_Collation, REG_Compatibility, REG_Recovery_Model)

SELECT -2, 'Non-Database Entities', 'None', 0, 'NONE'
UNION
SELECT -1, 'Foreign Databases', 'Database_Default', 0, 'UNKNOWN'
UNION
SELECT Database_ID, name, collation_Name, compatibility_level, recovery_model_Desc
FROM sys.databases 
WHERE name in ('tempdb','master','msdb','model')

SET IDENTITY_INSERT CAT.REG_0200_Database_Registry OFF


SET IDENTITY_INSERT CAT.REG_0204_Database_Schemas ON

INSERT INTO CAT.REG_0204_Database_Schemas (REG_0204_ID, REG_Schema_Name)
SELECT Schema_ID, name
FROM sys.schemas
WHERE Schema_ID < 5
UNION
SELECT -1, 'AdHoc'

SET IDENTITY_INSERT CAT.REG_0204_Database_Schemas OFF


/* Schemas and objects recorded under TempDb must be immutable and cannot term by abscence.
	TempDb must be specifically inserted as special case (-1 status) link
	
	Objects not stored with in the context of a database need a Server/Database structure
	default to attach to: In this case Foreign Server/Non-Database Entities. They must be
	similarly immutable to TempDb objects.
	
	These can include things like SSIS Packages, SSRS Reports, BCP Executables, Powershell routes, etc.
	Subjective catalogging (LIB schema) manages their organization.
*/
	
SET IDENTITY_INSERT CAT.LNK_0100_0200_Server_Databases ON

ALTER TABLE CAT.LNK_0100_0200_Server_Databases DISABLE TRIGGER ALL

INSERT INTO CAT.LNK_0100_0200_Server_Databases (LNK_T2_ID, LNK_FK_0100_ID, LNK_FK_0200_ID, LNK_db_Rank, LNK_Term_Date)

SELECT -2, -1, -2, 0, CAST(-1 AS DATETIME)
UNION
SELECT -1, REG_0100_ID, REG_0200_ID, Database_ID, CAST(-1 AS DATETIME)
FROM sys.databases AS db
JOIN CAT.REG_0200_Database_Registry AS rdr
ON rdr.REG_Database_Name = db.name
CROSS APPLY  CAT.REG_0100_Server_Registry AS rsr
WHERE rsr.REG_Server_Name = @@SERVERNAME
AND db.name in ('tempdb')

DBCC CHECKIDENT('CAT.LNK_0100_0200_Server_Databases', RESEED, 1)

SET IDENTITY_INSERT CAT.LNK_0100_0200_Server_Databases OFF

ALTER TABLE CAT.LNK_0100_0200_Server_Databases ENABLE TRIGGER ALL


/* All other pre-recorded databases on the host server can be loaded normally, and should start with T2_ID = 1 */
ALTER TABLE CAT.LNK_0100_0200_Server_Databases DISABLE TRIGGER ALL

INSERT INTO CAT.LNK_0100_0200_Server_Databases (LNK_FK_0100_ID, LNK_FK_0200_ID, LNK_db_Rank, LNK_Term_Date)
SELECT REG_0100_ID, REG_0200_ID, Database_ID, '12/31/2099'
FROM sys.databases AS db
JOIN CAT.REG_0200_Database_Registry AS rdr
ON rdr.REG_Database_Name = db.name
CROSS APPLY  CAT.REG_0100_Server_Registry AS rsr
WHERE rsr.REG_Server_Name = @@SERVERNAME
AND db.name in ('master','msdb','model')

ALTER TABLE CAT.LNK_0100_0200_Server_Databases ENABLE TRIGGER ALL


/* Insert sample of database backup root. System queries will use this to create unique entries per database. */

SET IDENTITY_INSERT [DWMgmt].[CAT].[REG_0203_Database_files] ON 

INSERT INTO [DWMgmt].[CAT].[REG_0203_Database_files] ([REG_0203_ID],[REG_File_ID],[REG_File_Type]
,[REG_File_Name],[REG_File_Location],[REG_File_Max_Size],[REG_File_Growth],[REG_Create_Date])

SELECT -1, -1, 3, '[@TargetDBName]', 'E:\Program Files\Microsoft SQL Server\MSSQL11.[@SimpleServerName]\MSSQL\Backup\[@TargetDBName].bak', -1, 0, '1/1/1900'

SET IDENTITY_INSERT [DWMgmt].[CAT].[REG_0203_Database_files] OFF


/* Tier 3 includes indexes and keys which are mutable but dependent ON registered objects */

SET IDENTITY_INSERT CAT.REG_0301_Index_Details ON

INSERT INTO CAT.REG_0301_Index_Details (REG_0301_ID, data_space_ID, Fill_Factor, Is_Unique, Ignore_Dup_Key, Is_Primary_Key, Is_Unique_Constraint, Is_padded, Is_Disabled, Is_hypothetical, Allow_Row_Locks, Allow_Page_Locks, REG_Create_Date)
SELECT 0,0,0,0,0,0,0,0,0,0,0,0,'1/1/1900'

SET IDENTITY_INSERT CAT.REG_0301_Index_Details OFF


SET IDENTITY_INSERT CAT.REG_0302_Foreign_Key_Details ON

INSERT INTO CAT.REG_0302_Foreign_Key_Details (REG_0302_ID, Is_ms_shipped, Is_hypothetical, Is_Published, Is_Schema_Published, Is_Disabled, Is_not_trusted, Is_not_for_replicatiON, Is_System_Named, delete_referential_actiON, update_referential_actiON, Key_Index_ID, principal_ID, REG_Create_Date)
SELECT 0,0,0,0,0,0,0,0,0,0,0,0,0,'1/1/1900'

SET IDENTITY_INSERT CAT.REG_0302_Foreign_Key_Details OFF


/* Tier 4 includes only indexes which have special column specific and mutable column features. */

SET IDENTITY_INSERT CAT.REG_0402_Column_Index_Details ON

INSERT INTO CAT.REG_0402_Column_Index_Details (REG_0402_ID, Index_Column_ID, Partition_Ordinal, Is_Descending_Key, Is_Included_Column, REG_Create_Date)
SELECT 0,0,0,0,0,'1/1/1900'

SET IDENTITY_INSERT CAT.REG_0402_Column_Index_Details OFF


/* Insert REG_0205_Database_Maintenance_Properties defaults
	This allows automated processing and management of maintenance jobs
	such as backup functionality, index grooming, data profiling, and archiving.

	The template query code is to be replaced with a reference to a code link set,
	eventually eliminating the need for any DSQL.
*/

SET IDENTITY_INSERT [CAT].[REG_0205_Database_Maintenance_Properties] ON 

INSERT [CAT].[REG_0205_Database_Maintenance_Properties] ([REG_0205_ID], [REG_Task_Type], [REG_Task_Name], [REG_Task_Proc], [REG_Task_Desc], [REG_Create_Date], [REG_Exec_Template]) 
SELECT 7, N'Maintenance', N'Database Backup Driver', N'CAT.MP_007_DATABASE_BACKUP_DRIVER', N'Prepares a database for backup according to a list of tasks presented by various task assessor queries, and performs a backup to file.', CAST(0x0000A73401166E31 AS DateTime), N'EXEC [DWMgmt].[CAT].[SUB_1207_Database_Backup_Executor]
@TargetDBLocation = ''+@TargetDBLocation+''
, @BackupPath = ''+@BackupPath+''
, @BackupOption = ''+@BackupOption+''
, @ExecuteStatus = 2'
UNION
SELECT 9, N'Maintenance', N'Database Backup Executor - Differential', N'SUB_1207_Database_Backup_Executor', N'Executes a Differential backup on the database', CAST(0x0000A7350185306D AS DateTime), N'EXEC [DWMgmt].[CAT].[SUB_1207_Database_Backup_Executor]
@TargetDBLocation = ''''''+@TargetDBLocation+''''''
, @BackupPath = ''''''+@BackupPath+''''''
, @BackupOption = ''''DIFFERENTIAL''''
, @ExecuteStatus = 2'
UNION
SELECT 13, N'Maintenance', N'Database Backup Executor - Full', N'SUB_1207_Database_Backup_Executor', N'Executes a full backup on the database', CAST(0x0000A7360000AF6E AS DateTime), N'EXEC [DWMgmt].[CAT].[SUB_1207_Database_Backup_Executor]
@TargetDBLocation = ''''''+@TargetDBLocation+''''''
, @BackupPath = ''''''+@BackupPath+''''''
, @ExecuteStatus = 2'
UNION
SELECT 6, N'Maintenance', N'Database Cleanup', N'CAT.MP_006_CLEAR_INVENTORY', N'Fully truncates all TMP tables id DWMgmt in preparation for a full environment scan.', CAST(0x0000A73401166E31 AS DateTime), NULL
UNION
SELECT 17, N'Maintenance', N'Index Maintenance - Light Weight', N'CAT.MP_008_INDEX_MAINTENANCE_DRIVER', N'Executes MP_008_INDEX_MAINTENANCE_DRIVER against the top 25 most fragmented indexes each cycle - moe selective scheduling to follow Prefers online reorganization to offline rebuilds when appropriate.', CAST(0x0000A7360106F046 AS DateTime), N'EXEC [CAT].[MP_008_INDEX_MAINTENANCE_DRIVER]
@ExecuteStatus = 2
, @ModeId = 1'
UNION
SELECT 19, N'Maintenance', N'Index Maintenance - Maintenance Scheduling', N'CAT.MP_008_INDEX_MAINTENANCE_DRIVER', N'Executes MP_008_INDEX_MAINTENANCE_DRIVER in scheduling mode to detect and log instances of rebuilds for later execution.', CAST(0x0000A7360106F046 AS DateTime), N'EXEC [CAT].[MP_008_INDEX_MAINTENANCE_DRIVER]
@ExecuteStatus = 2
, @ModeId = 0'
UNION
SELECT 18, N'Maintenance', N'Index Maintenance - Scheduled Rebuild', N'CAT.MP_008_INDEX_MAINTENANCE_DRIVER', N'Executes MP_008_INDEX_MAINTENANCE_DRIVER against indexed tables scheduled for intensive off-line rebuilds.', CAST(0x0000A7360106F046 AS DateTime), N'EXEC [CAT].[MP_008_INDEX_MAINTENANCE_DRIVER]
@ExecuteStatus = 2
, @ModeId = 2'
UNION
SELECT -1, N'None', N'Exclusion', N'', N'No automated catalogging or maintenance will be performed on this server or database', CAST(0x0000A73401166E31 AS DateTime), NULL
UNION
SELECT 3, N'Registry', N'Central Registry Process', N'CAT.MP_003_CENTRAL_REGISTRY_PROCESS', N'Register all aggregate meta-data and tracking results into registry fact and dimensions', CAST(0x0000A73401166E31 AS DateTime), N'EXEC [DWMgmt].[CAT].[MP_003_CENTRAL_REGISTRY_PROCESS]
@SourceDBLocation = ''''''+@SourceDBLocation+''''''
, @ExecuteStatus = 2'
UNION
SELECT 2, N'Scan', N'Database Census', N'CAT.MP_002_DATABASE_CENSUS', N'Collect information about servers from sys.[object] tables', CAST(0x0000A73401166E31 AS DateTime), N'EXEC [DWMgmt].[CAT].[MP_002_DATABASE_CENSUS]
@TargetDBLocation = ''''''+@TargetDBLocation+''''''
, @SourceCollation = ''''''+@SourceCollation+''''''
, @ExecuteStatus = 2'
UNION
SELECT 16, N'Scan', N'Database File Change Capture', N'CAT.SUB_1203_Database_File_Change_Capture_and_Load', N'Pulls schema summary, and file size info after a database census', CAST(0x0000A7360012B7EE AS DateTime), N'EXEC [CAT].[SUB_1203_Database_File_Change_Capture_and_Load]
@TargetDBLocation = ''''''+@TargetDBLocation+'''''''
UNION
SELECT 0, N'Scan', N'Full Server Scan', N'CAT.MP_000_FULL_SERVER_SCAN', N'Runs MP_001_SERVER_CENSUS, and MP_002_DATABASE_CENSUS against the host server, any accessible linked servers, and all accessible databases. Runs MP_003_CENTRAL_REGISTRY_PROCESS, the success of which validates integrity fo the SQL based core', CAST(0x0000A73401166E31 AS DateTime), N'EXEC [DWMgmt].[CAT].[MP_000_FULL_SERVER_SCAN]
@SourceServer = ''''''+@SourceServerName+''''''
, @ExecuteStatus = 2
, @TrackingStatus = 0
, @SystemStatus = 1'
UNION
SELECT 5, N'Scan', N'Object Metric Capture', N'CAT.MP_005_OBJECT_METRIC_CAPTURE_DRIVER', N'Executes SUB_1350_Index_Metric_Capture_and_Load and SUB_1354_Index_Data_Profile_Capture', CAST(0x0000A73401166E31 AS DateTime), NULL
UNION
SELECT 4, N'Scan', N'Schema Metric Capture Driver', N'CAT.MP_004_SCHEMA_METRIC_CAPTURE_DRIVER', N'Collect information about database size and activity', CAST(0x0000A73401166E31 AS DateTime), NULL
UNION
SELECT 1, N'Scan', N'Server Census non SYS', N'CAT.MP_001_SERVER_CENSUS', N'Executes MP_0100_SERVER_CENSUS on the specified target server/database with collation specified by user, and scanning of system sources off.', CAST(0x0000A73401166E31 AS DateTime), N'EXEC [DWMgmt].[CAT].[MP_001_SERVER_CENSUS]
@TargetDBLocation = ''''''+@TargetDBLocation+''''''
, @SourceCollation = ''''''+@SourceCollation+''''''
, @ExecuteStatus = 2
, @SystemStatus = 0'
UNION
SELECT 10, N'Scan', N'Server Census SYS', N'CAT.MP_001_SERVER_CENSUS', N'Executes MP_0100_SERVER_CENSUS on the specified target server/database with collation specified by user, and scanning of system sources ON. Reserve for occasional updates/cleanup', CAST(0x0000A735018B59CF AS DateTime), N'EXEC [DWMgmt].[CAT].[MP_001_SERVER_CENSUS]
@TargetDBLocation = ''''''+@TargetDBLocation+''''''
, @SourceCollation = ''''''+@SourceCollation+''''''
, @ExecuteStatus = 2
, @SystemStatus = 1'

SET IDENTITY_INSERT [CAT].[REG_0205_Database_Maintenance_Properties] OFF