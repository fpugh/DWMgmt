USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_004_GLOBAL_METRIC_CAPTURE_DRIVER]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[MP_004_GLOBAL_METRIC_CAPTURE_DRIVER]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_004_GLOBAL_METRIC_CAPTURE_DRIVER]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/* TODO: Amend this to dump base results into a TMP schema table to be
	loaded into the library during MP_003 processing. Revise MP_003 coding
	to refect the order of opperations change between scanning this data
	and loading to the catalogs */

CREATE PROCEDURE [CAT].[MP_004_GLOBAL_METRIC_CAPTURE_DRIVER]
@TargetDBLocation NVARCHAR(200) = N''master''
, @SourceDBLocation NVARCHAR(256) = N''DWMgmt''
, @ExecuteStatus TINYINT = 2

AS

IF @ExecuteStatus IN (0,2) SET NOCOUNT ON

DECLARE @SQL nvarchar(max)
, @SQL1 nvarchar(4000)
, @SQL2 nvarchar(4000)


/* These are fairly quick and can be processed with a regular scan (1st of day, or last of day - still avoid workday processing) */

SET @SQL1 = ''

; WITH DBCounts (Server_ID, Database_ID, Schema_ID, Object_ID)
AS (
	SELECT DISTINCT Server_ID, Database_ID, Schema_ID, cast(Object_ID as numeric(13,3))
	FROM ''+@SourceDBLocation+''.TMP.REG_0204_0300_Insert
	UNION ALL
	SELECT DISTINCT Server_ID, Database_ID, Schema_ID, cast(Key_Object_ID as numeric(13,3))
	FROM ''+@SourceDBLocation+''.TMP.REG_Foreign_Key_Insert
	UNION ALL
	SELECT DISTINCT Server_ID, Database_ID, Schema_ID, cast(Constraint_Object_ID as numeric(13,3))
	FROM ''+@SourceDBLocation+''.TMP.REG_Constraint_Insert
	UNION ALL
	SELECT DISTINCT Server_ID, Database_ID, Schema_ID, cast(Parent_Object_ID+(Index_Rank*.001) as numeric(13,3)) -- indexes require differentiation but share a similar Parent_ID
	FROM ''+@SourceDBLocation+''.TMP.REG_Index_Insert
   )

INSERT INTO ''+@SourceDBLocation+''.CAT.TRK_0203_Database_File_Changes (TRK_FK_0203_ID, TRK_Growth_Factor
, TRK_Max_Size, TRK_File_Size, TRK_File_Path, TRK_Schema_Count, TRK_Object_Count)

SELECT T2.REG_0203_ID, T2.Growth
, T2.Max_Size, T2.Size
, T2.physical_Name as File_path
, count(distinct T1.Schema_ID) as Schema_Count
, count(distinct T1.Object_ID) as Object_Count
FROM DBCounts AS T1
JOIN TMP.REG_0203_Insert AS T2
ON T2.Server_ID = T1.Server_ID
AND T2.Database_ID = T1.Database_ID
AND T2.type <> 1
GROUP BY T2.REG_0203_ID, T2.Growth
, T2.Max_Size, T2.Size, T2.physical_Name
''


SET @SQL2 = ''
INSERT INTO ''+@SourceDBLocation+''.CAT.TRK_0300_Object_Utiliztion_Metrics 
(TRK_FK_T2_ID, TRK_FK_T3_ID, TRK_Last_Action_Type, TRK_Last_Action_Date, Total_Seeks, Total_Scans, Total_Lookups, Total_Updates)

SELECT DISTINCT TMP.LNK_T2_ID, TMP.LNK_T3_ID,T1.action_Type, T1.action_Date
, T3.Total_Seeks, T3.Total_Scans, T3.Total_Lookups, T3.Total_Updates
FROM ''+@SourceDBLocation+''.TMP.REG_0204_0300_Insert AS tmp
JOIN LastActionZeroes AS t1
ON t1.Database_ID = TMP.Database_ID
AND t1.Object_ID = TMP.Object_ID
AND TMP.Object_Type = ''''u''''
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
	FROM ''+@TargetDBLocation+''.sys.dm_db_Index_usage_stats
	GROUP BY Database_ID, Object_ID
	) AS T3
ON T3.Database_ID = T1.Database_ID
AND T3.Object_ID = T1.Object_ID
''

IF @ExecuteStatus = (0)
BEGIN
	SELECT ''TRK_0203_Database_File_Changes'' AS SQL_Object_Name, @SQL1
	SELECT ''TRK_0300_Object_Utiliztion_Metrics'' AS SQL_Object_Name, @SQL2
END


IF @ExecuteStatus = (1)
BEGIN
	PRINT @SQL1
	PRINT @SQL2
END


IF @ExecuteStatus in (1,2)
BEGIN
	SET @SQL = cast(@SQL1 as nvarchar(max))+cast(@SQL2 as nvarchar(max))
	EXEC sp_executeSQL @SQL
END' 
END
GO
