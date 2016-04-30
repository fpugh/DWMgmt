USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0360_Object_Code_Reference]'))
DROP VIEW [CAT].[VI_0360_Object_Code_Reference]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0360_Object_Code_Reference]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [CAT].[VI_0360_Object_Code_Reference]
AS
SELECT dense_Rank() OVER(ORDER BY REG_Object_Name, loc.LNK_Rank) as VID
, lsd.LNK_T2_ID, lsd.LNK_FK_0100_ID, lsd.LNK_FK_0200_ID, lsb.LNK_T3_ID, lsb.LNK_FK_0204_ID, lsb.LNK_FK_0300_ID, loc.LNK_FK_0600_ID
, ror.REG_Object_Type, REG_Server_Name, REG_Database_Name, REG_Schema_Name, REG_Object_Name, loc.LNK_Rank as REG_Section_Rank, REG_Code_Content
FROM CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
JOIN CAT.LNK_0204_0300_Schema_binding AS lsb WITH(NOLOCK)
ON lsb.LNK_FK_T2_ID = lsd.LNK_T2_ID
AND GETDATE() BETWEEN lsb.LNK_Post_Date AND lsb.LNK_Term_Date
JOIN CAT.LNK_0300_0600_Object_Code_Sections AS loc WITH(NOLOCK)
ON loc.LNK_FK_T3_ID = lsb.LNK_T3_ID
AND GETDATE() BETWEEN loc.LNK_Post_Date AND loc.LNK_Term_Date
JOIN CAT.REG_0100_server_registry AS rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
JOIN CAT.REG_0200_Database_registry AS rdr WITH(NOLOCK)
ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
JOIN CAT.REG_0300_Object_registry AS ror WITH(NOLOCK)
ON ror.REG_0300_ID = loc.LNK_FK_0300_ID
JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
ON ocl.REG_0600_ID = loc.LNK_FK_0600_ID
' 
GO
