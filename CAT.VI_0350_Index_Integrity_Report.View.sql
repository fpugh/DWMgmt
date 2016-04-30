USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0350_Index_Integrity_Report]'))
DROP VIEW [CAT].[VI_0350_Index_Integrity_Report]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0350_Index_Integrity_Report]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [CAT].[VI_0350_Index_Integrity_Report]
AS
SELECT DENSE_Rank() OVER(ORDER BY met1.TRK_FK_T2_ID, met1.TRK_FK_T3_OBJ_ID , met1.TRK_FK_T3_IDX_ID
, met1.TRK_Index_Rank, met1.TRK_Index_Depth, met1.TRK_Index_Level) AS VID
, met1.TRK_FK_T2_ID
, met1.TRK_FK_T3_OBJ_ID 
, met1.TRK_FK_T3_IDX_ID
, met1.TRK_Post_Date as Last_Scan_Date
, RSR.REG_Server_Name
, RDR.REG_Database_Name
, RDS.REG_Schema_Name 
+''.''+ RORO.REG_Object_Name AS Schema_Bound_Name
, RORI.REG_Object_Name AS Index_Name
, met1.TRK_Index_Rank
, met1.TRK_Index_Type_Desc
, met1.TRK_Alloc_Unit_Type_Desc
, met1.TRK_Index_Depth
, met1.TRK_Index_Level
, met1.TRK_Page_Count
, met1.TRK_Scanned_Record_Count
, met1.TRK_Avg_Page_Space_Percent_Used
, met1.TRK_Min_Record_Byte_Size
, met1.TRK_Avg_Record_Byte_Size
, met1.TRK_Max_Record_Byte_Size
, met1.TRK_Fragment_Count
, met1.TRK_Avg_Fragmentation_Percent
, met1.TRK_Avg_Fragment_Page_Size
FROM cat.LNK_0300_0300_Object_Dependencies AS LOD
JOIN CAT.LNK_0204_0300_Schema_Binding AS LSB
ON LSB.LNK_T3_ID = LOD.LNK_FK_T3P_ID
JOIN CAT.LNK_0100_0200_Server_Databases AS LSD
ON LSB.LNK_FK_T2_ID = LSD.LNK_T2_ID
JOIN CAT.REG_0100_Server_Registry AS RSR
ON RSR.REG_0100_ID = LSD.LNK_FK_0100_ID
JOIN CAT.REG_0200_Database_Registry AS RDR
ON RDR.REG_0200_ID = LSD.LNK_FK_0200_ID
JOIN CAT.REG_0204_Database_Schemas AS RDS
ON RDS.REG_0204_ID = LSB.LNK_FK_0204_ID
JOIN CAT.REG_0300_Object_registry AS RORO
ON RORO.REG_0300_ID = LOD.LNK_FK_0300_Ref_ID
JOIN CAT.REG_0300_Object_registry AS RORI
ON RORI.REG_0300_ID = LOD.LNK_FK_0300_Prm_ID
CROSS APPLY (
	SELECT prm.TRK_FK_T2_ID, prm.TRK_FK_T3_OBJ_ID, prm.TRK_FK_T3_IDX_ID, prm.TRK_Post_Date
	, prm.TRK_Index_Rank, prm.TRK_Index_Type_Desc, prm.TRK_Alloc_Unit_Type_Desc
	, prm.TRK_Index_Depth, prm.TRK_Index_Level, prm.TRK_Page_Count
	, prm.TRK_Scanned_Record_Count, prm.TRK_Avg_Page_Space_Percent_Used
	, prm.TRK_Min_Record_Byte_Size, prm.TRK_Avg_Record_Byte_Size
	, prm.TRK_Max_Record_Byte_Size, prm.TRK_Fragment_Count
	, prm.TRK_Avg_Fragmentation_Percent, prm.TRK_Avg_Fragment_Page_Size
	FROM CAT.TRK_0350_Object_Index_Metrics as prm WITH(NOLOCK)
	JOIN (
		SELECT TRK_FK_T2_ID, TRK_FK_T3_OBJ_ID, TRK_FK_T3_IDX_ID, max(TRK_Post_Date) as TRK_Post_Date
		FROM CAT.TRK_0350_Object_Index_Metrics WITH(NOLOCK)
		GROUP BY TRK_FK_T2_ID, TRK_FK_T3_OBJ_ID, TRK_FK_T3_IDX_ID
		) AS sub
	ON sub.TRK_FK_T2_ID = prm.TRK_FK_T2_ID
	AND sub.TRK_FK_T3_OBJ_ID = prm.TRK_FK_T3_OBJ_ID
	AND sub.TRK_FK_T3_IDX_ID = prm.TRK_FK_T3_IDX_ID
	AND sub.TRK_Post_Date = prm.TRK_Post_Date
	) AS met1
WHERE met1.TRK_FK_T3_IDX_ID = LOD.LNK_FK_T3P_ID
AND LOD.LNK_Latch_Type IN (''PK'',''UQ'',''CI'',''NC'')
' 
GO
