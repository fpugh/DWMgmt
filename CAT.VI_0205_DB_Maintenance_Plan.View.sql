USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0205_DB_Maintenance_Plan]'))
DROP VIEW [CAT].[VI_0205_DB_Maintenance_Plan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0205_DB_Maintenance_Plan]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [CAT].[VI_0205_DB_Maintenance_Plan]
AS
SELECT LNK_FK_0205_ID, REG_Task_Type, REG_Task_Name, REG_Database_Name, REG_Task_Desc
FROM [CAT].[LNK_0200_0205_Database_Maintenance_Links] AS ldm WITH(NOLOCK)
JOIN [CAT].[LNK_0100_0200_Server_Databases] AS lsd WITH(NOLOCK)
ON lsd.LNK_T2_ID = ldm.LNK_fk_T2_id
JOIN [CAT].[REG_0200_Database_Registry] AS rdr WITH(NOLOCK)
ON REG_0200_ID = lsd.LNK_FK_0200_ID
JOIN [CAT].[REG_0205_Database_Maintenance_Properties] AS rdm WITH(NOLOCK)
ON REG_0205_ID = ldm.LNK_FK_0205_ID
WHERE GETDATE() BETWEEN ldm.LNK_Post_Date and ldm.LNK_Term_Date

' 
GO
