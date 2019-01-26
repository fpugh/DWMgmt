

CREATE VIEW CAT.VI_0350_Index_Integrity_Report
AS
SELECT DENSE_RANK() OVER(ORDER BY met1.TRK_FK_T2_ID, met1.TRK_FK_T3_OBJ_ID , met1.TRK_FK_T3_IDX_ID, met1.TRK_Index_Rank, met1.TRK_Index_Depth, met1.TRK_Index_Level) AS VID
, '['+rdr.REG_Database_Name+'].['+rds.REG_Schema_Name+'].['+roro.REG_Object_Name+'].['+rori.REG_Object_Name+']' as Fully_Qualified_Name
, '['+rsr.REG_Server_Name+'].['+rdr.REG_Database_Name+']' AS Target_Database
, '['+rds.REG_Schema_Name+'].['+roro.REG_Object_Name+'].['+rori.REG_Object_Name+']' as Schema_Bound_Name
, met1.TRK_FK_T2_ID
, met1.TRK_FK_T3_OBJ_ID 
, met1.TRK_FK_T3_IDX_ID
, rsr.REG_0100_ID
, rdr.REG_0200_ID
, rds.REG_0204_ID
, roro.REG_0300_ID as REG_0300_OBJ_ID
, rori.REG_0300_ID as REG_0300_IDX_ID
, rsr.REG_Server_Name
, rdr.REG_Database_Name
, rds.REG_Schema_Name
, roro.REG_Object_Name
, roro.REG_Object_Type
, rori.REG_Object_Name as Index_Name
, met1.TRK_Index_Rank
, met1.TRK_Index_Type_Desc
, met1.TRK_Alloc_Unit_Type_Desc
, met1.TRK_Partition_Number
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
, met1.TRK_Post_Date as Last_Scan_Date
FROM CAT.LNK_0300_0300_Object_Dependencies AS lod WITH(NOLOCK)
JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb WITH(NOLOCK)
ON lsb.LNK_T3_ID = lod.LNK_FK_T3P_ID
JOIN CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
ON lsd.LNK_T2_ID = lsb.LNK_FK_T2_ID
JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
JOIN CAT.REG_0300_Object_Registry AS roro WITH(NOLOCK)
ON RORO.REG_0300_ID = lod.LNK_FK_0300_Ref_ID
JOIN CAT.REG_0300_Object_Registry AS rori WITH(NOLOCK)
ON RORI.REG_0300_ID = lod.LNK_FK_0300_Prm_ID
JOIN (
	SELECT prm.TRK_FK_T2_ID
	,prm.TRK_FK_T3_OBJ_ID
	,prm.TRK_FK_T3_IDX_ID
	,prm.TRK_Post_Date
	,prm.TRK_Index_Rank
	,prm.TRK_Index_Type_Desc
	,prm.TRK_Alloc_Unit_Type_Desc
	,prm.TRK_Partition_Number
	,prm.TRK_Index_Depth
	,prm.TRK_Index_Level
	,prm.TRK_Page_Count
	,prm.TRK_Scanned_Record_Count
	,prm.TRK_Avg_Page_Space_Percent_Used
	,prm.TRK_Min_Record_Byte_Size
	,prm.TRK_Avg_Record_Byte_Size
	,prm.TRK_Max_Record_Byte_Size
	,prm.TRK_Fragment_Count
	,prm.TRK_Avg_Fragmentation_Percent
	,prm.TRK_Avg_Fragment_Page_Size
	FROM CAT.TRK_0350_Object_Index_Metrics as prm WITH(NOLOCK)
	JOIN (
		SELECT TRK_FK_T2_ID
		, TRK_FK_T3_OBJ_ID
		, TRK_FK_T3_IDX_ID
		, TRK_Index_Level
		, MAX(TRK_Post_Date) as TRK_Post_Date
		FROM CAT.TRK_0350_Object_Index_Metrics WITH(NOLOCK)
		GROUP BY TRK_FK_T2_ID, TRK_FK_T3_OBJ_ID, TRK_FK_T3_IDX_ID, TRK_Index_Level
		) AS sub
	ON sub.TRK_FK_T2_ID = prm.TRK_FK_T2_ID
	AND sub.TRK_FK_T3_OBJ_ID = prm.TRK_FK_T3_OBJ_ID
	AND sub.TRK_FK_T3_IDX_ID = prm.TRK_FK_T3_IDX_ID
	AND sub.TRK_Post_Date = prm.TRK_Post_Date
	) AS met1
ON met1.TRK_FK_T3_IDX_ID = LOD.LNK_FK_T3P_ID
AND LOD.LNK_Latch_Type IN ('PK','UQ','CI','NC')