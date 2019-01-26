

CREATE VIEW CAT.VI_0361_Code_Object_Reference
AS
WITH ReferenceObjects (Schema_Bound_Name, Formal_Schema_Name, LNK_T3_ID, LNK_FK_0300_ID)
AS (
	SELECT DISTINCT Schema_Bound_Name+' '
	, '['+REG_Schema_Name+'].['+REG_Object_Name+']' as Formal_Schema_Name
	, LNK_T3_ID
	, LNK_FK_0300_ID
	FROM CAT.VI_0300_Full_Object_Map AS map WITH(NOLOCK)
	WHERE map.REG_Object_Type NOT IN ('C','D','F','CI','PK','UQ','NC','TR')
	AND REG_Schema_Name NOT IN ('sys','INFORMATION_SCHEMA')
	)

, SourceBits (REG_0600_ID, REG_Code_Content)
AS (
	SELECT REG_0600_ID, REG_Code_Content
	FROM CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
	WHERE 1=1
	AND (CONTAINS(REG_Code_Content, 'FROM')
		OR CONTAINS(REG_Code_Content, 'JOIN')
		OR CONTAINS(REG_Code_Content, 'INTO')
		OR CONTAINS(REG_Code_Content, 'APPLY')
		)
	)

SELECT DENSE_RANK() OVER(ORDER BY map.LNK_T2_ID, map.LNK_T3_ID, ocs.LNK_Rank) as VID
, map.Fully_Qualified_Name
, map.Target_Database
, map.Schema_Bound_Name

, map.LNK_T2_ID
, map.LNK_T3_ID as LNK_FK_T3P_ID
, map.LNK_FK_0300_ID as LNK_FK_0300_Prm_ID
, map.REG_Object_Type

, DENSE_RANK() OVER(PARTITION BY map.LNK_T3_ID ORDER BY ocs.LNK_Rank) as LNK_Rank
, dom.Schema_Bound_Name as Referenced_Object_Name
, dom.LNK_T3_ID as LNK_FK_T3R_ID
, dom.LNK_FK_0300_ID as LNK_FK_0300_Ref_ID
, dom.REG_0600_ID
, dom.REG_Code_Content
, CASE WHEN map.REG_Schema_Name IN ('INFORMATION_SCHEMA','sys') THEN 1 ELSE 0 END AS Is_System_Meta
FROM (
	SELECT LNK_T3_ID
	, LNK_FK_0300_ID
	, REG_0600_ID
	, Schema_Bound_Name
	, REG_Code_Content
	FROM SourceBits WITH(NOLOCK)
	CROSS APPLY ReferenceObjects WITH(NOLOCK)
	WHERE CHARINDEX(Schema_Bound_Name, REG_Code_Content) > 0

	UNION

	SELECT LNK_T3_ID
	, LNK_FK_0300_ID
	, REG_0600_ID
	, Formal_Schema_Name
	, REG_Code_Content
	FROM SourceBits WITH(NOLOCK)
	CROSS APPLY ReferenceObjects WITH(NOLOCK)
	WHERE CHARINDEX(Formal_Schema_Name, REG_Code_Content) > 0
	) AS dom

JOIN CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
ON ocs.LNK_FK_0600_ID = dom.REG_0600_ID

JOIN CAT.VI_0300_Full_Object_Map AS map WITH(NOLOCK)
ON map.LNK_T3_ID = ocs.LNK_FK_T3_ID