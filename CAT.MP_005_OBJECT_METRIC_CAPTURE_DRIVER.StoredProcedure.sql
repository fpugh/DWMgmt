USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_005_OBJECT_METRIC_CAPTURE_DRIVER]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[MP_005_OBJECT_METRIC_CAPTURE_DRIVER]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_005_OBJECT_METRIC_CAPTURE_DRIVER]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/* TODO: Amend this to dump base results into a TMP schema table to be
	loaded into the library during MP_003 processing. Revise MP_003 coding
	to refect the order of opperations change between scanning this data
	and loading to the catalogs */

CREATE PROCEDURE [CAT].[MP_005_OBJECT_METRIC_CAPTURE_DRIVER]
@TargetDBLocation NVARCHAR(200)
, @NamePart NVARCHAR(256) = N''ALL''
, @ScanMode NVARCHAR(65) = N''SAMPLED''
, @SourceDBLocation NVARCHAR(200) = N''DWMgmt''
, @SourceCollation NVARCHAR(60) = N''Database_Default''
, @ExecuteStatus TINYINT = 2

AS


IF @ExecuteStatus IN (0,2) SET NOCOUNT ON

DECLARE @SQL NVARCHAR(max)
, @SQL1 NVARCHAR(4000)
, @SQL2 NVARCHAR(4000)
, @SQL3 NVARCHAR(4000)
, @DateString CHAR(8)
, @CollectionStatement NVARCHAR(1000)

SET @DateString = cast(year(getdate()) AS CHAR(4))+right(''00[''+cast(month(getdate()) AS VARCHAR),2)+right(''00[''+cast(day(getdate()) AS VARCHAR),2)

/* Set up library collection inserts to catalog values/database.
	Test values for multi-word values ((n)char/(n)varchar)
	?? Convert datetimes to integer values for storage ??
	Link stored value to collection through junction.
	?? Prioritize value storage by type ??
*/


SET @SQL1 = ''
EXEC	CAT.SUB_0350_Index_Metric_Capture_Driver
		@TargetDBLocation = ''''[''+@TargetDBLocation+'']'''',
		@SourceDBLocation = ''''[''+@SourceDBLocation+'']'''',
		@NamePart = ''+@NamePart+'',
		@ScanMode = ''''[''+@ScanMode+'']'''',
		@ExecuteStatus = ''+cast(@ExecuteStatus as nvarchar)+''
''


SET @SQL2 = ''

INSERT INTO [''+@SourceDBLocation+''].CAT.TRK_0301_Object_Index_Metrics (TRK_FK_T2_ID, TRK_FK_T3_OBJ_ID, TRK_FK_T3_IDX_ID, TRK_Log_Mode
, TRK_Index_Rank, TRK_Partition_Number, TRK_Index_Type_Desc, TRK_Alloc_Unit_Type_Desc, TRK_Index_Depth, TRK_Index_Level
, TRK_Avg_Fragmentation_Percent, TRK_Fragment_Count, TRK_Avg_Fragment_Page_Size, TRK_Page_Count, TRK_Avg_Page_Space_Percent_Used
, TRK_Scanned_Record_Count, TRK_Min_Record_Byte_Size, TRK_Max_Record_Byte_Size, TRK_Avg_Record_Byte_Size
, TRK_Forwarded_Record_Count, TRK_Compressed_Page_Count)

SELECT DISTINCT V343.LNK_T2_ID, V343.LNK_T3P_ID, V343.LNK_T3I_ID
, TMP.Log_Mode, TMP.Index_Rank, TMP.Partition_Number, TMP.Index_Type_Desc, TMP.Alloc_Unit_Type_Desc, TMP.Index_depth, TMP.Index_level
, TMP.avg_fragmentation_percent, TMP.fragment_count, TMP.Avg_Fragment_Page_Size, TMP.page_count, TMP.Avg_Page_Space_Percent_Used
, TMP.Scanned_Record_Count, TMP.Min_Record_Byte_Size, TMP.Max_Record_Byte_Size, TMP.Avg_Record_Byte_Size, TMP.forwarded_record_count
, TMP.compressed_page_count
FROM [''+@SourceDBLocation+''].TMP.TRK_0350_Index_Metric_Insert AS tmp
JOIN [''+@SourceDBLocation+''].CAT.VI_0343_Index_Column_Latches AS V343
ON TMP.Database_Name = V343.REG_Database_Name
AND TMP.Schema_Name = V343.REG_Schema_Name
AND TMP.Object_Name = V343.REG_Object_Name
AND TMP.Index_Name = V343.REG_Index_Name
WHERE TMP.Index_Type <> 0
UNION
SELECT DISTINCT V200.LNK_T2_ID, V200.LNK_T3_ID, V200.LNK_T3_ID
, TMP.Log_Mode, TMP.Index_Rank, TMP.Partition_Number, TMP.Index_Type_Desc, TMP.Alloc_Unit_Type_Desc, TMP.Index_depth, TMP.Index_level
, TMP.avg_fragmentation_percent, TMP.fragment_count, TMP.Avg_Fragment_Page_Size, TMP.page_count, TMP.Avg_Page_Space_Percent_Used
, TMP.Scanned_Record_Count, TMP.Min_Record_Byte_Size, TMP.Max_Record_Byte_Size, TMP.Avg_Record_Byte_Size, TMP.forwarded_record_count
, TMP.compressed_page_count
FROM [''+@SourceDBLocation+''].TMP.TRK_0350_Index_Metric_Insert AS tmp
JOIN [''+@SourceDBLocation+''].CAT.VI_0200_Column_Tier_Latches AS V200
ON TMP.Database_Name = V200.REG_Database_Name
AND TMP.Schema_Name = V200.REG_Schema_Name
AND TMP.Object_Name = V200.REG_Object_Name
WHERE TMP.Index_Type = 0
''


/** Execute [CAT].[SUB_002_MASS_Value_HASHER] **/

SET @SQL3 = ''
EXEC	CAT.SUB_0354_Mass_Value_Summary
		@TargetDBLocation = ''''[''+@TargetDBLocation+'']'''',
		@SourceDBLocation = ''''[''+@SourceDBLocation+'']'''',
		@NamePart = ''''[''+@NamePart+'']'''',
		@ExecuteStatus = ''+cast(@ExecuteStatus as nvarchar)+''


UPDATE t1 SET LNK_T4_ID = v200.lnk_T4_id
FROM [''+@SourceDBLocation+''].TMP.TRK_0354_Value_Hash as t1
LEFT JOIN [''+@SourceDBLocation+''].CAT.VI_0200_Column_Tier_Latches AS V200 WITH(NOLOCK)
ON t1.Column_Name = V200.REG_Column_Name
AND t1.Schema_Bound_Name = V200.Schema_Bound_Name
AND t1.Database_Name = V200.REG_Database_Name
AND t1.Server_Name = V200.REG_Server_Name


INSERT INTO [''+@SourceDBLocation+''].CAT.TRK_0400_Column_Metrics (TRK_FK_T4_ID, TRK_Total_Values, TRK_Column_nulls, TRK_Density, TRK_Uniqueness, TRK_Distinct_Values)

SELECT DISTINCT a.LNK_T4_ID
, a.SumValueCount
+ isnull(b.SumColumnNulls,0) as TRK_Total_Values
, isnull(b.SumColumnNulls,0) as TRK_Column_nulls
, a.SumValueCount / cast((a.SumValueCount + isnull(b.SumColumnNulls,0)) as money) TRK_Density
, a.DistinctValueCount / cast(a.SumValueCount as money) TRK_Uniqueness
, a.DistinctValueCount as TRK_Distinct_Values
FROM (
	SELECT LNK_T4_ID, count(distinct Column_Value) as DistinctValueCount, sum(Value_Count) as SumValueCount
	FROM [''+@SourceDBLocation+''].TMP.TRK_0354_Value_Hash AS t1 WITH(NOLOCK)
	WHERE ISNULL(Column_Value,'''''''') <> ''''''''
	GROUP BY LNK_T4_ID
	) as a
LEFT JOIN (
	SELECT LNK_T4_ID, sum(Value_Count) as SumColumnNulls
	FROM [''+@SourceDBLocation+''].TMP.TRK_0354_Value_Hash AS t1 WITH(NOLOCK)
	WHERE ISNULL(Column_Value,'''''''') = ''''''''
	GROUP BY LNK_T4_ID
	) as b
ON b.LNK_T4_ID = a.LNK_T4_ID
''


SET @SQL3 = @SQL3 + ''''
--/* This type of execution will become an @ArchivePrep switchable statement for many tracking queries */
--EXEC SP_RENAME ''''TMP.TRK_0354_Value_Hash'''', ''''TRK_0354_Value_Hash_[''+@NamePart+'']_[''+@DateString+'']''''
--EXEC SP_RENAME ''''TMP.TRK_0350_Index_Metric_Insert'''', ''''TRK_0350_Index_Metric_Insert_[''+@DateString+'']''''
----EXEC SP_RENAME ''''TMP.TRK_0440_Column_Statistics'''', ''''TRK_0440_Column_Statistics_[''+@DateString+'']''''
--''


IF @ExecuteStatus in (0,1)
BEGIN
	PRINT @SQl1
	PRINT @SQL2
	PRINT @SQL3
END


IF @ExecuteStatus in (1,2)
BEGIN
	SET @SQL = cast(@SQL1 as nvarchar(max))+cast(@SQL2 as nvarchar(max))+cast(@SQL3 as nvarchar(max))
	EXEC sp_executesql @SQL
END


' 
END
GO
