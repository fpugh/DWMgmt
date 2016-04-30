USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0330_Object_Dependencies]'))
DROP VIEW [CAT].[VI_0330_Object_Dependencies]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0330_Object_Dependencies]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [CAT].[VI_0330_Object_Dependencies]
AS
SELECT DENSE_Rank() OVER(ORDER BY lat.LNK_Latch_Type, LNK_FK_T3P_ID, LNK_FK_T3R_ID) as VID
, LNK_Latch_Type
, LNK_FK_T3P_ID
, LNK_FK_0300_Prm_ID
, ''[''+rsrP.REG_Server_Name+'']'' as Primary_Server_Name
, ''[''+rdrP.REG_Database_Name+'']'' as Primary_Database_Name
, ''[''+rorP.REG_Object_Name+'']'' AS Primary_Object_Name
, ''[''+rdsP.REG_Schema_Name+''].[''+rorR.REG_Object_Name+''].[''+rorP.REG_Object_Name+'']'' as Primary_Schema_Bound_Name
, rorP.REG_Object_Type as Primary_Type
, LNK_FK_T3R_ID
, LNK_FK_0300_Ref_ID
, ''[''+rsrR.REG_Server_Name+'']'' as Referenced_Server_Name
, ''[''+rdrR.REG_Database_Name+'']'' as Referenced_Database_Name
, ''[''+rorR.REG_Object_Name+'']'' AS Referenced_Object_Name
, ''[''+rdsR.REG_Schema_Name+''].[''+rorR.REG_Object_Name+'']'' as Referenced_Schema_Bound_Name
, rorR.REG_Object_Type as Referenced_Type
FROM CAT.LNK_0300_0300_Object_Dependencies AS lat
JOIN CAT.LNK_0204_0300_Schema_binding AS lsbP WITH(NOLOCK)
ON lat.LNK_FK_T3P_ID = lsbP.LNK_T3_ID
AND GETDATE() BETWEEN lsbP.LNK_Post_Date AND lsbP.LNK_Term_Date
JOIN CAT.LNK_0100_0200_Server_Databases AS lsdP WITH(NOLOCK)
ON lsdP.LNK_T2_ID = lsbP.LNK_FK_T2_ID
AND GETDATE() BETWEEN lsdP.LNK_Post_Date AND lsdP.LNK_Term_Date
JOIN CAT.REG_0204_Database_Schemas AS RdsP
ON lsbP.LNK_FK_0204_ID = RdsP.REG_0204_ID
JOIN CAT.REG_0300_Object_registry AS RorP
ON lat.LNK_FK_0300_Prm_ID = RorP.REG_0300_ID
JOIN CAT.REG_0200_Database_Registry AS rdrP WITH(NOLOCK)
ON rdrP.REG_0200_ID = lsdP.LNK_FK_0200_ID
JOIN CAT.REG_0100_Server_Registry AS rsrP WITH(NOLOCK)
ON rsrP.REG_0100_ID = lsdP.LNK_FK_0100_ID
JOIN CAT.LNK_0204_0300_Schema_binding AS lsbR WITH(NOLOCK)
ON lat.LNK_FK_T3R_ID = lsbR.LNK_T3_ID
AND GETDATE() BETWEEN lsbR.LNK_Post_Date AND lsbR.LNK_Term_Date
JOIN CAT.LNK_0100_0200_Server_Databases AS lsdR WITH(NOLOCK)
ON lsdR.LNK_T2_ID = lsbR.LNK_FK_T2_ID
AND GETDATE() BETWEEN lsdR.LNK_Post_Date AND lsdR.LNK_Term_Date
JOIN CAT.REG_0204_Database_Schemas AS rdsR
ON lsbR.LNK_FK_0204_ID = rdsR.REG_0204_ID
JOIN CAT.REG_0300_Object_registry AS rorR
ON lat.LNK_FK_0300_Ref_ID = rorR.REG_0300_ID
JOIN CAT.REG_0200_Database_Registry AS rdrR WITH(NOLOCK)
ON rdrR.REG_0200_ID = lsdR.LNK_FK_0200_ID
JOIN CAT.REG_0100_Server_Registry AS rsrR WITH(NOLOCK)
ON rsrR.REG_0100_ID = lsdR.LNK_FK_0100_ID
WHERE getdate() BETWEEN lat.LNK_Post_Date AND lat.LNK_Term_Date
OR lat.LNK_Term_Date < 0
' 
GO
