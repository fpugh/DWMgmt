USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_Load_Registry_Defaults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[MP_Load_Registry_Defaults]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_Load_Registry_Defaults]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [CAT].[MP_Load_Registry_Defaults]
AS

/* Create default hooks for system databases and base schemas 
	- additiONal database features and links will be created when the first system scan is run. */

SET IDENTITY_Insert CAT.REG_0100_Server_Registry ON

INSERT INTO CAT.REG_0100_Server_Registry (REG_0100_ID, REG_Server_Name, REG_Product, REG_Monitored)

SELECT -2, ''File System'', ''Unknown'', 0
UNION
SELECT -1, ''Foreign Servers'', ''Unknown'', 0
UNION
SELECT DISTINCT Server_ID+1, name, product, 1
FROM sys.servers
ORDER BY 1

SET IDENTITY_Insert CAT.REG_0100_Server_Registry OFF



/* This piece is WIP - Working on the concept of integrating non-SQL objects into the catalog
	via attribution to  */
SET IDENTITY_Insert CAT.REG_0200_Database_Registry ON

INSERT INTO CAT.REG_0200_Database_Registry (REG_0200_ID, REG_Database_Name, REG_Collation, REG_Compatibility, REG_Recovery_Model)

SELECT -2, ''Non-Database Entities'', ''None'', 0, ''NONE''
UNION
SELECT -1, ''Foreign Databases'', ''Database_Default'', 0, ''UNKNOWN''
UNION
SELECT Database_ID, name, collation_Name, compatibility_level, recovery_model_Desc
FROM sys.databases 
WHERE name in (''tempdb'',''master'',''msdb'',''model'')

SET IDENTITY_Insert CAT.REG_0200_Database_Registry OFF


SET IDENTITY_Insert CAT.REG_0204_Database_Schemas ON

INSERT INTO CAT.REG_0204_Database_Schemas (REG_0204_ID, REG_Schema_Name)
SELECT Schema_ID, name
FROM sys.schemas
WHERE Schema_ID < 5
UNION
SELECT -1, ''AdHoc''

SET IDENTITY_Insert CAT.REG_0204_Database_Schemas OFF


/* Tier 2 has only 1 "optional" setting - maintenance has no current manditory tasks */
SET IDENTITY_Insert CAT.REG_0205_Database_Maintenance_Properties ON

INSERT INTO CAT.REG_0205_Database_Maintenance_Properties (REG_0205_ID, REG_Task_Type, REG_Task_Name, REG_Task_Proc, REG_Task_Desc)
SELECT 0, ''None'', ''Exclusion'', '''', ''No automated catalogging or maintenance will be performed on this server or database''
UNION
SELECT 1, ''Scan'', ''Server Census'', ''CAT.MP_001_SERVER_CENSUS'', ''Collect information about servers from sys.server tables''
UNION
SELECT 2, ''Scan'', ''Database Census'', ''CAT.MP_002_DATABASE_CENSUS'', ''Collect information about servers from sys.[object] tables''
UNION
SELECT 3, ''Registry'', ''Central Registry Process'', ''CAT.MP_003_CENTRAL_REGISTRY_PROCESS'', ''Register all aggregate meta-data and tracking results into registry fact and dimensions''
UNION
SELECT 4, ''Scan'', ''Database Census'', ''CAT.MP_004_GLOBAL_METRIC_CAPTURE_DRIVER'', ''Collect information about database size and activity''
UNION
SELECT 5, ''Scan'', ''Object Metric Capture'', ''CAT.MP_005_OBJECT_METRIC_CAPTURE_DRIVER'', ''Collect content summaries and statistics from specified tables for data quality analysis, and realational modeling''

SET IDENTITY_Insert CAT.REG_0205_Database_Maintenance_Properties OFF


/* Schemas and objects recorded under TempDb must be immutable and cannot term by abscence.
	TempDb must be specifically inserted as special case (-1 status) link
	
	Objects not stored with in the context of a database need a Server/Database structure
	default to attach to: In this case Foreign Server/Non-Database Entities. They must be
	similarly immutable to TempDb objects.
	
	These can include things like SSIS Packages, SSRS Reports, BCP Executables, Powershell routes, etc.
	Subjective catalogging (LIB schema) manages their organization.
*/
	
SET IDENTITY_Insert CAT.LNK_0100_0200_Server_Databases ON

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
AND db.name in (''tempdb'')

DBCC CHECKIDENT(''CAT.LNK_0100_0200_Server_Databases'', RESEED, 1)

SET IDENTITY_Insert CAT.LNK_0100_0200_Server_Databases OFF

ALTER TABLE CAT.LNK_0100_0200_Server_Databases ENABLE TRIGGER ALL


/* All other pre-recorded databases on the host server can be loaded normally, and should start with T2_ID = 1 */
ALTER TABLE CAT.LNK_0100_0200_Server_Databases DISABLE TRIGGER ALL

INSERT INTO CAT.LNK_0100_0200_Server_Databases (LNK_FK_0100_ID, LNK_FK_0200_ID, LNK_db_Rank, LNK_Term_Date)
SELECT REG_0100_ID, REG_0200_ID, Database_ID, ''12/31/2099''
FROM sys.databases AS db
JOIN CAT.REG_0200_Database_Registry AS rdr
ON rdr.REG_Database_Name = db.name
CROSS APPLY  CAT.REG_0100_Server_Registry AS rsr
WHERE rsr.REG_Server_Name = @@SERVERNAME
AND db.name in (''master'',''msdb'',''model'')

ALTER TABLE CAT.LNK_0100_0200_Server_Databases ENABLE TRIGGER ALL


/* Tier 3 includes indexes and keys which are mutable but dependent ON registered objects */
SET IDENTITY_Insert CAT.REG_0301_Index_Details ON

INSERT INTO CAT.REG_0301_Index_Details (REG_0301_ID, data_space_ID, Fill_Factor, Is_Unique, Ignore_Dup_Key, Is_Primary_Key, Is_Unique_Constraint, Is_padded, Is_Disabled, Is_hypothetical, Allow_Row_Locks, Allow_Page_Locks, REG_Create_Date)
SELECT 0,0,0,0,0,0,0,0,0,0,0,0,''1/1/1900''

SET IDENTITY_Insert CAT.REG_0301_Index_Details OFF


SET IDENTITY_Insert CAT.REG_0302_Foreign_Key_Details ON

INSERT INTO CAT.REG_0302_Foreign_Key_Details (REG_0302_ID, Is_ms_shipped, Is_hypothetical, Is_Published, Is_Schema_Published, Is_Disabled, Is_not_trusted, Is_not_for_replicatiON, Is_System_Named, delete_referential_actiON, update_referential_actiON, Key_Index_ID, principal_ID, REG_Create_Date)
SELECT 0,0,0,0,0,0,0,0,0,0,0,0,0,''1/1/1900''

SET IDENTITY_Insert CAT.REG_0302_Foreign_Key_Details OFF


/* Tier 4 includes only indexes which have special column specific and mutable column features. */
SET IDENTITY_Insert CAT.REG_0402_Column_Index_Details ON

INSERT INTO CAT.REG_0402_Column_Index_Details (REG_0402_ID, Index_Column_ID, Partition_Ordinal, Is_Descending_Key, Is_Included_Column, REG_Create_Date)
SELECT 0,0,0,0,0,''1/1/1900''

SET IDENTITY_Insert CAT.REG_0402_Column_Index_Details OFF

' 
END
GO
