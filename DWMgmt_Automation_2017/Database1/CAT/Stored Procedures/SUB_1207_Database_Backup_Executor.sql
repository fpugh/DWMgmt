

CREATE PROCEDURE [CAT].[SUB_1207_Database_Backup_Executor]
@ExecuteStatus TINYINT = 1

AS

/* ToDo:
	Upgrade the @BackupOption and @FileOption options to encorporate multiple-file, and mirroring options
	DiskOptions: File, FileGroup, (Multiple) Disk, Mirror to Disk
	BackupOptions: Stats, Description, Format, Password
*/

DECLARE @SQL NVARCHAR(MAX)
, @LNK_T2_ID INT
, @REG_0205_ID INT
, @TargetDBLocation NVARCHAR(256)
, @BackupPath NVARCHAR(1024)
, @BackupOption NVARCHAR(1024)
, @Punch_Time DATETIME

DECLARE BackupOperator CURSOR FOR
SELECT dml.LNK_FK_T2_ID, dml.LNK_FK_0205_ID
, sdr.REG_Database_Name
, REPLACE(REPLACE(REG_File_Location, '[@SimpleServerName]', REPLACE(REG_Server_Name, 'CORRUSCANT\','')), '[@TargetDBName]', sdr.REG_Database_Name)
, CASE WHEN REG_Task_Name = 'DIFFERENTIAL_BACKUP' THEN 'WITH DIFFERENTIAL' ELSE '' END
FROM CAT.LNK_0200_0205_Database_Maintenance_Links AS dml WITH(NOLOCK)
JOIN CAT.VI_0100_Server_Database_Reference AS sdr
ON dml.LNK_FK_T2_ID = sdr.LNK_T2_ID
JOIN CAT.REG_0205_Database_Maintenance_Properties AS dmp WITH(NOLOCK)
ON dmp.REG_0205_ID = dml.LNK_FK_0205_ID
AND dmp.REG_Task_Proc = 'SUB_1207_Database_Backup_Executor'
CROSS APPLY CAT.REG_0203_Database_files AS dbf
WHERE GETDATE() BETWEEN dml.LNK_Post_Date AND dml.LNK_Term_Date
AND dbf.REG_0203_ID = -1

OPEN BackupOperator

FETCH NEXT FROM BackupOperator
INTO @LNK_T2_ID, @REG_0205_ID, @TargetDBLocation, @BackupPath, @BackupOption

WHILE @@FETCH_STATUS = 0
BEGIN


SET @SQL = '
BACKUP DATABASE '+@TargetDBLocation+'
TO DISK = '''+@BackupPath+'''
'+@BackupOption+'
'


IF @ExecuteStatus IN (0,1,3)
BEGIN
	PRINT @SQL
END


IF @ExecuteStatus IN (1,2)
BEGIN

	SET @Punch_Time = GETDATE()

	BEGIN TRY
	
		EXEC sp_executeSQL @SQL
		
		INSERT INTO CAT.TRK_0205_DB_Maintenance_Job_Tracking (TRK_FK_T2_ID, TRK_FK_0205_ID, TRK_Status_Code, TRK_Post_Date, TRK_Term_Date)
		SELECT @LNK_T2_ID, @REG_0205_ID, 1, @Punch_Time, GETDATE()

	END TRY

	BEGIN CATCH

		IF @ExecuteStatus IN (0,1) PRINT 'ERROR: ' + ERROR_MESSAGE()

		INSERT INTO CAT.TRK_0205_DB_Maintenance_Job_Tracking (TRK_FK_T2_ID, TRK_FK_0205_ID, TRK_Status_Code, TRK_Post_Date, TRK_Term_Date)
		SELECT @LNK_T2_ID, @REG_0205_ID, 1, @Punch_Time, GETDATE()

		FETCH NEXT FROM BackupOperator
		INTO @LNK_T2_ID, @REG_0205_ID, @TargetDBLocation, @BackupPath, @BackupOption

		CONTINUE

	END CATCH

END

/* Update the link table outside of the execution timing so that TRK_0205_DB_Maintenance_Job_Tracking stays accurate */

UPDATE CAT.LNK_0200_0205_Database_Maintenance_Links SET LNK_Term_Date = @Punch_Time
WHERE LNK_FK_T2_ID = @LNK_T2_ID
AND LNK_FK_0205_ID = @REG_0205_ID

SET @SQL = ''

FETCH NEXT FROM BackupOperator
INTO @LNK_T2_ID, @REG_0205_ID, @TargetDBLocation, @BackupPath, @BackupOption

END

CLOSE BackupOperator
DEALLOCATE BackupOperator