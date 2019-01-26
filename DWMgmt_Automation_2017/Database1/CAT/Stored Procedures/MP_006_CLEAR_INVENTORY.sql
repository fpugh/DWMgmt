

CREATE PROCEDURE [CAT].[MP_006_CLEAR_INVENTORY]
@ExecuteStatus tinyint = 2
, @SourceDBLocation NVARCHAR(65) = N'DWMgmt'

AS

DECLARE @SQL nvarchar(max)
, @ExecuteSQL nvarchar(500)

/* 20150916:4est 
	ToDo: Use a mechanism to auto-magically clear these out after use by process,
	or as regular scheduled maintenance trigger, job, or proc-call.
*/

SET @SQL = '
/* Truncate all tables in preparation for load */
TRUNCATE TABLE TMP.REG_0100_0200_Insert
TRUNCATE TABLE TMP.REG_0101_Insert
TRUNCATE TABLE TMP.REG_0102_Insert
TRUNCATE TABLE TMP.REG_0103_Insert
TRUNCATE TABLE TMP.REG_0201_Insert
TRUNCATE TABLE TMP.REG_0202_Insert
TRUNCATE TABLE TMP.REG_0203_Insert
TRUNCATE TABLE TMP.REG_0204_0300_Insert
TRUNCATE TABLE TMP.REG_0300_0300_Insert
TRUNCATE TABLE TMP.REG_0300_0401_Insert
TRUNCATE TABLE TMP.REG_0500_0501_Insert
TRUNCATE TABLE TMP.REG_0600_Insert
TRUNCATE TABLE TMP.REG_Index_Insert
TRUNCATE TABLE TMP.REG_Constraint_Insert
TRUNCATE TABLE TMP.REG_Foreign_Key_Insert
TRUNCATE TABLE TMP.REG_Trigger_Insert
TRUNCATE TABLE TMP.Database_Latch_Insert
TRUNCATE TABLE TMP.Object_Latch_Insert
TRUNCATE TABLE TMP.Column_Latch_Insert
TRUNCATE TABLE TMP.TRK_0300_Utiliztion_Insert
TRUNCATE TABLE TMP.TRK_0350_Index_Metric_Insert
'


IF @ExecuteStatus in (0,1)
BEGIN
	PRINT @SQl
END


IF @ExecuteStatus in (1,2)
BEGIN
	EXEC sp_executeSQL @SQL
END