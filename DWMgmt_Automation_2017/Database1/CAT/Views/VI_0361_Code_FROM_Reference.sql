

CREATE VIEW CAT.[VI_0361_Code_FROM_Reference]
AS
SELECT DENSE_RANK() OVER(ORDER BY lsd.LNK_T2_ID, lsb.LNK_T3_ID, ocs.LNK_Rank, crap.REG_0300_ID) as VID
, rdr.REG_Database_Name+'.'+rds.REG_Schema_Name+'.'+ror.REG_Object_Name AS Fully_Qualified_Name
, rsr.REG_Server_Name+'.'+rdr.REG_Database_Name AS Target_Database
, rds.REG_Schema_Name+'.'+ror.REG_Object_Name as Schema_Bound_Name
, '['+rcr.REG_Column_Name+'] ['+TYPE_NAME(rcr.REG_Column_Type)
+ CASE WHEN rcp.Is_Identity = 1 THEN '] IDENTITY' ELSE ']' END
+ CASE WHEN rcr.REG_Column_Type IN (34,98,99,106,108,165,167,173,175,231,239,241,256)  THEN ' ('+CAST(rcp.REG_Size AS nvarchar) + ')'
	WHEN rcr.REG_Column_Type IN (106,108) THEN ' ('+CAST(rcp.REG_Size AS nvarchar) + ',' + CAST(rcp.REG_Scale as nvarchar)+')'
	ELSE '' END AS Column_Definition
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
, ocs.LNK_Rank as REG_Line_No
, '['+crap.REG_Column_Name + '] [' + TYPE_NAME(crap.REG_Column_Type)
+ CASE WHEN crap.Is_Identity = 1 THEN '] IDENTITY' ELSE ']' END
+ CASE WHEN crap.REG_Column_Type IN (34,98,99,106,108,165,167,173,175,231,239,241,256)  THEN ' ('+CAST(crap.REG_Size AS nvarchar) + ')'
	WHEN crap.REG_Column_Type IN (106,108) THEN ' ('+CAST(crap.REG_Size AS nvarchar) + ',' + CAST(crap.REG_Scale as nvarchar)+')'
	ELSE '' END AS Referenced_Column_Definition
, crap.REG_0300_ID as REG_0300_REF_ID
, crap.REG_0400_ID as REG_0400_REF_ID
, crap.REG_Object_Name as Referenced_Object_Name
, crap.REG_Column_Name as Referenced_Column_Name
, ocl.REG_Code_Content
FROM CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb WITH(NOLOCK)
ON lsb.LNK_FK_T2_ID = lsd.LNK_T2_ID
JOIN CAT.LNK_0300_0600_Object_Code_Sections AS ocs
ON ocs.LNK_FK_T3_ID = lsb.LNK_T3_ID
JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
JOIN CAT.REG_0300_Object_registry AS ror WITH(NOLOCK)
ON ror.REG_0300_ID = ocs.LNK_FK_0300_ID
JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
ON ocl.REG_0600_ID = ocs.LNK_FK_0600_ID
LEFT JOIN CAT.LNK_0300_0400_Object_Column_Collection AS occ WITH(NOLOCK)
ON occ.LNK_FK_T3_ID = lsb.LNK_T3_ID
LEFT JOIN CAT.LNK_Tier4_Peers AS t4p WITH(NOLOCK)
ON t4p.LNK_FK_T4_ID = occ.LNK_T4_ID
LEFT JOIN CAT.REG_0400_Column_Registry AS rcr WITH(NOLOCK)
ON rcr.REG_0400_ID = t4p.LNK_FK_0400_ID
LEFT JOIN CAT.REG_0401_Column_properties AS rcp WITH(NOLOCK)
ON rcp.REG_0401_ID = t4p.LNK_FK_0401_ID
CROSS APPLY (
	SELECT occ.LNK_FK_T3_ID, occ.LNK_T4_ID, ror.REG_0300_ID, rcr.REG_0400_ID
	, ror.REG_Object_Name, ror.REG_Object_Type
	, rcr.REG_Column_Name, rcr.REG_Column_Type
	, rcp.Is_Nullable, rcp.Is_Identity, rcp.REG_Size, rcp.REG_Scale
	FROM CAT.LNK_0300_0400_Object_Column_Collection AS occ WITH(NOLOCK)
	JOIN CAT.REG_0300_Object_Registry AS ror WITH(NOLOCK)
	ON occ.LNK_FK_0300_ID = ror.REG_0300_ID
	JOIN CAT.REG_0400_Column_registry AS rcr WITH(NOLOCK)
	ON occ.LNK_FK_0400_ID = rcr.REG_0400_ID
	LEFT JOIN CAT.LNK_Tier4_Peers AS t4p WITH(NOLOCK)
	ON t4p.LNK_FK_T4_ID = occ.LNK_T4_ID
	LEFT JOIN CAT.REG_0401_Column_properties AS rcp WITH(NOLOCK)
	ON rcp.REG_0401_ID = t4p.LNK_FK_0401_ID
	) AS crap
WHERE GETDATE() BETWEEN ocs.LNK_Post_Date AND ocs.LNK_Term_Date
AND (CHARINDEX('WHERE', ocl.REG_Code_Content) > 0
OR CHARINDEX('HAVING', ocl.REG_Code_Content) > 0
OR CHARINDEX('WHEN', ocl.REG_Code_Content) > 0)
AND PATINDEX('%'+crap.REG_Column_Name+'%', ocl.REG_Code_Content) > 0