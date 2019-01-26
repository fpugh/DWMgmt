

CREATE PROCEDURE [CAT].[SUB_1300_Object_Utilization_Capture_and_Load]
@TargetDBLocation NVARCHAR(200) = N'master'
, @SourceDBLocation NVARCHAR(256) = N'DWMgmt'
, @ExecuteStatus TINYINT = 2

AS

IF @ExecuteStatus IN (0,2) SET NOCOUNT ON

DECLARE @SQL nvarchar(max)

/* These are fairly quick and can be processed with a regular scan (1st of day, or last of day - still avoid workday processing) */

SET @SQL = '
; WITH LastActionZeroes (database_id, object_id, action_type, action_weight, action_date)
AS (
	SELECT DISTINCT database_id, object_id
	, piv.Action_Type
	, CASE WHEN piv.Action_Type like ''%seek'' THEN 1
		WHEN piv.Action_Type like ''%scan'' THEN 2
		WHEN piv.Action_Type like ''%lookup'' THEN 3
		WHEN piv.Action_Type like ''%update'' THEN 4
		END AS Action_Weight
	, piv.Action_Date
	FROM ['+@TargetDBLocation+'].sys.dm_db_index_usage_stats
	UNPIVOT (Action_Date FOR Action_Type IN 
	(last_user_seek,last_user_scan,last_user_lookup,last_user_update
	,last_system_seek,last_system_scan,last_system_lookup,last_system_update)) AS piv
	)

INSERT INTO ['+@SourceDBLocation+'].CAT.TRK_0300_Object_Utiliztion_Metrics 
(TRK_FK_T2_ID, TRK_FK_T3_ID, TRK_Last_Action_Type, TRK_Last_Action_Date, Total_Seeks, Total_Scans, Total_Lookups, Total_Updates)

SELECT DISTINCT TMP.LNK_T2_ID, TMP.LNK_T3_ID,T1.action_Type, T1.action_Date
, T3.Total_Seeks, T3.Total_Scans, T3.Total_Lookups, T3.Total_Updates
FROM ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert AS tmp
JOIN LastActionZeroes AS t1
ON t1.Database_ID = TMP.Database_ID
AND t1.Object_ID = TMP.Object_ID
AND TMP.Object_Type = ''u''
JOIN (
	SELECT Database_ID
	, Object_ID, MAX(action_weight) as action_weight
	, MAX(Action_Date) as action_Date
	FROM LastActionZeroes
	GROUP BY Database_ID, Object_ID
	) AS T2
ON T2.action_weight = T1.action_weight
AND T2.Database_ID = T1.Database_ID
AND T2.Object_ID = T1.Object_ID
AND T2.action_Date = T1.action_Date
JOIN (
	SELECT Database_ID, Object_ID
	, SUM(user_seeks)+SUM(system_seeks) as Total_Seeks 
	, SUM(user_scans)+SUM(system_scans) as Total_Scans
	, SUM(user_lookups)+SUM(system_lookups) as Total_Lookups
	, SUM(user_updates)+SUM(system_updates) as Total_Updates
	FROM ['+@TargetDBLocation+'].sys.dm_db_Index_usage_stats
	GROUP BY Database_ID, Object_ID
	) AS T3
ON T3.Database_ID = T1.Database_ID
AND T3.Object_ID = T1.Object_ID
'

IF @ExecuteStatus = (0)
BEGIN
	SELECT 'TRK_0300_Object_Utiliztion_Metrics' AS SQL_Object_Name, @SQL
END


IF @ExecuteStatus = (1)
BEGIN
	PRINT @SQL
END


IF @ExecuteStatus in (1,2)
BEGIN
	EXEC sp_executeSQL @SQL
END