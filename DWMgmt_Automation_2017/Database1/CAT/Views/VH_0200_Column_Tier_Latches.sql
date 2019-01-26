

CREATE VIEW CAT.VH_0200_Column_Tier_Latches
AS
SELECT DENSE_Rank() OVER(ORDER BY lsr.LNK_T2_ID, lsb.LNK_T3_ID, occ.LNK_Rank, occ.LNK_Post_Date) AS VID
, '['+rdr.REG_Database_Name+'].['+rds.REG_Schema_Name+'].['+ror.REG_Object_Name+']' AS Fully_Qualified_Name
, '['+rsr.REG_Server_Name+'].['+rdr.REG_Database_Name+']' AS Target_Database
, '['+rds.REG_Schema_Name+'].['+ror.REG_Object_Name+']' AS Schema_Bound_Name
, '['+rcr.REG_Column_Name + '] [' + Type_Name(rcr.REG_Column_Type)
+ CASE WHEN rcp.Is_Identity = 1 THEN '] IDENTITY' ELSE ']' END
+ CASE WHEN rcr.REG_Column_Type IN (34,98,99,106,108,165,167,173,175,231,239,241,256)  THEN ' ('+CAST(rcp.REG_Size AS nvarchar) + ')'
	WHEN rcr.REG_Column_Type IN (106,108) THEN ' ('+CAST(rcp.REG_Size AS nvarchar) + ',' + cast(rcp.REG_Scale as nvarchar)+')'
	ELSE '' END AS Column_Definition
, lsr.LNK_T2_ID
, lsb.LNK_T3_ID
, occ.LNK_T4_ID
, lsr.LNK_FK_0100_ID
, lsr.LNK_FK_0200_ID
, lsb.LNK_FK_0204_ID
, lsb.LNK_FK_0300_ID
, occ.LNK_FK_0400_ID
, rsr.REG_Server_Name
, rdr.REG_Database_Name
, rds.REG_Schema_Name
, ror.REG_Object_Name
, ror.REG_Object_Type
, rcr.REG_Column_Name
, occ.LNK_Rank as REG_Column_Rank
, rcr.REG_Column_Type
, Type_Name(rcr.REG_Column_Type) AS Column_Type_Desc
, rcp.REG_Size
, rcp.REG_Scale
, rcp.Is_Identity
, occ.LNK_Post_Date
, occ.LNK_Term_Date
FROM CAT.LNK_0100_0200_Server_Databases as lsr WITH(NOLOCK)
JOIN CAT.LNK_0204_0300_Schema_Binding as lsb WITH(NOLOCK)
ON lsb.LNK_FK_T2_ID = lsr.LNK_T2_ID
JOIN CAT.LNK_0300_0400_Object_Column_Collection AS occ WITH(NOLOCK)
ON occ.LNK_FK_T3_ID = lsb.LNK_T3_ID
AND occ.LNK_FK_0300_ID = lsb.LNK_FK_0300_ID
JOIN CAT.LNK_Tier4_Peers AS t4p WITH(NOLOCK)
ON t4p.LNK_FK_T4_ID = occ.LNK_T4_ID
AND t4p.LNK_FK_0400_ID = occ.LNK_FK_0400_ID
JOIN CAT.REG_0100_server_registry AS rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = lsr.LNK_FK_0100_ID
JOIN CAT.REG_0200_Database_registry AS rdr WITH(NOLOCK)
ON rdr.REG_0200_ID = lsr.LNK_FK_0200_ID
JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
JOIN CAT.REG_0300_Object_registry AS ror WITH(NOLOCK)
ON ror.REG_0300_ID = lsb.LNK_FK_0300_ID
JOIN CAT.REG_0400_Column_registry AS rcr WITH(NOLOCK)
ON rcr.REG_0400_ID =  occ.LNK_FK_0400_ID
JOIN CAT.REG_0401_Column_properties AS rcp WITH(NOLOCK)
ON rcp.REG_0401_ID =  t4p.LNK_FK_0401_ID
WHERE ror.REG_Object_Type IN ('U','V','UT1','UT2','UT3')