

CREATE PROCEDURE [CAT].[SUB_0203_Database_File_Change_Capture_and_Load]
@TargetDBLocation NVARCHAR(200) = N'DWMgmt'
, @SourceDBLocation NVARCHAR(256) = N'DWMgmt'
, @ExecuteStatus TINYINT = 2

AS

IF @ExecuteStatus IN (0,2) SET NOCOUNT ON

DECLARE @SQL nvarchar(max)

/* These are fairly quick and can be processed with a regular scan (1st of day, or last of day - still avoid workday processing) */


SET @SQL = '

; WITH DBCounts (Server_ID, Database_ID, Schema_ID, Object_ID)
AS (
	SELECT DISTINCT Server_ID, Database_ID, Schema_ID, cast(Object_ID as numeric(13,3))
	FROM '+@TargetDBLocation+'.TMP.REG_0204_0300_Insert
	UNION ALL
	SELECT DISTINCT Server_ID, Database_ID, Schema_ID, cast(Key_Object_ID as numeric(13,3))
	FROM '+@TargetDBLocation+'.TMP.REG_Foreign_Key_Insert
	UNION ALL
	SELECT DISTINCT Server_ID, Database_ID, Schema_ID, cast(Constraint_Object_ID as numeric(13,3))
	FROM '+@TargetDBLocation+'.TMP.REG_Constraint_Insert
	UNION ALL
	SELECT DISTINCT Server_ID, Database_ID, Schema_ID, cast(Parent_Object_ID+(Index_Rank*.001) as numeric(13,3)) -- indexes require differentiation but share a similar Parent_ID
	FROM '+@TargetDBLocation+'.TMP.REG_Index_Insert
   )

INSERT INTO '+@SourceDBLocation+'.CAT.TRK_0203_Database_File_Changes (TRK_FK_0203_ID, TRK_Growth_Factor
, TRK_Max_Size, TRK_File_Size, TRK_File_Path, TRK_Schema_Count, TRK_Object_Count)

SELECT T2.REG_0203_ID, T2.Growth
, T2.Max_Size, T2.Size
, T2.physical_Name as File_path
, count(distinct T1.Schema_ID) as Schema_Count
, count(distinct T1.Object_ID) as Object_Count
FROM DBCounts AS T1
JOIN '+@SourceDBLocation+'.TMP.REG_0203_Insert AS T2
ON T2.Server_ID = T1.Server_ID
AND T2.Database_ID = T1.Database_ID
AND T2.type <> 1
GROUP BY T2.REG_0203_ID, T2.Growth
, T2.Max_Size, T2.Size, T2.physical_Name
'

IF @ExecuteStatus = (0)
BEGIN
	SELECT 'TRK_0203_Database_File_Changes' AS SQL_Object_Name, @SQL
END


IF @ExecuteStatus = (1)
BEGIN
	PRINT @SQL
END


IF @ExecuteStatus in (1,2)
BEGIN
	EXEC sp_executeSQL @SQL
END