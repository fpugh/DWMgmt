

CREATE PROCEDURE [CAT].[MP_008_INDEX_MAINTENANCE_DRIVER]
@ExecuteStatus TINYINT = 1
, @ModeId TINYINT = 1

AS

DECLARE @SQL NVARCHAR(MAX) = ''
, @SQL3 NVARCHAR(4000) = ''


/* Prepare the base query for supplying the scheduled tasks, or for executing lightweight processes with live execution 
	on the top 25% of badly fragmented indexes (> 30% fragmentation), and not otherwise excluded
		** Exclusion lists should be managed by configuration in the LNK_0200_0205_Database_Maintenance_Links table. 20170318::4est	
*/


 DECLARE @LNK_T2_ID INT
 , @LNK_T3_ID INT
 , @REG_0205_ID INT
 , @Punch_Time DATETIME
 , @Index NVARCHAR(256)
 , @Object NVARCHAR(256)
 , @Operation NVARCHAR(65)


DECLARE IndexMaintainer CURSOR FOR
SELECT dml.LNK_FK_T2_ID, dml.LNK_FK_T3_ID, dml.LNK_FK_0205_ID
, map.REG_Index_Name, map.Fully_Qualified_Name
, CASE WHEN dmp.REG_Task_Name = 'REORGANIZE_ONLINE' THEN 'REORGANIZE'
	WHEN dmp.REG_Task_Name = 'REBUILD_ONLINE' THEN 'REBUILD WITH (ONLINE=ON)'
	ELSE 'REBUILD WITH (ONLINE=OFF)' END
FROM CAT.LNK_0200_0205_Database_Maintenance_Links AS dml WITH(NOLOCK)
JOIN CAT.VI_0100_Server_Database_Reference AS sdr
ON dml.LNK_FK_T2_ID = sdr.LNK_T2_ID
JOIN CAT.REG_0205_Database_Maintenance_Properties AS dmp WITH(NOLOCK)
ON dmp.REG_0205_ID = dml.LNK_FK_0205_ID
AND dmp.REG_Task_Proc = 'CAT.MP_008_INDEX_MAINTENANCE_DRIVER'
LEFT JOIN (
	SELECT DISTINCT LNK_T3P_ID, REG_Index_Name, REG_Index_Type, Fully_Qualified_Name
	FROM CAT.VI_0343_Index_Column_Latches
	) AS map
ON dml.LNK_FK_T3_ID = map.LNK_T3P_ID
ORDER BY REG_Index_Type


/* In this section the focus from the table on which the framgented indexes exist
	to the execution and performance of each index. Each item tracked to it's LNK_T3_ID origin via.
*/

OPEN IndexMaintainer

FETCH NEXT FROM IndexMaintainer
INTO @LNK_T2_ID, @LNK_T3_ID, @REG_0205_ID, @Index, @Object, @Operation

WHILE @@FETCH_STATUS = 0
BEGIN


SET @SQL3 = @SQL3 + '
ALTER INDEX '+ @Index +' ON '+ @Object +' '+ @Operation +''

IF @ExecuteStatus IN (0,1)
BEGIN
	PRINT @SQL3
END


IF @ExecuteStatus IN (1,2)
BEGIN

	SET @Punch_Time = GETDATE()

	BEGIN TRY

		EXEC sp_executesql @SQL3

		INSERT INTO CAT.TRK_0205_DB_Maintenance_Job_Tracking (TRK_FK_T2_ID, TRK_FK_T3_ID, TRK_FK_0205_ID, TRK_Status_Code, TRK_Post_Date, TRK_Term_Date)
		SELECT @LNK_T2_ID, @LNK_T3_ID, @REG_0205_ID, 0, @Punch_Time, GETDATE() 
		
	END TRY

	BEGIN CATCH
	 
		SELECT CASE WHEN @ExecuteStatus IN (0,1) THEN 'PRINT ''ERROR: '' + ERROR_MESSAGE()' ELSE '' END
		
		INSERT INTO CAT.TRK_0205_DB_Maintenance_Job_Tracking (TRK_FK_T2_ID, TRK_FK_T3_ID, TRK_FK_0205_ID, TRK_Status_Code, TRK_Post_Date, TRK_Term_Date)
		SELECT @LNK_T2_ID, @LNK_T3_ID, @REG_0205_ID, 1, @Punch_Time, GETDATE()

		FETCH NEXT FROM IndexMaintainer
		INTO @LNK_T2_ID, @LNK_T3_ID, @REG_0205_ID, @Index, @Object, @Operation

		CONTINUE

	END CATCH

END

SET @SQL3 = ''

FETCH NEXT FROM IndexMaintainer
INTO @LNK_T2_ID, @LNK_T3_ID, @REG_0205_ID, @Index, @Object, @Operation

END

CLOSE IndexMaintainer
DEALLOCATE IndexMaintainer