USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0201_Schema_Inventory_Core]'))
DROP VIEW [CAT].[VI_0201_Schema_Inventory_Core]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0201_Schema_Inventory_Core]'))
EXEC dbo.sp_executesql @statement = N'



CREATE VIEW [CAT].[VI_0201_Schema_Inventory_Core]
AS
SELECT DENSE_Rank() OVER(ORDER BY lsd.LNK_T2_ID, rds.REG_Schema_Name, ror.REG_Object_Type, count(lsb.LNK_T3_ID)) as VID
, lsd.LNK_T2_ID, rsr.REG_Server_Name
, rdr.REG_Database_Name, rds.REG_Schema_Name, ror.REG_Object_Type
, COUNT(DISTINCT lsb.LNK_T3_ID) as Object_Count
, COUNT(DISTINCT occ.LNK_T4_ID) as Column_Count
FROM CAT.LNK_0300_0400_Object_Column_Collection AS occ WITH(NOLOCK)
JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb WITH(NOLOCK)
ON lsb.LNK_T3_ID = occ.LNK_FK_T3_ID
AND (GETDATE() BETWEEN occ.LNK_Post_Date AND occ.LNK_Term_Date
OR occ.LNK_Term_Date = cast(-1 as datetime))
AND (GETDATE() BETWEEN lsb.LNK_Post_Date AND lsb.LNK_Term_Date
OR lsb.LNK_Term_Date = cast(-1 as datetime))
JOIN CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
ON lsd.LNK_T2_ID = lsb.LNK_FK_T2_ID
AND (GETDATE() BETWEEN lsd.LNK_Post_Date AND lsd.LNK_Term_Date
OR lsd.LNK_Term_Date = cast(-1 as datetime))
JOIN CAT.REG_0300_Object_registry AS ror WITH(NOLOCK)
ON ror.REG_0300_ID = lsb.LNK_FK_0300_ID
JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
JOIN CAT.REG_0200_Database_registry AS rdr WITH(NOLOCK)
ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
JOIN CAT.REG_0100_server_registry AS rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
GROUP BY lsd.LNK_T2_ID, rsr.REG_Server_Name
, rdr.REG_Database_Name, rds.REG_Schema_Name, ror.REG_Object_Type


' 
GO
