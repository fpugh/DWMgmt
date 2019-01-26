

CREATE VIEW CAT.VI_0363_Code_Column_Reference
AS
WITH ReferenceColumns (Schema_Bound_Name, REG_Column_Name, Formal_Column_Name, LNK_FK_T3R_ID, LNK_T4_ID, LNK_FK_0300_ID, LNK_FK_0400_ID)
AS (
	SELECT DISTINCT Schema_Bound_Name
	, REG_Column_Name
	, '['+REG_Column_Name+']' as Formal_Column_Name
	, LNK_FK_T3R_ID
	, LNK_T4_ID
	, LNK_FK_0300_ID
	, LNK_FK_0400_ID
	FROM CAT.VI_0300_Full_Object_Map AS map WITH(NOLOCK)
	JOIN CAT.VI_0330_Object_Dependencies AS vod WITH(NOLOCK)
	ON vod.LNK_FK_T3R_ID = map.LNK_T3_ID
	)

, SourceBits (LNK_FK_T3_ID, REG_0600_ID, REG_Code_Content)
AS (
	SELECT LNK_FK_T3_ID, REG_0600_ID, REG_Code_Content
	FROM CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
	JOIN CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
	ON ocs.LNK_FK_0600_ID = ocl.REG_0600_ID
	WHERE 1=1
	)

SELECT DENSE_RANK() OVER(ORDER BY map.LNK_T2_ID, map.LNK_T3_ID, ocs.LNK_Rank) as VID
, map.Fully_Qualified_Name
, map.Target_Database
, map.Schema_Bound_Name

, map.LNK_T2_ID
, map.LNK_T3_ID as LNK_FK_T3P_ID
, map.LNK_FK_0300_ID as LNK_FK_0300_Prm_ID

, DENSE_RANK() OVER(PARTITION BY dom.LNK_FK_T3R_ID ORDER BY ocs.LNK_Rank) as LNK_Rank
, dom.Schema_Bound_Name as Referenced_Object_Name
, dom.REG_Column_Name as Referenced_Column_name
, dom.LNK_FK_T3R_ID
, dom.LNK_T4_ID as LNK_FK_T4R_ID
, dom.LNK_FK_0300_ID as LNK_FK_0300_Ref_ID
, dom.LNK_FK_0400_ID as LNK_FK_0400_Ref_ID
, dom.REG_0600_ID
, dom.REG_Code_Content
, CASE WHEN map.REG_Schema_Name IN ('INFORMATION_SCHEMA','sys') THEN 1 ELSE 0 END AS Is_System_Meta
FROM (
	SELECT Schema_Bound_Name
	, REG_Column_Name
	, LNK_FK_T3R_ID
	, LNK_T4_ID
	, LNK_FK_0300_ID
	, LNK_FK_0400_ID
	, REG_0600_ID
	, REG_Code_Content
	FROM SourceBits AS bits WITH(NOLOCK)
	CROSS APPLY ReferenceColumns AS crp WITH(NOLOCK)
	WHERE crp.LNK_FK_T3R_ID = bits.LNK_FK_T3_ID
	AND CHARINDEX(REG_Column_Name, REG_Code_Content) > 0

	UNION

	SELECT Schema_Bound_Name
	, Formal_Column_Name
	, LNK_FK_T3R_ID
	, LNK_T4_ID
	, LNK_FK_0300_ID
	, LNK_FK_0400_ID
	, REG_0600_ID
	, REG_Code_Content
	FROM SourceBits AS bits WITH(NOLOCK)
	CROSS APPLY ReferenceColumns AS crp WITH(NOLOCK)
	WHERE crp.LNK_FK_T3R_ID = bits.LNK_FK_T3_ID
	AND CHARINDEX(Formal_Column_Name, REG_Code_Content) > 0
	) AS dom

JOIN CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
ON ocs.LNK_FK_0600_ID = dom.REG_0600_ID

JOIN CAT.VI_0300_Full_Object_Map AS map WITH(NOLOCK)
ON map.LNK_T3_ID = ocs.LNK_FK_T3_ID
AND map.LNK_T3_ID != dom.LNK_FK_T3R_ID