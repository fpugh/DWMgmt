

CREATE VIEW [CAT].[VI_Tier1_Full_Current]
AS
SELECT t1p.T1P_ID, t1p.LNK_FK_0100_ID, t1p.LNK_FK_0101_ID, t1p.LNK_FK_0102_ID, REG_Server_Name, REG_Product
, REG_Linked_Flag, REG_Remote_Login_Flag, REG_RPC_Out_Flag, REG_Data_Access_Flag, REG_Collation_Compatible, REG_Remote_Collation_Flag, REG_Collation_Name, REG_Connection_TO, REG_Query_TO, REG_System_Flag, REG_RPT_TPE_Flag
, REG_Lazy_Schema_Flag, REG_Publisher_Flag, REG_Subscriber_Flag, REG_Distributor_Flag, REG_NonSQL_Subcriber_Flag
, REG_Provider, REG_Data_Source, REG_Provider_String, REG_Catalog
, LNK_Post_Date, LNK_Term_Date
FROM CAT.LNK_Tier1_Peers AS t1p WITH(NOLOCK)
JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
ON t1p.LNK_FK_0100_ID = rsr.REG_0100_ID
JOIN CAT.REG_0101_Linked_Server_Settings AS lss WITH(NOLOCK)
ON t1p.LNK_FK_0101_ID = lss.REG_0101_ID
JOIN CAT.REG_0102_Publication_Replication_Server_Settings AS rss WITH(NOLOCK)
ON t1p.LNK_FK_0102_ID = rss.REG_0102_ID
LEFT JOIN CAT.REG_0103_Server_Providers AS rsp WITH(NOLOCK)
ON t1p.LNK_FK_0103_ID = rsp.REG_0103_ID
WHERE GETDATE() BETWEEN t1p.LNK_Post_Date AND ISNULL(t1p.LNK_Term_Date, GETDATE())