

CREATE VIEW CAT.VI_0330_Object_Dependencies
AS
SELECT DENSE_RANK() OVER(ORDER BY lat.LNK_Latch_Type, LNK_FK_T3P_ID, LNK_FK_T3R_ID) as VID
, LNK_Latch_Type
, LNK_FK_T3P_ID
, LNK_FK_T3R_ID
, LNK_FK_0300_Prm_ID
, LNK_FK_0300_Ref_ID
, LNK_Rank
, RegP.REG_Object_Name as Primary_Object_Name
, RegP.REG_Object_Type as Primary_Type
, RegD.REG_Object_Name as Referenced_Object_Name
, RegD.REG_Object_Type as Referenced_Type
FROM CAT.LNK_0300_0300_Object_Dependencies AS lat
JOIN CAT.REG_0300_Object_registry AS RegP
ON lat.LNK_FK_0300_Prm_ID = RegP.REG_0300_ID
JOIN CAT.REG_0300_Object_registry AS RegD
ON lat.LNK_FK_0300_Ref_ID = RegD.REG_0300_ID
WHERE getdate() BETWEEN LNK_Post_Date AND LNK_Term_Date
OR LNK_Term_Date < 0