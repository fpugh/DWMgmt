

CREATE VIEW [CAT].[VM_0207_Database_Backup_Assessor]

AS

/* Notes, Description, and Execution Instructions 

Note1: Last_Backup_Post_Date - This is the last time the database was backed up, or 1900-01-01 if it has no backup history.
	-- Backup history is obtained from CAT.TRK_0205_DB_Maintenance_Job_Tracking table, and 

Note2: Last_Update_Post_Date - This is the last time a write against the database was detected. It is important that new writes be committed as soon as possible.

Note3: Last_Backup_Date_Limit - The last time a database should have been backed up. A CASE statement allows the hierarchical logic to be applied in the
		HAVING inequality. Valid values are all the current date.
	3a: Any Database with a write detected newer than its last backup should be scheduled for at least and incremental backup, full if no backup at all exists.
	3b: Databases with FULL recovery models must be backed up every 7 days. Change this to a configured value once possible.
	3c: Databases with SIMPLE recovery models should be backed up every 30 days. Change this to a configured value once possible.
	3d: Databases of other types (Bulk Logged, Managed*, etc.) should be ignored.

Note4: Start case to determine FULL or INCREMENTAL backup type
	4a: When FULL and GETDATE() = Last_Backup_Post_Date + 7 then 'FULL' else 'INCREMENTAL'
	4b: When SIMPLE then FULL

Note5: Last_Backup_Date from LNK_0200_0205_Database_Maintenance_Links 
	5a: Only concerned about task 7,?;  Database backups (MP_007_DATABASE_BACKUP_OPPERATOR, and ? SSIS Package to be identified.)

Note6: Last change to LNK_0204_0300_Schema_Binding indicates the addition or deletion of a database object. Dates which terminate in the future are excluded

Note7: Last changes to dependant objects, or code.
	7a: Two most recent column changes from LNK_0300_0400_Object_Column_Collection
	7b: Object dependancy changes from LNK_0300_0300_Object_Dependencies
	7c: Database code changes from LNK_0300_0600_Object_Code_Sections

Note8: Last Updates in Database. Any update constitutes a write to the database to add, modify, or delete

	* Managed databases are a special DWMgmt internal classification for databases which have a 3rd party schedule or application managing backup schedules.
		This may be tracked by DWMgmt for security/comparison purposes, presenting an optimization or risk report.

*/

SELECT DENSE_RANK() OVER(ORDER BY sdr.LNK_T2_ID DESC) AS VID
, sdr.LNK_T2_ID
, sdr.REG_Server_Name
, sdr.REG_Database_Name
, sdr.Target_Database
, MAX(ISNULL(bak.TRK_Post_Date,0)) as Last_Backup_Date
, MAX(ISNULL(chg.TRK_Post_Date, 73048)) as Last_Change_Date
, CASE WHEN MAX(ISNULL(chg.TRK_Post_Date, 0)) > MAX(ISNULL(bak.TRK_Post_Date,0)) OR MAX(bak.TRK_Post_Date) IS NULL THEN GETDATE() -- Note3a
	ELSE CASE WHEN (sdr.REG_Recovery_Model IN ('FULL') AND MAX(ISNULL(bak.TRK_Post_Date,0)) < GETDATE() - 7)	-- Note3b
			OR (sdr.REG_Recovery_Model IN ('SIMPLE') AND MAX(ISNULL(bak.TRK_Post_Date,0)) < GETDATE() - 30) THEN GETDATE() -- Note3c
	ELSE -1 END END as Required_Backup_By
, DATEDIFF(dd, ISNULL(bak.TRK_Post_Date,0), GETDATE()) as Days_Since_Backup
, CASE WHEN (sdr.REG_Recovery_Model IN ('FULL') AND MAX(ISNULL(bak.TRK_Post_Date,0)) = GETDATE() - 7) OR sdr.REG_Recovery_Model IN ('SIMPLE') THEN 'FULL_BACKUP'
	ELSE 'DIFFERENTIAL_BACKUP' END as Backup_Type	-- Note4
FROM CAT.VI_0100_Server_Database_Reference AS sdr
LEFT JOIN CAT.TRK_0205_DB_Maintenance_Job_Tracking AS bak --Note5
ON sdr.LNK_T2_ID = bak.TRK_FK_T2_ID
AND bak.TRK_FK_0205_ID IN (7) AND bak.TRK_Status_Code = 0
LEFT JOIN (
	SELECT LNK_FK_T2_ID, MAX(LNK_Post_Date) as TRK_Post_Date
	FROM CAT.LNK_0204_0300_Schema_Binding	-- Note6
	GROUP BY LNK_FK_T2_ID
	UNION
	SELECT LNK_FK_T2_ID, MAX(LNK_Term_Date) as TRK_Post_Date
	FROM CAT.LNK_0204_0300_Schema_Binding WITH(NOLOCK)	-- Note6
	WHERE LNK_Term_Date < GETDATE()	-- Exclude Future Dates
	GROUP BY LNK_FK_T2_ID
	UNION
	SELECT LNK_FK_T2_ID, MAX(TRK_Post_Date) as Post_Date
	FROM CAT.LNK_0204_0300_Schema_Binding as lsb WITH(NOLOCK)	-- Note7
	JOIN (
		SELECT LNK_FK_T3_ID, MAX(LNK_Post_Date) as TRK_Post_Date
		FROM CAT.LNK_0300_0400_Object_Column_Collection WITH(NOLOCK)	-- Note7a
		GROUP BY LNK_FK_T3_ID
		UNION
		SELECT LNK_FK_T3_ID, MAX(LNK_Term_Date)
		FROM CAT.LNK_0300_0400_Object_Column_Collection WITH(NOLOCK)	-- Note7a
		WHERE LNK_Term_Date < GETDATE()
		GROUP BY LNK_FK_T3_ID
		UNION
		SELECT LNK_FK_T3P_ID, MAX(LNK_Post_Date)
		FROM CAT.LNK_0300_0300_Object_Dependencies WITH(NOLOCK)	-- Note7b
		GROUP BY LNK_FK_T3P_ID
		UNION
		SELECT LNK_FK_T3R_ID, MAX(LNK_Post_Date)
		FROM CAT.LNK_0300_0300_Object_Dependencies WITH(NOLOCK)	-- Note7b
		GROUP BY LNK_FK_T3R_ID
		UNION
		SELECT LNK_FK_T3P_ID, MAX(LNK_Term_Date)
		FROM CAT.LNK_0300_0300_Object_Dependencies WITH(NOLOCK)	-- Note7b
		WHERE LNK_Term_Date < GETDATE()
		GROUP BY LNK_FK_T3P_ID
		UNION
		SELECT LNK_FK_T3R_ID, MAX(LNK_Term_Date)
		FROM CAT.LNK_0300_0300_Object_Dependencies WITH(NOLOCK)	-- Note7b
		WHERE LNK_Term_Date < GETDATE()
		GROUP BY LNK_FK_T3R_ID
		UNION
		SELECT LNK_FK_T3_ID, MAX(LNK_Post_Date) as TRK_Post_Date
		FROM CAT.LNK_0300_0600_Object_Code_Sections WITH(NOLOCK)	-- Note7c
		GROUP BY LNK_FK_T3_ID
		UNION
		SELECT LNK_FK_T3_ID, MAX(LNK_Term_Date)
		FROM CAT.LNK_0300_0600_Object_Code_Sections WITH(NOLOCK)	-- Note7c
		WHERE LNK_Term_Date < GETDATE()	-- Exclude Future Dates
		GROUP BY LNK_FK_T3_ID
		) as sub
	ON sub.LNK_FK_T3_ID = lsb.LNK_T3_ID
	GROUP BY LNK_FK_T2_ID
	UNION
	SELECT TRK_FK_T2_ID, MAX(TRK_Post_Date) as TRK_Post_Date
	FROM CAT.TRK_0300_Object_Utiliztion_Metrics AS oum -- Note8
	WHERE oum.TRK_Last_Action_Type = 'last_user_update' 
	GROUP BY TRK_FK_T2_ID
) as chg
ON  chg.LNK_FK_T2_ID = sdr.LNK_T2_ID
WHERE sdr.LNK_T2_ID > 4
AND sdr.REG_Monitored = 1
--AND sdr.REG_Managed = 1  -- Leave this commented out until the management process is fully implemented.
GROUP BY sdr.Target_Database, sdr.REG_Server_Name, sdr.REG_Database_Name, sdr.REG_Recovery_Model
, sdr.LNK_T2_ID, sdr.LNK_FK_0100_ID, sdr.LNK_FK_0200_ID, bak.TRK_Post_Date
HAVING (MAX(ISNULL(bak.TRK_Post_Date,0)) <
	CASE WHEN MAX(ISNULL(chg.TRK_Post_Date, 0)) > MAX(ISNULL(bak.TRK_Post_Date,0)) OR MAX(bak.TRK_Post_Date) IS NULL THEN GETDATE() -- Note3a
		ELSE CASE WHEN (sdr.REG_Recovery_Model IN ('FULL') AND MAX(ISNULL(bak.TRK_Post_Date,0)) < GETDATE() - 7)	-- Note3b
			OR (sdr.REG_Recovery_Model IN ('SIMPLE') AND MAX(ISNULL(bak.TRK_Post_Date,0)) < GETDATE() - 30) THEN GETDATE() -- Note3c
			ELSE -1 END END
	OR MAX(ISNULL(chg.TRK_Post_Date, 73048)) >= MAX(ISNULL(bak.TRK_Post_Date,0)))
AND  DATEDIFF(dd, ISNULL(bak.TRK_Post_Date,0), GETDATE()) > 0