


CREATE PROCEDURE [CAT].[MP_007_MAINTENANCE_JOB_LOGGER]
@ExecuteStatus TINYINT = 1
, @ModeId TINYINT = 1	-- Retained for conformity and future expansion.

AS

/* Log database backup requests.
	Backups may be time consuming; as execution statistics develop, times may be scheduled
	by a more intuitive algorithm. Some databases may have very low change and may require only weekly backups.
	When smart-scheduling, consider the seconds/byte time involved.
		Default values as follows:
			-- LNK_Min_Exec_Time: Until differentiated backup patterns develop, use midnight to midnight as valid times.
			-- LNK_Max_Exec_Time: 
			-- LNK_Term_Date: A backup request must be honored to close. Backups may be closed and escalated in extreme cases.
			-- LNK_Day_Modulus: Try to execute the backup every day.
*/

INSERT INTO CAT.LNK_0200_0205_Database_Maintenance_Links (LNK_FK_T2_ID, LNK_FK_0205_ID, LNK_Min_Exec_Time, LNK_Max_Exec_Time, LNK_Post_Date, LNK_Term_Date, LNK_Day_Modulus)

SELECT LNK_T2_ID
, job.REG_0205_ID
, '00:00:00.000'
, '23:59:00.000'
, CAST(GETDATE() AS DATE)
, '12/31/2099'	-- When a backup is requested it must be completed.
, CASE WHEN dba.Backup_Type = 'FULL_BACKUP' THEN 7 ELSE 1 END
FROM CAT.VM_0207_Database_Backup_Assessor AS dba
JOIN (
	SELECT REG_0205_ID, REG_Task_Name
	FROM CAT.REG_0205_Database_Maintenance_Properties 
	) AS job
ON job.REG_Task_Name = dba.Backup_Type
LEFT JOIN (
	SELECT TRK_FK_T2_ID
	, TRK_FK_0205_ID
	, SUM(TRK_Record_Count) AS SUM_Record_Count
	, AVG(DATEDIFF(millisecond, TRK_Post_Date, TRK_Term_Date)) AS AVG_Job_Duration_MS
	, AVG(DATEDIFF(millisecond, TRK_Post_Date, TRK_Term_Date)) / SUM(TRK_Record_Count) AS Job_RPMS
	FROM CAT.TRK_0205_DB_Maintenance_Job_Tracking
	GROUP BY TRK_FK_T2_ID, TRK_FK_0205_ID
) AS trk
ON trk.TRK_FK_T2_ID = dba.LNK_T2_ID
AND trk.TRK_FK_0205_ID = job.REG_0205_ID


/* Prepare the base query for supplying the scheduled tasks, or for executing lightweight processes with live execution 
	on the top 25% of badly fragmented indexes (> 30% fragmentation), and not otherwise excluded
		** Exclusion lists should be managed by configuration in the LNK_0200_0205_Database_Maintenance_Links table. 20170318::4est
*/

INSERT INTO CAT.LNK_0200_0205_Database_Maintenance_Links (LNK_FK_T2_ID, LNK_FK_T3_ID, LNK_FK_0205_ID, LNK_Min_Exec_Time, LNK_Max_Exec_Time, LNK_Post_Date, LNK_Term_Date, LNK_Day_Modulus)

SELECT DISTINCT ima.TRK_FK_T2_ID
, ima.TRK_FK_T3_OBJ_ID
, job.REG_0205_ID
, '00:00:00.000'
, '23:59:00.000'
, CAST(GETDATE() AS DATE)
, CAST(GETDATE() + 1 AS DATE)	-- Groom indexes within a day of logging, or close request. Revaluate index groom priority. A natural sort will emerge based on actual utilization.
, CASE WHEN ima.Index_Groom = 'REBUILD_OFFLINE' THEN 7 ELSE 1 END
FROM CAT.VM_0350_Index_Maintenance_Assessor AS ima
JOIN (
	SELECT REG_0205_ID, REG_Task_Name
	FROM CAT.REG_0205_Database_Maintenance_Properties 
	) AS job
ON job.REG_Task_Name = ima.Index_Groom

LEFT JOIN (
	SELECT TRK_FK_T2_ID
	, TRK_FK_0205_ID
	, SUM(TRK_Record_Count) AS SUM_Record_Count
	, AVG(DATEDIFF(millisecond, TRK_Post_Date, TRK_Term_Date)) AS AVG_Job_Duration_MS
	, AVG(DATEDIFF(millisecond, TRK_Post_Date, TRK_Term_Date)) / SUM(TRK_Record_Count) AS Job_RPMS
	FROM CAT.TRK_0205_DB_Maintenance_Job_Tracking
	GROUP BY TRK_FK_T2_ID, TRK_FK_0205_ID
) AS trk
ON trk.TRK_FK_T2_ID = ima.TRK_FK_T2_ID
AND trk.TRK_FK_0205_ID = job.REG_0205_ID


/* Log columns identified in need of data profiling. 
	Data profiling can be resource intensvie and should be run during low-use hours.
	This may also require the use of a libary process- TXT_String_Mapping.
		Default values as follows:
			-- LNK_Min_Exec_Time: A four hour window during non-use hours, starting at 2:00 AM.
			-- LNK_Max_Exec_Time: A four hour window during non-use hours, ending at 6:00 AM. 
			-- LNK_Term_Date: A profile request should only term when completed. These are durable, low-sensitivity requests.
			-- LNK_Day_Modulus: Execute the profile any available day.
*/

INSERT INTO CAT.LNK_0200_0205_Database_Maintenance_Links (LNK_FK_T2_ID, LNK_FK_T3_ID, LNK_FK_T4_ID, LNK_FK_0205_ID, LNK_Min_Exec_Time, LNK_Max_Exec_Time, LNK_Post_Date, LNK_Term_Date, LNK_Day_Modulus)

SELECT DISTINCT dpa.LNK_T2_ID, dpa.LNK_T3_ID, dpa.LNK_T4_ID, job.REG_0205_ID
, '02:00:00.000'
, '06:00:00.000'
, CAST(GETDATE() AS DATE)
, '12/31/2099'
, 1
FROM CAT.VM_0454_Data_Profile_Assessor AS dpa
JOIN (
	SELECT REG_0205_ID, REG_Task_Name
	FROM CAT.REG_0205_Database_Maintenance_Properties 
	) AS job
ON job.REG_Task_Name = 'DATA_PROFILE'
LEFT JOIN (
	SELECT TRK_FK_T4_ID
	, TRK_FK_0205_ID
	, SUM(TRK_Record_Count) AS SUM_Record_Count
	, AVG(DATEDIFF(millisecond, TRK_Post_Date, TRK_Term_Date)) AS AVG_Job_Duration_MS
	, AVG(DATEDIFF(millisecond, TRK_Post_Date, TRK_Term_Date)) / SUM(TRK_Record_Count) AS Job_RPMS
	FROM CAT.TRK_0205_DB_Maintenance_Job_Tracking
	GROUP BY TRK_FK_T4_ID, TRK_FK_0205_ID
) AS trk
ON trk.TRK_FK_T4_ID = dpa.LNK_T4_ID
AND trk.TRK_FK_0205_ID = job.REG_0205_ID