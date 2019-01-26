

CREATE VIEW [CAT].[VI_0201_Schema_Inventory_Core]
AS
SELECT DENSE_RANK() OVER(ORDER BY lsb.LNK_FK_T2_ID, rds.REG_Schema_Name, ror.REG_Object_Type, COUNT(lsb.LNK_T3_ID)) as VID
, '['+rsr.REG_Server_Name+'].['+rdr.REG_Database_Name+']' AS Target_Database
, lsb.LNK_FK_T2_ID
, lsd.LNK_FK_0100_ID
, lsd.LNK_FK_0200_ID
, lsb.LNK_FK_0204_ID
, rsr.REG_Server_Name
, rdr.REG_Database_Name
, rds.REG_Schema_Name
, ror.REG_Object_Type
, COUNT(DISTINCT ror.REG_0300_ID) as Distinct_Objects
, COUNT(lsb.LNK_T3_ID) as Object_Count 
, MAX(lsb.LNK_Post_Date) as Recent_Post_Date
FROM CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb WITH(NOLOCK)
ON lsb.LNK_FK_T2_ID = lsd.LNK_T2_ID
AND lsb.LNK_Post_Date BETWEEN lsd.LNK_Post_Date AND lsd.LNK_Term_Date
JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
JOIN CAT.REG_0300_Object_Registry AS ror WITH(NOLOCK)
ON ror.REG_0300_ID = lsb.LNK_FK_0300_ID
GROUP BY lsb.LNK_FK_T2_ID, rsr.REG_Server_Name
, rdr.REG_Database_Name, rds.REG_Schema_Name, ror.REG_Object_Type
, lsd.LNK_FK_0100_ID, lsd.LNK_FK_0200_ID, lsb.LNK_FK_0204_ID