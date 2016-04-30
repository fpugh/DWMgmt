USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[SUB_0350_Index_Metric_Capture_Driver]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[SUB_0350_Index_Metric_Capture_Driver]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[SUB_0350_Index_Metric_Capture_Driver]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [CAT].[SUB_0350_Index_Metric_Capture_Driver]
@TargetDBLocation NVARCHAR(256)
, @SourceDBLocation NVARCHAR(256) = N''DWMgmt''
, @NamePart NVARCHAR(65) = N''ALL''
, @ScanMode NVARCHAR(65) = N''SAMPLED''
, @ExecuteStatus TINYINT = 2

AS


IF @ExecuteStatus = 2 SET NOCOUNT OFF


IF @ScanMode NOT IN (''DEFAULT'', ''NULL'', ''LIMITED'', ''SAMPLED'', ''DETAILED'') SET @ScanMode = ''SAMPLED''


DECLARE @SQL nvarchar(max) = ''''
, @ExecuteSQL nvarchar(1000)



IF @ExecuteStatus <> 3 SET @SQL = ''
INSERT INTO [''+@SourceDBLocation+''].TMP.TRK_0350_Index_Metric_Insert (Server_ID, Database_ID, Schema_ID, Object_ID, Index_Rank, Server_Name, Database_Name
, Schema_Name, Object_Name, Index_Name, Index_Type, Index_Type_Desc, Log_Mode, Partition_Number, Alloc_Unit_Type_Desc, Index_Depth, Index_Level
, Avg_Fragmentation_Percent, Fragment_Count, Avg_Fragment_Page_Size, Page_Count, Avg_Page_Space_Percent_Used, Scanned_Record_Count, Min_Record_Byte_Size
, Max_Record_Byte_Size, Avg_Record_Byte_Size, Forwarded_Record_Count, Compressed_Page_Count)
''

SET @SQL = @SQL + ''
SELECT DISTINCT 0 as Server_ID, db_ID() as Database_ID, scm.Schema_ID, obj.Object_ID, idxo.Index_ID, @@SERVERNAME as Server_Name, db_Name() as Database_Name, scm.name as Schema_Name
, obj.name as Object_Name, isnull(idxo.name, obj.name) as Index_Name, idxo.type, idxs.Index_Type_Desc, ''''''+@ScanMode+'''''', idxs.Partition_Number
, idxs.Alloc_Unit_Type_Desc, idxs.Index_depth, idxs.Index_level, idxs.avg_fragmentation_in_percent, idxs.fragment_count, idxs.avg_fragment_Size_in_pages
, idxs.page_count, idxs.avg_page_space_used_in_percent, idxs.record_count, idxs.min_record_Size_in_bytes, idxs.max_record_Size_in_bytes
, idxs.avg_record_Size_in_bytes, idxs.forwarded_record_count, idxs.compressed_page_count
FROM [''+@TargetDBLocation+''].sys.dm_db_Index_physical_stats(db_ID(), NULL, NULL, NULL,''''''+@ScanMode+'''''') as idxs
JOIN [''+@TargetDBLocation+''].sys.all_objects AS obj
ON idxs.Database_ID = db_ID()
AND idxs.Object_ID = obj.Object_ID
JOIN [''+@TargetDBLocation+''].sys.schemas as scm
ON scm.Schema_ID = obj.Schema_ID
LEFT JOIN [''+@TargetDBLocation+''].sys.indexes as idxo
ON idxo.Object_ID = obj.Object_ID
AND idxo.Index_ID = idxs.Index_ID
LEFT JOIN [''+@TargetDBLocation+''].sys.Index_columns as idxc
ON idxc.Object_ID = obj.Object_ID
AND idxc.Index_ID = idxs.Index_ID
LEFT JOIN [''+@TargetDBLocation+''].sys.all_columns as col
ON col.Object_ID = obj.Object_ID
AND col.Column_ID = isnull(idxc.Column_ID, col.Column_ID)
WHERE (''''''+@NamePart+'''''' = ''''ALL'''' OR CHARINDEX(''''''+@NamePart+'''''', db_Name()+''''.''''+scm.name+''''.''''+obj.name) > 0)
AND db_ID() > 4
''

IF @ExecuteStatus in (0,1)
BEGIN
	PRINT @SQL
END


IF @ExecuteStatus = 3
BEGIN
	SELECT ''Index_Metric_Capture'' AS SQL_Title, @SQL AS SQL_Text
END


IF @ExecuteStatus in (1,2)
BEGIN
	SET @ExecuteSQL = @TargetDBLocation+''..sp_executesql'' 
	EXEC @ExecuteSQL @SQL
END

' 
END
GO
