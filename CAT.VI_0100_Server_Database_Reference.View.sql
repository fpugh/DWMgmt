USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0100_Server_Database_Reference]'))
DROP VIEW [CAT].[VI_0100_Server_Database_Reference]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0100_Server_Database_Reference]'))
EXEC dbo.sp_executesql @statement = N'


CREATE VIEW [CAT].[VI_0100_Server_Database_Reference]
AS
SELECT DENSE_Rank() OVER(ORDER BY lsd.LNK_T2_ID, lsd.LNK_FK_0100_ID, lsd.LNK_FK_0200_ID) as VID
, lsd.LNK_T2_ID
, lsd.LNK_FK_0100_ID
, lsd.LNK_FK_0200_ID
, rsr.REG_Server_Name
, rdr.REG_Database_Name
, ''[''+rsr.REG_Server_Name+''].[''+rdr.REG_Database_Name+'']'' as Target_Database
, rsr.REG_Product
, CASE WHEN rdr.REG_Compatibility = 80 THEN ''2000''
	WHEN rdr.REG_Compatibility = 90 THEN ''2005''
	WHEN rdr.REG_Compatibility = 100 THEN ''2008''
	WHEN rdr.REG_Compatibility = 110 THEN ''2012''
	WHEN rdr.REG_Compatibility = 120 THEN ''2014''
	WHEN rdr.REG_Compatibility = 130 THEN ''2016''
	ELSE ''UNKNOWN'' END AS REG_Compatibility
, rdr.REG_Collation
, rdr.REG_Recovery_Model
FROM CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
WHERE GETDATE() BETWEEN lsd.LNK_Post_Date AND lsd.LNK_Term_Date
OR CAST(lsd.LNK_Term_Date AS INT) = -1

' 
GO
