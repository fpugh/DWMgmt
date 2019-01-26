

CREATE VIEW CAT.VI_0345_Foreign_Key_Column_Latches
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
	AND (lsb.LNK_Term_Date > GETDATE()
	OR lsb.LNK_Term_Date = CAST(-1 AS DATETIME))
	JOIN CAT.LNK_0300_0400_Object_Column_Collection AS loc WITH(NOLOCK)
	ON loc.LNK_FK_T3_ID = lsb.LNK_T3_ID
	AND loc.LNK_FK_0300_ID = lsb.LNK_FK_0300_ID
	AND (loc.LNK_Term_Date > GETDATE()
	OR loc.LNK_Term_Date = CAST(-1 AS DATETIME))
	JOIN CAT.REG_0100_Server_Registry AS srv WITH(NOLOCK)
	ON srv.REG_0100_ID = lsr.LNK_FK_0100_ID
	JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
	ON rdr.REG_0200_ID = lsr.LNK_FK_0200_ID
	JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
	ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
	JOIN CAT.REG_0300_Object_Registry AS ror WITH(NOLOCK)
	ON ror.REG_0300_ID = lsb.LNK_FK_0300_ID
	AND ror.REG_Object_Type IN ('U','F')
	JOIN CAT.REG_0400_Column_Registry AS rcr WITH(NOLOCK)
	ON rcr.REG_0400_ID =  loc.LNK_FK_0400_ID
	LEFT JOIN CAT.LNK_Tier4_Peers AS lt4 WITH(NOLOCK)
	ON lt4.LNK_FK_T4_ID = loc.LNK_T4_ID
	LEFT JOIN CAT.REG_0401_Column_Properties AS rcp WITH(NOLOCK)
	ON rcp.REG_0401_ID = lt4.LNK_FK_0401_ID
	WHERE (lsr.LNK_Term_Date > GETDATE()
	OR lsr.LNK_Term_Date = CAST(-1 AS DATETIME))
	)

SELECT DISTINCT DENSE_RANK() OVER(ORDER BY fky.LNK_T2_ID, lod.LNK_FK_T3R_ID, lod.LNK_FK_T3P_ID) AS VID
, '['+prm.REG_Database_Name+'].['+prm.REG_Schema_Name+'].['+prm.REG_Object_Name+'].['+fky.REG_Object_Name+']' AS Fully_Qualified_Name
, '['+prm.REG_Server_Name+'].['+prm.REG_Database_Name+']' as Target_Database
, '['+prm.REG_Schema_Name+'].['+prm.REG_Object_Name+']' as Schema_Bound_Name
, fky.LNK_T2_ID
, fky.LNK_T3_ID AS LNK_T3K_ID
, prm.LNK_T3_ID AS LNK_T3P_ID
, s1.LNK_T3R_ID
, prm.LNK_T4_ID AS LNK_T4P_ID
, s1.LNK_T4R_ID
, fky.REG_0100_ID AS REG_0100_KEY_ID
, fky.REG_0200_ID AS REG_0200_KEY_ID
, fky.REG_0204_ID AS REG_0204_KEY_ID
, fky.REG_0300_ID AS REG_0300_KEY_ID
, prm.REG_0300_ID AS REG_0300_PRM_ID
, s1.LNK_FK_0300_REF_ID AS REG_0300_REF_ID
, prm.REG_0400_ID AS REG_0400_PRM_ID
, s1.LNK_FK_0400_REF_ID AS REG_0400_REF_ID
, fky.REG_Server_Name
, fky.REG_Database_Name
, fky.REG_Schema_Name
, prm.REG_Object_Name AS Referencing_Object_Name
, prm.REG_Column_Name AS Referencing_Column_Name
, '['+prm.REG_Column_Name +'] ['+ TYPE_NAME(prm.REG_Column_Type)
+ CASE WHEN prm.Is_Identity = 1 THEN '] IDENTITY' ELSE ']' END
+ CASE WHEN prm.REG_Column_Type IN (34,98,99,106,108,165,167,173,175,231,239,241,256)  THEN ' ('+CAST(prm.REG_Size AS NVARCHAR) + ')'
	WHEN prm.REG_Column_Type IN (106,108) THEN ' ('+CAST(prm.REG_Size AS NVARCHAR) + ',' + CAST(prm.REG_Scale AS NVARCHAR)+')'
	ELSE '' END AS Referencing_Column_Definition
, fky.REG_Object_Name as REG_Foreign_Key_Name
, s1.REG_Object_Name AS Referenced_Object_Name
, s1.REG_Column_Name AS Referenced_Column_Name
, '['+s1.REG_Column_Name +'] ['+ TYPE_NAME(s1.REG_Column_Type)
+ CASE WHEN s1.Is_Identity = 1 THEN '] IDENTITY' ELSE ']' END
+ CASE WHEN s1.REG_Column_Type IN (34,98,99,106,108,165,167,173,175,231,239,241,256)  THEN ' ('+CAST(s1.REG_Size AS NVARCHAR) + ')'
	WHEN s1.REG_Column_Type IN (106,108) THEN ' ('+CAST(s1.REG_Size AS NVARCHAR) + ',' + CAST(s1.REG_Scale AS NVARCHAR)+')'
	ELSE '' END AS Referenced_Column_Definition
, CASE WHEN prm.REG_Schema_Name IN ('INFORMATION_SCHEMA','sys') THEN 1 ELSE 0 END AS Is_System_Meta
FROM CAT.LNK_0300_0300_Object_Dependencies AS lod WITH(NOLOCK)
JOIN Sparse_Map AS fky
ON fky.LNK_T3_ID = lod.LNK_FK_T3P_ID
JOIN Sparse_Map AS prm
ON prm.LNK_T3_ID = lod.LNK_FK_T3R_ID
AND prm.REG_0400_ID = fky.REG_0400_ID
AND lod.LNK_Rank = 1
JOIN (
	SELECT fky.LNK_T3_ID AS LNK_T3K_ID
	, ref.LNK_T3_ID AS LNK_T3R_ID
	, ref.REG_0300_ID AS LNK_FK_0300_REF_ID
	, ref.REG_Object_Name
	, ref.LNK_T4_ID AS LNK_T4R_ID
	, ref.REG_0400_ID AS LNK_FK_0400_REF_ID
	, ref.REG_Column_Name
	, ref.REG_Column_Type
	, ref.REG_Size
	, ref.REG_Scale
	, ref.Is_Identity
	FROM CAT.LNK_0300_0300_Object_Dependencies AS lod WITH(NOLOCK)
	JOIN Sparse_Map AS fky
	ON fky.LNK_T3_ID = lod.LNK_FK_T3P_ID
	JOIN Sparse_Map AS ref
	ON ref.LNK_T3_ID = lod.LNK_FK_T3R_ID
	AND ref.REG_0400_ID = fky.REG_0400_ID
	AND lod.LNK_Rank = 2
	) AS S1
ON S1.LNK_T3K_ID = fky.LNK_T3_ID
WHERE LNK_Latch_Type = 'F'
AND (lod.LNK_Term_Date > GETDATE()
OR lod.LNK_Term_Date = CAST(-1 AS DATETIME))