USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VH_Tier1_Full_Historic]'))
DROP VIEW [CAT].[VH_Tier1_Full_Historic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VH_Tier1_Full_Historic]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [CAT].[VH_Tier1_Full_Historic]
AS
SELECT lnk.T1P_ID, lnk.LNK_FK_0100_ID, lnk.LNK_FK_0101_ID, lnk.LNK_FK_0102_ID, REG_Server_Name, REG_Product
, REG_Linked_Flag, REG_Remote_Login_Flag, REG_RPC_Out_Flag, REG_Data_Access_Flag, REG_Collation_Compatible, REG_Remote_Collation_Flag, REG_Collation_Name, REG_Connection_TO, REG_Query_TO, REG_System_Flag, REG_RPT_TPE_Flag
, REG_Lazy_Schema_Flag, REG_Publisher_Flag, REG_Subscriber_Flag, REG_Distributor_Flag, REG_NonSQL_Subcriber_Flag
, REG_Provider, REG_Data_Source, REG_Provider_String, REG_Catalog
, LNK_Post_Date
FROM CAT.LNK_Tier1_Peers AS lnk WITH(NOLOCK)
JOIN [CAT].[REG_0100_server_registry] AS regI WITH(NOLOCK)
ON lnk.LNK_FK_0100_ID = regI.REG_0100_ID
JOIN [CAT].[REG_0101_linked_server_settings] AS regII WITH(NOLOCK)
ON lnk.LNK_FK_0101_ID = regII.REG_0101_ID
JOIN [CAT].[REG_0102_publication_replication_server_settings] AS regIII WITH(NOLOCK)
ON lnk.LNK_FK_0102_ID = regIII.REG_0102_ID
LEFT JOIN [CAT].[REG_0103_server_providers] AS regIV WITH(NOLOCK)
ON lnk.LNK_FK_0103_ID = regIV.REG_0103_ID
' 
GO
