

CREATE VIEW CAT.VH_Tier3_Full_Historic
AS
SELECT t3p.T3P_ID, t3p.LNK_FK_T3_ID as LNK_T3_ID
, t3p.LNK_FK_0300_ID, t3p.LNK_FK_0301_ID, t3p.LNK_FK_0302_FK_ID, t3p.LNK_FK_0302_CD_ID
, ror.REG_Object_Name, ror.REG_Object_Type
, rid.data_space_ID, rid.fill_factor, rid.Is_unique, rid.ignore_dup_Key, rid.Is_Primary_Key, rid.Is_unique_constraint, rid.Is_padded, rid.Is_disabled, rid.Is_hypothetical, rid.Allow_Row_Locks, rid.Allow_Page_Locks
, fdky.Is_ms_shipped as FK_Is_ms_shipped, fdky.Is_hypothetical as FK_Is_hypothetical, fdky.Is_Published as FK_Is_Published, fdky.Is_Schema_Published as FK_Is_Schema_Published, fdky.Is_disabled as FK_Is_disabled
, fdky.Is_not_trusted as FK_Is_not_trusted, fdky.Is_not_for_replication as FK_Is_not_for_replication, fdky.Is_System_Named as FK_Is_System_Named, fdky.delete_referential_action as FK_delete_referential_action
, fdky.update_referential_action as FK_update_referential_action, fdky.Key_Index_ID as FK_Key_Index_ID, fdky.principal_ID as FK_principal_ID
, fdkr.Is_ms_shipped as cd_Is_ms_shipped, fdkr.Is_Published as cd_Is_Published, fdkr.Is_Schema_Published as cd_Is_Schema_Published, fdkr.Is_System_Named as cd_Is_System_Named, fdkr.Key_Index_ID as cd_Key_Index_ID
, t3p.LNK_Post_Date, t3p.LNK_Term_Date
FROM CAT.LNK_Tier3_Peers AS t3p WITH(NOLOCK)
JOIN CAT.REG_0300_Object_registry AS ror WITH(NOLOCK)
ON t3p.LNK_FK_0300_ID = ror.REG_0300_ID
LEFT JOIN CAT.REG_0301_Index_details AS rid WITH(NOLOCK)
ON t3p.LNK_FK_0301_ID = rid.REG_0301_ID
LEFT JOIN CAT.REG_0302_foreign_Key_details AS fdky WITH(NOLOCK)
ON t3p.LNK_FK_0302_FK_ID = fdky.REG_0302_ID
LEFT JOIN CAT.REG_0302_foreign_Key_details AS fdkr WITH(NOLOCK)
ON t3p.LNK_FK_0302_CD_ID = fdkr.REG_0302_ID