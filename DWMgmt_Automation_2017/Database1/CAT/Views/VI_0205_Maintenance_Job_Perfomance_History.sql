

CREATE VIEW [CAT].[VI_0205_Maintenance_Job_Perfomance_History]
AS
SELECT dmp.REG_Task_Type, dmp.REG_Task_Name
, ctl.Target_Database
, CAST(djt.TRK_Post_Date AS DATE) as Post_Date
, DATEDIFF(MILLISECOND,djt.TRK_Post_Date, djt.TRK_Term_Date) as Duration
, djt.TRK_ID
FROM CAT.TRK_0205_DB_Maintenance_Job_Tracking AS djt
JOIN CAT.REG_0205_Database_Maintenance_Properties AS dmp
ON dmp.REG_0205_ID = djt.TRK_FK_0205_ID
JOIN (
	SELECT DISTINCT sdr.LNK_T2_ID, sdr.Target_Database
	FROM CAT.VH_0100_Server_Database_Reference as sdr
	) AS ctl
ON ctl.LNK_T2_ID = djt.TRK_FK_T2_ID