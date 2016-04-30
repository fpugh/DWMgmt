USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VH_0100_Server_Database_Reference]'))
DROP VIEW [CAT].[VH_0100_Server_Database_Reference]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VH_0100_Server_Database_Reference]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [CAT].[VH_0100_Server_Database_Reference]
AS
SELECT DENSE_Rank() OVER(ORDER BY lsd.LNK_T2_ID, lsd.LNK_FK_0100_ID, lsd.LNK_FK_0200_ID) as VID
, lsd.LNK_T2_ID, rsr.REG_Server_Name+''.''+rdr.REG_Database_Name as Target_Database
, lsd.LNK_FK_0100_ID, rsr.REG_Server_Name
, lsd.LNK_FK_0200_ID, rdr.REG_Database_Name
, CASE WHEN rdr.REG_Compatibility = 80 THEN ''SQL Server 2000''
	WHEN rdr.REG_Compatibility = 90 THEN ''SQL Server 2005''
	WHEN rdr.REG_Compatibility = 100 THEN ''SQL Server 2008 (R2)''
	WHEN rdr.REG_Compatibility = 110 THEN ''SQL Server 2012''
	WHEN rdr.REG_Compatibility = 120 THEN ''SQL Server 2014''
	WHEN rdr.REG_Compatibility = 130 THEN ''SQL Server 2016''			
	ELSE ''UNKNOWN'' END AS REG_Product
, rdr.REG_Collation, rdr.REG_Recovery_Model
FROM CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
' 
GO
