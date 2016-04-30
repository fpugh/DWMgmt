USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[SUB_0440_Stats_Metric_Capture]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[SUB_0440_Stats_Metric_Capture]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[SUB_0440_Stats_Metric_Capture]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [CAT].[SUB_0440_Stats_Metric_Capture]
@TargetDBLocation NVARCHAR(256) = ''master''
, @SourceDBLocation NVARCHAR(256) = ''DWMgmt''
, @ExecuteStatus TINYINT = 2


AS


IF @ExecuteStatus = 2 SET NOCOUNT OFF


DECLARE @SQL nvarchar(max)
, @ExecuteSQL nvarchar(271)



IF @ExecuteStatus <> 3 SET @SQL = @SQL + ''
INSERT INTO [''+@SourceDBLocation+''].TMP.TRK_0440_Column_Statistics (TRK_Server_ID, TRK_Server_Name, TRK_Database_ID
, TRK_Database_Name, TRK_Schema_ID, TRK_Schema_Name, TRK_Object_ID, TRK_Object_Name, TRK_Column_ID, TRK_Column_Name, TRK_Stats_ID
, TRK_Stats_Column_ID, TRK_Stats_Name, TRK_Auto_Created, TRK_User_Created, TRK_No_Recompute, TRK_Has_Filter, TRK_Filter_Definition)
''

SET @SQL = @SQL + ''
SELECT 0, @@SERVERNAME, DB_ID(), DB_Name()
, obj.Schema_ID, scm.name, sts.Object_ID, obj.name, stc.Column_ID, col.name, sts.stats_ID
, stc.stats_Column_ID, sts.name, sts.auto_created, sts.user_created, sts.no_recompute, sts.has_filter
, sts.filter_Definition
FROM [''+@TargetDBLocation+''].sys.stats AS sts
JOIN [''+@TargetDBLocation+''].sys.stats_columns AS stc
ON sts.Object_ID = stc.Object_ID
AND sts.stats_ID = stc.stats_ID
JOIN [''+@TargetDBLocation+''].sys.all_objects AS obj
ON obj.Object_ID = sts.Object_ID
JOIN [''+@TargetDBLocation+''].sys.schemas AS scm
ON scm.Schema_ID = obj.Schema_ID
JOIN [''+@TargetDBLocation+''].sys.all_columns as col
ON col.Object_ID = obj.Object_ID
AND col.Column_ID = stc.Column_ID
''


IF @ExecuteStatus in (0,3)
BEGIN
	SELECT ''TRK_0440_Column_Statistics'' AS SQL_Object_Name, @SQL
END


IF @ExecuteStatus in (0)
BEGIN
	PRINT @SQL
END


IF @ExecuteStatus in (1,2)
BEGIN
	SET @ExecuteSQL = @TargetDBLocation+''..sp_executesql'' 
	EXEC @ExecuteSQL @SQL
END

' 
END
GO
