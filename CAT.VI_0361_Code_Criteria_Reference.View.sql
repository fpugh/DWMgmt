USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0361_Code_Criteria_Reference]'))
DROP VIEW [CAT].[VI_0361_Code_Criteria_Reference]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0361_Code_Criteria_Reference]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [CAT].[VI_0361_Code_Criteria_Reference]
AS
SELECT DENSE_Rank() OVER(ORDER BY ror.REG_Object_Name, LNK_Rank, crap.REG_0400_ID) as VID
, LNK_T2_ID
, rsr.REG_Server_Name+''.''+dbr.REG_Database_Name as Target_DB_Name
, LNK_T3_ID
, dbr.REG_Database_Name+''.''+dbs.REG_Schema_Name+''.''+ror.REG_Object_Name AS REG_Fully_Qualified_Name
, rsr.REG_0100_ID
, rsr.REG_Server_Name
, dbr.REG_0200_ID
, dbr.REG_Database_Name
, dbs.REG_0204_ID
, dbs.REG_Schema_Name
, ror.REG_0300_ID
, ror.REG_Object_Name
, ror.REG_Object_Type
, LNK_Rank as REG_Line_No
, crap.REG_0400_ID as REG_0400_Ref_ID
, crap.REG_Column_Name as Referenced_Column_Name
, REG_Code_Content
FROM CAT.LNK_0100_0200_Server_Databases AS srv WITH(NOLOCK)
JOIN CAT.LNK_0204_0300_Schema_Binding AS scm WITH(NOLOCK)
ON scm.LNK_FK_T2_ID = srv.LNK_T2_ID
JOIN CAT.LNK_0300_0600_Object_Code_Sections AS lnk
ON lnk.LNK_FK_T3_ID = scm.LNK_T3_ID
JOIN CAT.REG_0100_server_registry AS rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = srv.LNK_FK_0100_ID
JOIN CAT.REG_0200_Database_registry AS dbr WITH(NOLOCK)
ON dbr.REG_0200_ID = srv.LNK_FK_0200_ID
JOIN CAT.REG_0204_Database_Schemas AS dbs WITH(NOLOCK)
ON dbs.REG_0204_ID = scm.LNK_FK_0204_ID
JOIN CAT.REG_0300_Object_registry AS ror WITH(NOLOCK)
ON ror.REG_0300_ID = lnk.LNK_FK_0300_ID
JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
ON ocl.REG_0600_ID = lnk.LNK_FK_0600_ID
CROSS APPLY (
	SELECT REG_0400_ID, REG_Column_Name
	FROM CAT.REG_0400_Column_registry AS ror WITH(NOLOCK)
	) AS crap
WHERE GETDATE() BETWEEN lnk.LNK_Post_Date AND lnk.LNK_Term_Date
AND (CHARINDEX(''WHERE'', ocl.REG_Code_Content) > 0
OR CHARINDEX(''HAVING'', ocl.REG_Code_Content) > 0
OR CHARINDEX(''WHEN'', ocl.REG_Code_Content) > 0)
AND PATINDEX(''%''+crap.REG_Column_Name+''%'', ocl.REG_Code_Content) > 0
' 
GO
