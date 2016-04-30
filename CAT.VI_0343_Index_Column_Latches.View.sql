USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0343_Index_Column_Latches]'))
DROP VIEW [CAT].[VI_0343_Index_Column_Latches]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0343_Index_Column_Latches]'))
EXEC dbo.sp_executesql @statement = N'
/* Applied to Imperial Senate for testing */

CREATE VIEW [CAT].[VI_0343_Index_Column_Latches]
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
	, loc.LNK_Rank as Column_Rank
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

SELECT DISTINCT DENSE_RANK() OVER(ORDER BY idx.LNK_T2_ID, lod.LNK_FK_T3R_ID, lod.LNK_FK_T3P_ID, idx.LNK_T4_ID) as VID
, idx.REG_Server_Name
, idx.REG_Database_Name
, idx.REG_Schema_Name
, prm.REG_Object_Name
, idx.REG_Object_Name as REG_Index_Name
, idx.REG_Object_Type AS REG_Index_Type
, prm.REG_Column_Name
, cdi.Index_Column_ID
, prm.User_Data_Type
, rcp.Is_Identity
, cdi.Is_Descending_Key
, cdi.Is_Included_Column
, rid.Fill_Factor
, rid.Ignore_Dup_Key
, rid.Is_padded
, rid.Is_Primary_Key
, rid.Is_Unique
, rid.Is_Unique_Constraint
, rid.Filter_Definition
, idx.LNK_T2_ID
, idx.LNK_FK_0100_ID
, idx.LNK_FK_0200_ID
, idx.LNK_FK_0204_ID
, prm.LNK_T3_ID as LNK_T3P_ID
, prm.LNK_FK_0300_ID AS LNK_FK_0300_PRM_ID
, prm.LNK_T4_ID AS LNK_T4P_ID
, prm.LNK_FK_0400_ID AS LNK_FK_0400_PRM_ID
, idx.LNK_T3_ID AS LNK_T3I_ID
, idx.LNK_FK_0300_ID AS LNK_FK_0300_IDX_ID
FROM CAT.LNK_0300_0300_Object_Dependencies as lod WITH(NOLOCK)
JOIN CAT.LNK_Tier3_Peers AS ltp3 WITH(NOLOCK)
ON ltp3.LNK_FK_T3_ID = lod.LNK_FK_T3R_ID
AND (ltp3.LNK_Term_Date > GETDATE()
OR ltp3.LNK_Term_Date = CAST(-1 as datetime))
JOIN CAT.REG_0301_Index_Details AS rid WITH(NOLOCK)
ON rid.REG_0301_ID = ltp3.LNK_FK_0301_ID
JOIN Sparse_Map AS idx WITH(NOLOCK)
ON idx.LNK_T3_ID = lod.LNK_FK_T3P_ID
JOIN CAT.LNK_Tier4_Peers AS ltp4 WITH(NOLOCK)
ON ltp4.LNK_FK_T4_ID = idx.LNK_T4_ID
AND (ltp4.LNK_Term_Date > GETDATE()
OR ltp4.LNK_Term_Date = CAST(-1 as datetime))
JOIN CAT.REG_0401_Column_Properties AS rcp WITH(NOLOCK)
ON rcp.REG_0401_ID = ltp4.LNK_FK_0401_ID
JOIN CAT.REG_0402_Column_Index_Details AS cdi WITH(NOLOCK)
ON cdi.REG_0402_ID = ltp4.LNK_FK_0402_ID
JOIN Sparse_Map AS prm WITH(NOLOCK)
ON prm.LNK_T3_ID = lod.LNK_FK_T3R_ID
AND prm.LNK_FK_0400_ID = idx.LNK_FK_0400_ID
WHERE (lod.LNK_Term_Date > GETDATE()
OR lod.LNK_Term_Date = CAST(-1 as datetime))
AND lod.LNK_Latch_Type IN (''PK'',''UQ'',''CI'',''NC'')
' 
GO
