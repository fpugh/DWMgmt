USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VH_Tier4_Full_Historic]'))
DROP VIEW [CAT].[VH_Tier4_Full_Historic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VH_Tier4_Full_Historic]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [CAT].[VH_Tier4_Full_Historic]
AS
SELECT lnk.T4P_ID
, lnk.LNK_FK_T4_ID AS LNK_T4_ID
, lat1.LNK_FK_0300_ID AS REG_0300_ID
, lnk.LNK_FK_0400_ID, lnk.LNK_FK_0401_ID
, lat1.LNK_Rank AS REG_Column_Rank
, reg1.REG_Column_Name
, Type_Name(reg1.REG_Column_Type) AS User_Column_Type
, reg2.Is_Identity
, reg2.Is_Default_Collation
, reg2.REG_Size, reg2.REG_Scale, reg2.Is_Nullable
FROM CAT.LNK_Tier4_Peers AS lnk WITH(NOLOCK)
JOIN CAT.REG_0400_Column_Registry AS reg1 WITH(NOLOCK)
ON reg1.REG_0400_ID = lnk.LNK_FK_0400_ID
JOIN CAT.REG_0401_Column_properties AS reg2 WITH(NOLOCK)
ON reg2.REG_0401_ID = lnk.LNK_FK_0401_ID
JOIN CAT.LNK_0300_0400_Object_Column_Collection AS lat1 WITH(NOLOCK)
ON reg1.REG_0400_ID = lat1.LNK_FK_0400_ID
AND lnk.LNK_FK_T4_ID = lat1.LNK_T4_ID
' 
GO
