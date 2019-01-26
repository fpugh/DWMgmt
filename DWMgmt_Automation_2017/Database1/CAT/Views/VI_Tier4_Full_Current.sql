

CREATE VIEW CAT.VI_Tier4_Full_Current
AS
SELECT t4p.T4P_ID
, t4p.LNK_FK_T4_ID AS LNK_T4_ID
, occ.LNK_FK_0300_ID, t4p.LNK_FK_0400_ID, t4p.LNK_FK_0401_ID
, occ.LNK_Rank AS REG_Column_Rank
, rcr.REG_Column_Name
, TYPE_NAME(rcr.REG_Column_Type) AS Column_Type_Desc
, rcp.Is_Identity, rcp.Is_Default_Collation, rcp.REG_Size, rcp.REG_Scale, rcp.Is_Nullable
, t4p.LNK_Post_Date, t4p.LNK_Term_Date
FROM CAT.LNK_Tier4_Peers AS t4p WITH(NOLOCK)
JOIN CAT.REG_0400_Column_Registry AS rcr WITH(NOLOCK)
ON rcr.REG_0400_ID = t4p.LNK_FK_0400_ID
JOIN CAT.REG_0401_Column_properties AS rcp WITH(NOLOCK)
ON rcp.REG_0401_ID = t4p.LNK_FK_0401_ID
JOIN CAT.LNK_0300_0400_Object_Column_Collection AS occ WITH(NOLOCK)
ON rcr.REG_0400_ID = occ.LNK_FK_0400_ID
AND t4p.LNK_FK_T4_ID = occ.LNK_T4_ID
WHERE GETDATE() BETWEEN t4p.LNK_Post_Date AND t4p.LNK_Term_Date