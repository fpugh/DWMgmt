

CREATE VIEW CAT.VH_0343_Index_Column_Latches
AS
WITH Sparse_Map (LNK_T2_ID, LNK_T3_ID, LNK_T4_ID
, REG_0100_ID, REG_0200_ID, REG_0204_ID, REG_0300_ID, REG_0400_ID
, REG_Server_Name, REG_Database_Name, REG_Schema_Name, REG_Object_Name, REG_Object_Type, REG_Column_Name, REG_Column_Type
, REG_Size, REG_Scale, Is_Identity, REG_Column_Rank)
AS (
	SELECT lsr.LNK_T2_ID, lsb.LNK_T3_ID, loc.LNK_T4_ID
	, lsr.LNK_FK_0100_ID, lsr.LNK_FK_0200_ID, lsb.LNK_FK_0204_ID, lsb.LNK_FK_0300_ID, loc.LNK_FK_0400_ID
	, srv.REG_Server_Name, rdr.REG_Database_Name, rds.REG_Schema_Name, ror.REG_Object_Name, ror.REG_Object_Type, rcr.REG_Column_Name, rcr.REG_Column_Type
	, rcp.REG_Size, rcp.REG_Scale, rcp.Is_Identity, loc.LNK_Rank AS REG_Column_Rank
	FROM CAT.LNK_0100_0200_Server_Databases AS lsr WITH(NOLOCK)
	JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb WITH(NOLOCK)
	ON lsb.LNK_FK_T2_ID = lsr.LNK_T2_ID
	JOIN CAT.LNK_0300_0400_Object_Column_Collection AS loc WITH(NOLOCK)
	ON loc.LNK_FK_T3_ID = lsb.LNK_T3_ID
	AND loc.LNK_FK_0300_ID = lsb.LNK_FK_0300_ID
	JOIN CAT.REG_0100_Server_Registry AS srv WITH(NOLOCK)
	ON srv.REG_0100_ID = lsr.LNK_FK_0100_ID
	JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
	ON rdr.REG_0200_ID = lsr.LNK_FK_0200_ID
	JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
	ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
	JOIN CAT.REG_0300_Object_Registry AS ror WITH(NOLOCK)
	ON ror.REG_0300_ID = lsb.LNK_FK_0300_ID
	JOIN CAT.REG_0400_Column_Registry AS rcr WITH(NOLOCK)
	ON rcr.REG_0400_ID =  loc.LNK_FK_0400_ID
	LEFT JOIN CAT.LNK_Tier4_Peers AS lt4 WITH(NOLOCK)
	ON lt4.LNK_FK_T4_ID = loc.LNK_T4_ID
	LEFT JOIN CAT.REG_0401_Column_Properties AS rcp WITH(NOLOCK)
	ON rcp.REG_0401_ID = lt4.LNK_FK_0401_ID
	)

SELECT DISTINCT DENSE_RANK() OVER(ORDER BY idx.LNK_T2_ID, lod.LNK_FK_T3R_ID, lod.LNK_FK_T3P_ID) as VID
, '['+prm.REG_Database_Name+'].['+prm.REG_Schema_Name+'].['+prm.REG_Object_Name+'].['+idx.REG_Object_Name+']' as Fully_Qualified_Name
, '['+prm.REG_Server_Name+'].['+prm.REG_Database_Name+']' AS Target_Database
, '['+prm.REG_Schema_Name+'].['+prm.REG_Object_Name+']' as Schema_Bound_Name
, idx.LNK_T2_ID
, prm.LNK_T3_ID as LNK_T3P_ID
, idx.LNK_T3_ID AS LNK_T3I_ID
, prm.LNK_T4_ID AS LNK_T4P_ID
, idx.REG_0100_ID
, idx.REG_0200_ID
, idx.REG_0204_ID
, prm.REG_0300_ID AS LNK_FK_0300_PRM_ID
, idx.REG_0300_ID AS LNK_FK_0300_IDX_ID
, prm.REG_0400_ID AS LNK_FK_0400_PRM_ID
, idx.REG_Server_Name
, idx.REG_Database_Name
, idx.REG_Schema_Name
, prm.REG_Object_Name
, prm.REG_Column_Name
, idx.REG_Column_Rank
, '['+idx.REG_Column_Name + '] [' + TYPE_NAME(idx.REG_Column_Type)
+ CASE WHEN idx.Is_Identity = 1 THEN '] IDENTITY' ELSE ']' END
+ CASE WHEN idx.REG_Column_Type IN (34,98,99,106,108,165,167,173,175,231,239,241,256)  THEN ' ('+CAST(idx.REG_Size AS nvarchar) + ')'
	WHEN idx.REG_Column_Type IN (106,108) THEN ' ('+CAST(idx.REG_Size AS nvarchar) + ',' + CAST(idx.REG_Scale as nvarchar)+')'
	ELSE '' END AS Column_Definition
, idx.REG_Column_Type
, idx.REG_Object_Name as REG_Index_Name
, idx.REG_Object_Type AS REG_Index_Type
, rcp.Is_Identity
, cdi.Is_Descending_Key
, cdi.Is_Included_Column
, CASE WHEN prm.REG_Schema_Name IN ('INFORMATION_SCHEMA','sys') THEN 1 ELSE 0 END AS Is_System_Meta
, lod.LNK_Post_Date
, lod.LNK_Term_Date
FROM CAT.LNK_0300_0300_Object_Dependencies as lod WITH(NOLOCK)
JOIN Sparse_Map AS idx
ON idx.LNK_T3_ID = lod.LNK_FK_T3P_ID
JOIN Sparse_Map AS prm
ON prm.LNK_T3_ID = lod.LNK_FK_T3R_ID
AND prm.REG_0400_ID = idx.REG_0400_ID
JOIN CAT.LNK_Tier4_Peers AS ltp4 WITH(NOLOCK)
ON ltp4.LNK_FK_T4_ID = idx.LNK_T4_ID
JOIN CAT.REG_0401_Column_Properties AS rcp WITH(NOLOCK)
ON rcp.REG_0401_ID = ltp4.LNK_FK_0401_ID
JOIN CAT.REG_0402_Column_Index_Details AS cdi WITH(NOLOCK)
ON cdi.REG_0402_ID = ltp4.LNK_FK_0402_ID
WHERE LNK_Latch_Type IN ('PK','UQ','CI','NC')