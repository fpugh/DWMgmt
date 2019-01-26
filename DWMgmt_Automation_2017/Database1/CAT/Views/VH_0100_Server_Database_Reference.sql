

CREATE VIEW [CAT].[VH_0100_Server_Database_Reference]
AS
SELECT DENSE_Rank() OVER(ORDER BY lsd.LNK_T2_ID, lsd.LNK_FK_0100_ID, lsd.LNK_FK_0200_ID) as VID
, '['+rsr.REG_Server_Name+'].['+rdr.REG_Database_Name+']' AS Target_Database
, lsd.LNK_T2_ID
, lsd.LNK_FK_0100_ID
, lsd.LNK_FK_0200_ID
, rsr.REG_Server_Name
, rdr.REG_Database_Name
, CASE WHEN rdr.REG_Compatibility = 80 THEN 'SQL Server 2000'
	WHEN rdr.REG_Compatibility = 90 THEN 'SQL Server 2005'
	WHEN rdr.REG_Compatibility = 100 THEN 'SQL Server 2008 (R2)'
	WHEN rdr.REG_Compatibility = 110 THEN 'SQL Server 2012'
	WHEN rdr.REG_Compatibility = 120 THEN 'SQL Server 2014'
	WHEN rdr.REG_Compatibility = 130 THEN 'SQL Server 2016'			
	ELSE 'UNKNOWN' END AS REG_Product
, rdr.REG_Collation
, rdr.REG_Recovery_Model
, rsr.REG_Monitored
, rdr.REG_Managed
, lsd.LNK_Post_Date
, lsd.LNK_Term_Date
FROM CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID