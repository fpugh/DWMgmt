

CREATE VIEW CAT.VH_0360_Object_Code_Reference
AS
SELECT DENSE_RANK() OVER(ORDER BY lsd.LNK_T2_ID, lsb.LNK_T3_ID, loc.LNK_Rank) AS VID
, '['+rdr.REG_Database_Name+'].['+rds.REG_Schema_Name+'].['+ror.REG_Object_Name+']' AS Fully_Qualified_Name
, '['+rsr.REG_Server_Name+'].['+rdr.REG_Database_Name+']' AS Target_Database
, '['+rds.REG_Schema_Name+'].['+ror.REG_Object_Name+']' AS Schema_Bound_Name
, lsd.LNK_T2_ID
, lsb.LNK_T3_ID
, rsr.REG_0100_ID
, rdr.REG_0200_ID
, rds.REG_0204_ID
, ror.REG_0300_ID
, rsr.REG_Server_Name
, rdr.REG_Database_Name
, rds.REG_Schema_Name
, ror.REG_Object_Name
, ror.REG_Object_Type
, loc.LNK_Rank as REG_Line_No
, ocl.REG_Code_Content
, CASE WHEN rds.REG_Schema_Name IN ('INFORMATION_SCHEMA','sys') THEN 1 ELSE 0 END AS Is_System_Meta
, loc.LNK_Post_Date
, loc.LNK_Term_Date
FROM CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
JOIN CAT.LNK_0204_0300_Schema_binding AS lsb WITH(NOLOCK)
ON lsb.LNK_FK_T2_ID = lsd.LNK_T2_ID
JOIN CAT.LNK_0300_0600_Object_Code_Sections AS loc WITH(NOLOCK)
ON loc.LNK_FK_T3_ID = lsb.LNK_T3_ID
JOIN CAT.REG_0100_server_registry AS rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
JOIN CAT.REG_0300_Object_registry AS ror WITH(NOLOCK)
ON ror.REG_0300_ID = loc.LNK_FK_0300_ID
JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
ON ocl.REG_0600_ID = loc.LNK_FK_0600_ID