USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0344_Constraint_Column_Latches]'))
DROP VIEW [CAT].[VI_0344_Constraint_Column_Latches]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0344_Constraint_Column_Latches]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [CAT].[VI_0344_Constraint_Column_Latches]
AS
WITH Sparse_Map (LNK_T2_ID, LNK_FK_0100_ID, REG_Server_Name, LNK_FK_0200_ID, REG_Database_Name
, LNK_T3_ID, LNK_FK_0204_ID, REG_Schema_Name, LNK_FK_0300_ID, REG_Object_Name, REG_Object_Type
, LNK_T4_ID, LNK_FK_0400_ID, REG_Column_Name, User_Data_Type, REG_Column_Rank)
AS (
	SELECT lsr.LNK_T2_ID
	, lsr.LNK_FK_0100_ID, srv.REG_Server_Name
	, lsr.LNK_FK_0200_ID, rdr.REG_Database_Name
	, lsb.LNK_T3_ID
	, lsb.LNK_FK_0204_ID, rds.REG_Schema_Name
	, lsb.LNK_FK_0300_ID, ror.REG_Object_Name, ror.REG_Object_Type
	, loc.LNK_T4_ID
	, loc.LNK_FK_0400_ID, rcr.REG_Column_Name, typ.name as User_Data_Type
	, loc.LNK_Rank as REG_Column_Rank
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
	JOIN CAT.REG_0400_Column_Registry AS rcr WITH(NOLOCK)
	ON rcr.REG_0400_ID =  loc.LNK_FK_0400_ID
	LEFT JOIN sys.types AS typ WITH(NOLOCK)
	ON typ.user_Type_ID = rcr.REG_Column_Type
	WHERE (lsr.LNK_Term_Date > GETDATE()
	OR lsr.LNK_Term_Date = CAST(-1 AS DATETIME))
	)

SELECT DISTINCT DENSE_RANK() OVER(ORDER BY con.LNK_T2_ID, lod.LNK_FK_T3R_ID, lod.LNK_FK_T3P_ID) as VID
, con.REG_Server_Name
, con.REG_Database_Name
, con.REG_Schema_Name
, prm.REG_Object_Name
, prm.REG_Column_Name
, prm.User_Data_Type
, con.REG_Object_Name as REG_Constraint_Name
, con.REG_Object_Type AS REG_Constraint_Type
, ocl.REG_Code_Content AS REG_Constraint_Definition
, con.LNK_T2_ID
, con.LNK_FK_0100_ID
, con.LNK_FK_0200_ID
, con.LNK_FK_0204_ID
, prm.LNK_T3_ID as LNK_T3P_ID
, prm.LNK_FK_0300_ID AS LNK_FK_0300_PRM_ID
, prm.LNK_T4_ID AS LNK_T4P_ID
, prm.LNK_FK_0400_ID AS LNK_FK_0400_PRM_ID
, con.LNK_T3_ID AS LNK_T3C_ID
, con.LNK_FK_0300_ID AS LNK_FK_0300_CON_ID
FROM CAT.LNK_0300_0300_Object_Dependencies as lod WITH(NOLOCK)
JOIN Sparse_Map AS con
ON con.LNK_T3_ID = lod.LNK_FK_T3P_ID
JOIN Sparse_Map AS prm
ON prm.LNK_T3_ID = lod.LNK_FK_T3R_ID
AND prm.LNK_FK_0400_ID = con.LNK_FK_0400_ID
LEFT JOIN CAT.LNK_0300_0600_Object_Code_Sections AS ocs
ON ocs.LNK_FK_T3_ID = con.LNK_T3_ID
AND (ocs.LNK_Term_Date > GETDATE()
OR ocs.LNK_Term_Date = CAST(-1 as datetime))
LEFT JOIN CAT.REG_0600_Object_Code_Library AS ocl
ON ocl.REG_0600_ID = ocs.LNK_FK_0600_ID
WHERE (lod.LNK_Term_Date > GETDATE()
OR lod.LNK_Term_Date = CAST(-1 as datetime))
AND LNK_Latch_Type IN (''D'',''C'')
' 
GO
