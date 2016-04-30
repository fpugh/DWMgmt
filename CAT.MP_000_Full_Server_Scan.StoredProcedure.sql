USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_000_Full_Server_Scan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[MP_000_Full_Server_Scan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_000_Full_Server_Scan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [CAT].[MP_000_Full_Server_Scan]
@SourceServer NVARCHAR(256) = @@ServerName
, @ExecuteStatus TINYINT = 2
, @TrackingStatus TINYINT = 0
, @SystemStatus TINYINT = 0

AS

IF @ExecuteStatus IN (0,2) SET NOCOUNT ON

DECLARE @SourceDBLocation NVARCHAR(256) = ''[''+@SourceServer+''].DWMgmt''

/* Description: This procecdure executes a system scan. It executes several sub-procedures which utilize dynamic SQL to configure queries that allow for execution
	across linked-servers; permitting environment-scans in systems as early as SQL Server 2000-2005. This procedure runs in the local DWMgmt database installation.
	It will acquire linked server information during its initial scan. Subsequent scans will permit wider and wider scan ranges, depending on link depth. and SSIS
	package is available which performs this same function with a pre-loaded CAT.REG_0100_Server_Registry table. */

/* Rule: Procedures with names like MP_### indicate the relative order in which the procedure may be executed. Each digit can represent a decrimented branch. E.g. "00#"
	are procedures which can be executed in series. Following this method, "0#1" can only execute after its root parent "0#0" has run.
	
	Rule: Table, view, and procedure #### codes are currently restricted to numeric values. When good case is established for a wider range of codes required, an alpha
	brand can be added if appropriate - expanding the option set significantly.
*/


/* Clear any existing tables - this global scan 
	overrides any existing step-wise scan */

EXEC	CAT.MP_006_CLEAR_INVENTORY
		@ExecuteStatus = @ExecuteStatus


DECLARE @TargetServer NVARCHAR(256)
, @TargetDBLocation NVARCHAR(256)
, @DBName NVARCHAR(256)
, @SQL NVARCHAR(MAX)

DECLARE ServerResolver CURSOR FOR
SELECT ''[''+sys.name+'']''
FROM sys.servers as sys
LEFT JOIN cat.REG_0100_Server_Registry as reg
ON reg.REG_Server_Name = sys.name
AND reg.REG_Monitored = 0
WHERE (server_id = 0 OR is_linked = 1)
AND reg.REG_0100_ID IS NULL

OPEN ServerResolver

FETCH NEXT FROM ServerResolver INTO
@TargetServer

WHILE @@fetch_status = 0
BEGIN

	/* Check for Destination Server <> Source Server If destination different, 
		queue ETL statements for extraction prior to local catalog and timming. */
	SET @TargetDBLocation = @TargetServer+''.master''

	EXEC	CAT.MP_001_SERVER_CENSUS
			@TargetDBLocation = @TargetDBLocation,
			@ExecuteStatus = @ExecuteStatus,
			@SystemStatus = @SystemStatus


	/* Consider controlling this by the values returned by the
		setting of the master procedure above. */

	DECLARE DBResolver CURSOR FOR
	SELECT DISTINCT @TargetServer +''.''+ Database_Name
	FROM TMP.REG_0100_0200_Insert
	WHERE Server_Name = @@servername

	OPEN DBResolver

	FETCH NEXT FROM DBResolver
	INTO @TargetDBLocation

	WHILE @@fetch_status = 0
	BEGIN
  
		SET @SQL = ''
		IF EXISTS (SELECT count(*) FROM ''+@TargetDBLocation+''.sys.objects) PRINT '''''''';
		''
		IF @ExecuteStatus in (1,2)
		BEGIN TRY

			EXEC sp_executeSQL @SQL

   		END TRY

			BEGIN CATCH
			PRINT ''ERROR: '' + ERROR_MESSAGE()

			FETCH NEXT FROM DBResolver
			INTO @TargetDBLocation

			CONTINUE

		END CATCH


		SET @SQL = ''
		EXEC CAT.MP_002_DATABASE_CENSUS
		@TargetDBLocation = N''''''+@TargetDBLocation+'''''',
		@SourceDBLocation = N''''''+@SourceDBLocation+'''''',
		@ExecuteStatus = ''+CAST(@ExecuteStatus AS nvarchar)+''
		''

		IF @TrackingStatus = 1
		SET @SQL = @SQL + ''
		EXEC CAT.MP_005_OBJECT_METRIC_CAPTURE_DRIVER
		@TargetDBLocation = N''''''+@TargetDBLocation+'''''',
		@SourceDBLocation = N''''''+@SourceDBLocation+'''''',
		@ExecuteStatus = ''+CAST(@ExecuteStatus AS nvarchar)+''
		''

		IF @ExecuteStatus in (0,1)
		BEGIN
			PRINT @TargetDBLocation+'': Registration Complete''
			PRINT @SQL
		END

		IF @ExecuteStatus in (1,2)
		BEGIN
			EXEC sp_executeSQL @SQL
		END

	FETCH NEXT FROM DBResolver
	INTO @TargetDBLocation

	END

	CLOSE DBResolver
	DEALLOCATE DBResolver


/* High Level Census */
EXEC CAT.MP_004_GLOBAL_METRIC_CAPTURE_DRIVER
@ExecuteStatus = @ExecuteStatus


FETCH NEXT FROM ServerResolver INTO
@TargetServer

END

CLOSE ServerResolver
DEALLOCATE ServerResolver


/* All Local databases registered - compile non-local ETL here 
    EXECUTE PACKAGES - EXECUTE FOR-EACH ON EACHSERVER
    * Bring over the remote server''s virtual catalog with local server id stamp for that server (REG_0100_ID, Server_ID, and Server_Name)
    * Each table will append over with the local ID stamp for the remote server as a cross-apply type of function.
    * Local v-catalog tables will be groomed and prepared for multi-server/multi-database latching. 
        ** add tier latch codes from expanded full object map to fully appended v-catalog tables
        ** update missing identifiers
    * Perform cross check (de-registration) against current existing catalog and apply location updates.
*/


/* Temporary Table Index Creation Notes 
	* A method to improve the performance of athe analysis AFTER loading. There seem to be some incidental errors here; it loads though so this will do for now. 
	* Because these object MUST exist after the upper code is run, no object check will be required (other implimentations require an additional check per object).
*/

SELECT tbl.Name as Table_Name, idx.Name as IndexName
INTO #TMP_Table_Indices
FROM sys.tables AS tbl
LEFT JOIN sys.indexes AS idx
ON idx.Object_ID = tbl.Object_ID
AND idx.type <> 0


/* Clustered Indexes ONLY on server level objects - not enough content to justify performance overhead. */
IF NOT EXISTS (SELECT Name FROM sys.indexes WHERE Name = ''tdx_CI_REG_0100_0200_K3_K5'')
BEGIN
	CREATE CLUSTERED INDEX tdx_CI_REG_0100_0200_K3_K5 ON TMP.REG_0100_0200_Insert (Server_Name, Database_Name)
END

IF NOT EXISTS (SELECT Name FROM sys.indexes WHERE Name = ''tdx_CI_REG_0201_K2_K3'')
BEGIN
	CREATE CLUSTERED INDEX tdx_CI_REG_0201_K2_K3 ON TMP.REG_0201_Insert (Server_ID, Database_ID)
END

IF NOT EXISTS (SELECT Name FROM sys.indexes WHERE Name = ''tdx_CI_REG_0202_K2_K3'')
BEGIN
	CREATE CLUSTERED INDEX tdx_CI_REG_0202_K2_K3 ON TMP.REG_0202_Insert (Server_ID, Database_ID)
END

IF NOT EXISTS (SELECT Name FROM sys.indexes WHERE Name = ''tdx_CI_REG_0203_K2_K3'')
BEGIN
	CREATE CLUSTERED INDEX tdx_CI_REG_0203_K2_K3 ON TMP.REG_0203_Insert (Server_ID, Database_ID)
END


/* Clustered Indexes on ALL database level objects or lower, and select NON-clusterd indexes on appropriate column sets */
IF NOT EXISTS (SELECT Name FROM sys.indexes WHERE Name = ''tdx_CI_REG_0204_0300_K4'')
BEGIN
	CREATE CLUSTERED INDEX tdx_CI_REG_0204_0300_K4 ON TMP.REG_0204_0300_Insert (Server_ID, Database_ID, Schema_ID, Object_ID)
END

IF NOT EXISTS (SELECT Name FROM sys.indexes WHERE Name = ''tdx_nc_REG_0204_0300_K9_K11_I13'')
BEGIN
	CREATE NONCLUSTERED INDEX tdx_nc_REG_0204_0300_K9_K11_I13 ON TMP.REG_0204_0300_Insert (Schema_Name, Object_Name) INCLUDE (Object_Type)
END


IF NOT EXISTS (SELECT Name FROM sys.indexes WHERE Name = ''tdx_CI_REG_0300_0401_K7_K8_K9_K10_K14'')
BEGIN
	CREATE CLUSTERED INDEX tdx_CI_REG_0300_0401_K7_K8_K9_K10_K14 ON TMP.REG_0300_0401_Insert (Server_ID, Database_ID, Schema_ID, Object_ID, Column_Rank)
END

IF NOT EXISTS (SELECT Name FROM sys.indexes WHERE Name = ''tdx_nc_REG_0300_0401_K12_K13_I15_I16_I18'')
BEGIN
	CREATE NONCLUSTERED INDEX tdx_nc_REG_0300_0401_K12_K13_I15_I16_I18 ON TMP.REG_0300_0401_Insert (Column_Name, Column_Type) INCLUDE (Is_Identity, Is_Nullable, Is_Primary_Key)
END


IF NOT EXISTS (SELECT Name FROM sys.indexes WHERE Name = ''tdx_CI_REG_0600_K2_K3_K4_K5'')
BEGIN
	CREATE CLUSTERED INDEX tdx_CI_REG_0600_K2_K3_K4_K5 ON TMP.REG_0600_Insert (Server_ID, Database_ID, Schema_ID, Object_ID)
END


/* This is not appropriate for small insert tables, but if an on-demand method to test table size is available, this might be driven by
	total size of insert - constraints and short segments (< 256 characters) may be directly inserted to catalog collection. In highly
	constrained systems this will result in MANY defaults which can be eliminated from the SQL processing stack quickly.

		IF NOT EXISTS (SELECT IndexName FROM #TMP_Table_Indices WHERE Table_Name = ''##REG_0600_Insert'' AND IndexName = ''tdx_nc_REG_0600_K6_K8'')
		BEGIN
			CREATE NONCLUSTERED INDEX tdx_nc_REG_0600_K6_K8 ON ##REG_0600_Insert (type, Object_Name)
		END
*/


/* Object inserts need clustered indexes to speed up processing - try to create these programatically based off the ID column densisity concept */


/* RUN LOCAL CATALOG CODE 
    This process loads new entities into the compiled catalog.
    This process updates v-catalog tables with local catalog identifier codes.
    This process performs latching between tiers, and linking across peers.
    This process builds a v-catalog tree for comparisson to the compiled exanded object map
	Indexes should be created at appropriate levels and table volumes. Derive this programatically by
		testing volume/performance outcomes to find an optimal data-load/type, indexing regime. Use Performance
		probe code as analysis job to measure system receptivity to indexes and what thresholds of demand
		prompt which index regimes.
*/


EXEC CAT.MP_003_CENTRAL_REGISTRY_PROCESS
@ExecuteStatus = @ExecuteStatus


/* Post Cleanup */
IF @ExecuteStatus = 2
BEGIN
	EXEC CAT.MP_006_CLEAR_INVENTORY
	@ExecuteStatus = @ExecuteStatus
END
' 
END
GO
