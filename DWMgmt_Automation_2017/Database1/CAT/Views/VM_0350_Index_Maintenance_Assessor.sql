

CREATE VIEW [CAT].[VM_0350_Index_Maintenance_Assessor]
AS
SELECT DISTINCT iir.TRK_FK_T2_ID
, iir.TRK_FK_T3_OBJ_ID
, iir.TRK_FK_T3_IDX_ID
, iir.REG_Server_Name
, iir.REG_Database_Name
, iir.Schema_Bound_Name
, iir.Index_Name
, iir.TRK_Index_Rank
, CASE WHEN sub.TRK_FK_T3_OBJ_ID IS NOT NULL THEN 'REBUILD'
	WHEN sub.TRK_FK_T3_OBJ_ID IS NULL AND iir.TRK_Avg_Fragmentation_Percent BETWEEN 30 AND 50 THEN 'REBUILD'
	WHEN sub.TRK_FK_T3_OBJ_ID IS NULL AND iir.TRK_Avg_Fragmentation_Percent <= 30 THEN 'REORGANIZE' END AS Operation
, iir.TRK_Avg_Fragmentation_Percent
, iir.TRK_Fragment_Count
, iir.TRK_Avg_Record_Byte_Size
--select *
FROM CAT.VI_0350_Index_Integrity_Report AS iir
LEFT JOIN (
	SELECT DISTINCT iir.TRK_FK_T3_OBJ_ID
	FROM CAT.VI_0350_Index_Integrity_Report AS iir
	WHERE iir.REG_0200_ID > 4
	AND iir.TRK_Page_Count >= 1000
	AND iir.TRK_Avg_Fragmentation_Percent >= 15
	AND iir.TRK_Index_Type_Desc = 'CLUSTERED INDEX'
	UNION
	SELECT DISTINCT iir.TRK_FK_T3_OBJ_ID
	FROM CAT.VI_0350_Index_Integrity_Report AS iir
	WHERE iir.REG_0200_ID > 4
	AND iir.TRK_Page_Count >= 1000
	AND iir.TRK_Avg_Fragmentation_Percent >= 25
	AND iir.TRK_Index_Type_Desc = 'NONCLUSTERED INDEX'
	) AS sub
ON sub.TRK_FK_T3_OBJ_ID = iir.TRK_FK_T3_OBJ_ID
	/* Impliement the following code once a history of performance is established, and appropriate limits can be derived */
	--LEFT JOIN (
	--	SELECT TRK_FK_T2_ID, TRK_FK_T3_ID
	--	, SUM(TRK_Record_Count) AS SUM_Record_Count
	--	, AVG(DATEDIFF(millisecond, TRK_Post_Date, TRK_Term_Date)) AS AVG_Job_Duration_MS
	--	, AVG(DATEDIFF(millisecond, TRK_Post_Date, TRK_Term_Date)) / SUM(TRK_Record_Count) AS Job_RPMS
	--	FROM CAT.TRK_0205_DB_Maintenance_Job_Tracking
	--	GROUP BY TRK_FK_T2_ID, TRK_FK_T3_ID
	--) AS trk
	--ON trk.TRK_FK_T2_ID = iir.TRK_FK_T2_ID
	--AND  trk.TRK_FK_T3_ID = iir.TRK_FK_T3_IDX_ID
WHERE iir.REG_0200_ID > 4
AND iir.TRK_Avg_Fragmentation_Percent > 5
AND iir.TRK_Page_Count >= 1000
AND iir.TRK_Index_Type_Desc != 'HEAP'