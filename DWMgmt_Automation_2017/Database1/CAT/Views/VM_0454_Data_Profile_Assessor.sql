

CREATE VIEW [CAT].[VM_0454_Data_Profile_Assessor]
AS


/* Prioritizing Candidates
	Objects which have been updated should be top priority

	1. Prioritize the action types detected first.
		1. A value definitely changed! An update has been detected on the column
		2. A whole table read was detected against the table - this is an oportunity to evaluate content for indexing and integrity contstraints.
		3. A seek against an index was detected - these are the least intensive read, and prove some form of structure exists.
		4. No action was detected - prioritize these tables least.
	2. If the last action against the table occured prior to the last index integrity scan, deprioritize one step (+1).
	3. Must have been writen to since since last profiling OR never have been scanned.

	Simplified to Top 10 objects which qualify for profiling based on the criteria above.

*/

SELECT TOP 10 ctl.REG_Server_Name
, ctl.LNK_FK_0100_ID
, ctl.REG_Database_Name
, ctl.Schema_Bound_Name
FROM CAT.VI_0300_Full_Object_Map AS ctl
LEFT JOIN CAT.VI_0350_Index_Integrity_Report AS iir
ON iir.TRK_FK_T3_OBJ_ID = ctl.LNK_T3_ID
AND iir.TRK_Scanned_Record_Count > 0
LEFT JOIN CAT.TRK_0454_Column_Metrics AS tcm WITH(NOLOCK)
ON tcm.TRK_FK_T4_ID = ctl.LNK_T4_ID
LEFT JOIN CAT.TRK_0300_Object_Utiliztion_Metrics AS oum WITH(NOLOCK)
ON oum.TRK_FK_T3_ID = ctl.LNK_T3_ID
WHERE 1=1
and ctl.REG_Object_Type IN ('U','V')
AND ctl.REG_Database_Name NOT IN ('DWMgmt','DWMgmt_DW','OGMarket','master','model','msdb','tempdb','SSISDB')
AND ctl.REG_Database_Name NOT LIKE 'ReportServer%'
AND ctl.REG_Schema_Name NOT IN ('sys','INFORMATION_SCHEMA')
GROUP BY ctl.REG_Server_Name
, ctl.LNK_FK_0100_ID
, ctl.REG_Database_Name
, ctl.Schema_Bound_Name
, oum.TRK_Last_Action_Type
HAVING oum.TRK_Last_Action_Type = 'last_user_update' 
AND ISNULL(MAX(tcm.TRK_Post_Date),-1) < ISNULL(MAX(oum.TRK_Last_Action_Date),0)
OR ISNULL(MAX(tcm.TRK_Post_Date),-1) = -1 -- Note 3
ORDER BY ROW_NUMBER() OVER(ORDER BY
	CASE WHEN oum.TRK_Last_Action_Type = 'last_user_update' THEN 1
		WHEN oum.TRK_Last_Action_Type = 'last_user_scan' THEN 2
		WHEN oum.TRK_Last_Action_Type = 'last_user_seek' THEN 3
		ELSE 4 END -- Note 1
	, CASE WHEN ISNULL(MAX(oum.TRK_Last_Action_Date),-1) > ISNULL(MAX(iir.Last_Scan_Date),0) THEN 0
		ELSE 1 END	-- Note 2
	, SUM(iir.TRK_Scanned_Record_Count)
	)