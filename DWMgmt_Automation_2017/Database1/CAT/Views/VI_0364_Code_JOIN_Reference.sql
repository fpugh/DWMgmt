

CREATE VIEW CAT.VI_0364_Code_JOIN_Reference

AS

WITH ReferenceObjects (Schema_Bound_Name, Formal_Schema_Name, LNK_T3_ID)
AS (
	SELECT DISTINCT Schema_Bound_Name
	, '['+REG_Schema_Name+'].['+REG_Object_Name+']' as Formal_Schema_Name
	, LNK_T3_ID
	FROM CAT.VI_0300_Full_Object_Map AS map WITH(NOLOCK)
	WHERE map.REG_Object_Type NOT IN ('C','D','F','CI','PK','UQ','NC','TR')
	AND REG_Schema_Name NOT IN ('sys','INFORMATION_SCHEMA')
	)

, SourceBits (REG_0600_ID, REG_Code_Content)
AS (
	SELECT REG_0600_ID, REG_Code_Content
	FROM CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
	WHERE 1=1
	AND CONTAINS(REG_Code_Content, 'JOIN')
	)

SELECT 'A' as Header,
 DENSE_RANK() OVER(ORDER BY lsd.LNK_T2_ID, lsb.LNK_T3_ID, ocs.LNK_Rank) as VID
, rdr.REG_Database_Name+'.'+rds.REG_Schema_Name+'.'+ror.REG_Object_Name AS Fully_Qualified_Name
, rsr.REG_Server_Name+'.'+rdr.REG_Database_Name AS Target_Database
, rds.REG_Schema_Name+'.'+ror.REG_Object_Name AS Schema_Bound_Name
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
, dom.LNK_T3_ID as LNK_T3_Ref_ID
, dom.Schema_Bound_Name as Referenced_Object_Name
, dom.REG_Code_Content
FROM (
	SELECT LNK_T3_ID
	, REG_0600_ID
	, Schema_Bound_Name
	, REG_Code_Content
	FROM SourceBits WITH(NOLOCK)
	CROSS APPLY ReferenceObjects WITH(NOLOCK)
	WHERE CHARINDEX(Schema_Bound_Name, REG_Code_Content) > 0

	UNION

	SELECT LNK_T3_ID
	, REG_0600_ID
	, Formal_Schema_Name
	, REG_Code_Content
	FROM SourceBits WITH(NOLOCK)
	CROSS APPLY ReferenceObjects WITH(NOLOCK)
	WHERE CHARINDEX(Formal_Schema_Name, REG_Code_Content) > 0
	) AS dom

JOIN CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
ON ocs.LNK_FK_0600_ID = dom.REG_0600_ID
--ON ocs.LNK_FK_T3_ID = dom.LNK_T3_ID

JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb WITH(NOLOCK)
ON lsb.LNK_T3_ID = ocs.LNK_FK_T3_ID

JOIN CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
ON lsd.LNK_T2_ID = lsb.LNK_FK_T2_ID

JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID

JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID

JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID

JOIN CAT.REG_0300_Object_Registry AS ror WITH(NOLOCK)
ON ror.REG_0300_ID = ocs.LNK_FK_0300_ID