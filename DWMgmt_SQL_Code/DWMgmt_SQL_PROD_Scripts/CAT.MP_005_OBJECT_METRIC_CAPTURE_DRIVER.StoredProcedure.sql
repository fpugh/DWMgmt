USE [DWMgmt]
GO


/* TODO: Amend this to dump base results into a TMP schema table to be
	loaded into the library during MP_003 processing. Revise MP_003 coding
	to refect the order of opperations change between scanning this data
	and loading to the catalogs */

CREATE PROCEDURE [CAT].[MP_005_OBJECT_METRIC_CAPTURE_DRIVER]
@TargetDBLocation NVARCHAR(200)
, @NamePart NVARCHAR(256) = N'ALL'
, @ScanMode NVARCHAR(65) = N'SAMPLED'
, @SourceDBLocation NVARCHAR(200) = N'DWMgmt'
, @SourceCollation NVARCHAR(60) = N'Database_Default'
, @ExecuteStatus TINYINT = 2

AS


IF @ExecuteStatus IN (0,2) SET NOCOUNT ON

DECLARE @SQL NVARCHAR(max)
, @SQL1 NVARCHAR(4000)
, @SQL2 NVARCHAR(4000)
, @SQL3 NVARCHAR(4000)
, @SQL4 NVARCHAR(4000)
, @DateString CHAR(8)
, @CollectionStatement NVARCHAR(1000)

SET @DateString = cast(year(getdate()) AS CHAR(4))+right('00['+cast(month(getdate()) AS VARCHAR),2)+right('00['+cast(day(getdate()) AS VARCHAR),2)

/* Set up library collection inserts to catalog values/database.
	Test values for multi-word values ((n)char/(n)varchar)
	?? Convert datetimes to integer values for storage ??
	Link stored value to collection through junction.
	?? Prioritize value storage by type ??
*/


SET @SQL1 = '
EXEC	CAT.SUB_0350_Index_Metric_Capture_and_Load
		@TargetDBLocation = '''+@TargetDBLocation+''',
		@SourceDBLocation = '''+@SourceDBLocation+''',
		@NamePart = '''+@NamePart+''',
		@ScanMode = '''+@ScanMode+''',
		@ExecuteStatus = '+cast(@ExecuteStatus as nvarchar)+'
'


SET @SQL2 = '
INSERT INTO '+@SourceDBLocation+'.CAT.TRK_0350_Object_Index_Metrics (TRK_FK_T2_ID, TRK_FK_T3_OBJ_ID, TRK_FK_T3_IDX_ID, TRK_Scan_Mode
, TRK_Index_Rank, TRK_Partition_Number, TRK_Index_Type_Desc, TRK_Alloc_Unit_Type_Desc, TRK_Index_Depth, TRK_Index_Level
, TRK_Avg_Fragmentation_Percent, TRK_Fragment_Count, TRK_Avg_Fragment_Page_Size, TRK_Page_Count, TRK_Avg_Page_Space_Percent_Used
, TRK_Scanned_Record_Count, TRK_Min_Record_Byte_Size, TRK_Max_Record_Byte_Size, TRK_Avg_Record_Byte_Size
, TRK_Forwarded_Record_Count, TRK_Compressed_Page_Count)

SELECT DISTINCT V343.LNK_T2_ID, V343.LNK_T3P_ID, V343.LNK_T3I_ID
, TMP.Scan_Mode, TMP.Index_Rank, TMP.Partition_Number, TMP.Index_Type_Desc, TMP.Alloc_Unit_Type_Desc, TMP.Index_depth, TMP.Index_level
, TMP.avg_fragmentation_percent, TMP.fragment_count, TMP.Avg_Fragment_Page_Size, TMP.page_count, TMP.Avg_Page_Space_Percent_Used
, TMP.Scanned_Record_Count, TMP.Min_Record_Byte_Size, TMP.Max_Record_Byte_Size, TMP.Avg_Record_Byte_Size, TMP.forwarded_record_count
, TMP.compressed_page_count
FROM '+@SourceDBLocation+'.TMP.TRK_0350_Index_Metric_Insert AS tmp
JOIN '+@SourceDBLocation+'.CAT.VI_0343_Index_Column_Latches AS V343
ON TMP.Server_Name = V343.REG_Server_Name
AND TMP.Database_Name = V343.REG_Database_Name
AND TMP.Schema_Name = V343.REG_Schema_Name
AND TMP.Object_Name = V343.REG_Object_Name
AND TMP.Index_Name = V343.REG_Index_Name
WHERE TMP.Index_Type <> 0
UNION
SELECT DISTINCT V200.LNK_T2_ID, V200.LNK_T3_ID, V200.LNK_T3_ID
, TMP.Scan_Mode, TMP.Index_Rank, TMP.Partition_Number, TMP.Index_Type_Desc, TMP.Alloc_Unit_Type_Desc, TMP.Index_depth, TMP.Index_level
, TMP.avg_fragmentation_percent, TMP.fragment_count, TMP.Avg_Fragment_Page_Size, TMP.page_count, TMP.Avg_Page_Space_Percent_Used
, TMP.Scanned_Record_Count, TMP.Min_Record_Byte_Size, TMP.Max_Record_Byte_Size, TMP.Avg_Record_Byte_Size, TMP.forwarded_record_count
, TMP.compressed_page_count
FROM '+@SourceDBLocation+'.TMP.TRK_0350_Index_Metric_Insert AS tmp
JOIN '+@SourceDBLocation+'.CAT.VI_0300_Full_Object_Map AS V200
ON TMP.Server_Name = V200.REG_Server_name
AND TMP.Database_Name = V200.REG_Database_Name
AND TMP.Schema_Name = V200.REG_Schema_Name
AND TMP.Object_Name = V200.REG_Object_Name
WHERE TMP.Index_Type = 0
'


/** Execute [CAT].[SUB_002_MASS_Value_HASHER] **/

SET @SQL3 = '
EXEC	CAT.SUB_1354_Data_Profile_Executor
		@TargetDBLocation = '''+@TargetDBLocation+''',
		@SourceDBLocation = '''+@SourceDBLocation+''',
		@NamePart = '''+@NamePart+''',
		@ExecuteStatus = '+cast(@ExecuteStatus as nvarchar)+'
'

SET @SQL4 = '
INSERT INTO '+@SourceDBLocation+'.CAT.TRK_0454_Column_Metrics (TRK_FK_T4_ID, TRK_Total_Values, TRK_Column_nulls, TRK_Density, TRK_Uniqueness, TRK_Distinct_Values)

SELECT DISTINCT VHO.LNK_T4_ID
, SVC.SumValueCount
+ isnull(SCN.SumColumnNulls,0) as TRK_Total_Values
, isnull(SCN.SumColumnNulls,0) as TRK_Column_NULLs
, CASE WHEN ISNULL(SCN.SumColumnNulls,0) = SVC.SumValueCount THEN 1 ELSE 1 - ISNULL(SCN.SumColumnNulls,0) / (SVC.SumValueCount * 1.0000) END AS TRK_Density
, CASE WHEN ISNULL(SCN.SumColumnNulls,0) = SVC.SumValueCount THEN 0 ELSE (SVC.SumValueCount - ISNULL(SCN.SumColumnNulls,0)) / (SVC.SumValueCount * 1.0000) / SVC.DistinctValueCount END AS TRK_Uniqueness
, SVC.DistinctValueCount as TRK_Distinct_Values
FROM (
	SELECT LNK_T4_ID, count(distinct Column_Value) as DistinctValueCount, sum(Value_Count) as SumValueCount
	FROM '+@SourceDBLocation+'.TMP.TRK_0354_Value_Hash AS t1 WITH(NOLOCK)
	GROUP BY LNK_T4_ID
	) as SVC
LEFT JOIN (
	SELECT LNK_T4_ID, sum(Value_Count) as SumColumnNulls
	FROM '+@SourceDBLocation+'.TMP.TRK_0354_Value_Hash AS t1 WITH(NOLOCK)
	WHERE ISNULL(Column_Value,'''') = ''''
	GROUP BY LNK_T4_ID
	) AS SCN
ON SVC.LNK_T4_ID = SCN.LNK_T4_ID
JOIN '+@SourceDBLocation+'.TMP.TRK_0354_Value_Hash_Objects AS VHO WITH(NOLOCK)
ON VHO.LNK_T4_ID = SVC.LNK_T4_ID
'

IF @ExecuteStatus in (0,1)
BEGIN
	PRINT @SQl1
	PRINT @SQL2
	PRINT @SQL3
	PRINT @SQL4
END


IF @ExecuteStatus in (1,2)
BEGIN
	SET @SQL = cast(@SQL1 as nvarchar(max))+cast(@SQL2 as nvarchar(max))+cast(@SQL3 as nvarchar(max))+cast(@SQL4 as nvarchar(max))
	EXEC sp_executesql @SQL
END










GO
