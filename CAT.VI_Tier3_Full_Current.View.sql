USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_Tier3_Full_Current]'))
DROP VIEW [CAT].[VI_Tier3_Full_Current]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_Tier3_Full_Current]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [CAT].[VI_Tier3_Full_Current]
AS
SELECT lnk.T3P_ID, lnk.LNK_FK_T3_ID as LNK_T3_ID
, lnk.LNK_FK_0300_ID, lnk.LNK_FK_0301_ID, lnk.LNK_FK_0302_FK_ID, lnk.LNK_FK_0302_CD_ID
, reg1.REG_Object_Name, reg1.REG_Object_Type
, reg2.data_space_ID, reg2.fill_factor, reg2.Is_unique, reg2.ignore_dup_Key, reg2.Is_Primary_Key, reg2.Is_unique_constraint, reg2.Is_padded, reg2.Is_disabled, reg2.Is_hypothetical, reg2.Allow_Row_Locks, reg2.Allow_Page_Locks
, reg3.Is_ms_shipped as FK_Is_ms_shipped, reg3.Is_hypothetical as FK_Is_hypothetical, reg3.Is_Published as FK_Is_Published, reg3.Is_Schema_Published as FK_Is_Schema_Published, reg3.Is_disabled as FK_Is_disabled
, reg3.Is_not_trusted as FK_Is_not_trusted, reg3.Is_not_for_replication as FK_Is_not_for_replication, reg3.Is_System_Named as FK_Is_System_Named, reg3.delete_referential_action as FK_delete_referential_action
, reg3.update_referential_action as FK_update_referential_action, reg3.Key_Index_ID as FK_Key_Index_ID, reg3.principal_ID as FK_principal_ID
, reg4.Is_ms_shipped as cd_Is_ms_shipped, reg4.Is_Published as cd_Is_Published, reg4.Is_Schema_Published as cd_Is_Schema_Published, reg4.Is_System_Named as cd_Is_System_Named, reg4.Key_Index_ID as cd_Key_Index_ID
, lnk.LNK_Post_Date
FROM CAT.LNK_Tier3_Peers AS lnk WITH(NOLOCK)
JOIN CAT.REG_0300_Object_registry AS reg1 WITH(NOLOCK)
ON lnk.LNK_FK_0300_ID = reg1.REG_0300_ID
LEFT JOIN CAT.REG_0301_Index_details AS reg2 WITH(NOLOCK)
ON lnk.LNK_FK_0301_ID = reg2.REG_0301_ID
LEFT JOIN CAT.REG_0302_foreign_Key_details AS reg3 WITH(NOLOCK)
ON lnk.LNK_FK_0302_FK_ID = reg3.REG_0302_ID
LEFT JOIN CAT.REG_0302_foreign_Key_details AS reg4 WITH(NOLOCK)
ON lnk.LNK_FK_0302_CD_ID = reg3.REG_0302_ID
WHERE GETDATE() BETWEEN lnk.LNK_Post_Date AND lnk.LNK_Term_Date
' 
GO
