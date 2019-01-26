

CREATE VIEW [CAT].[VI_0101_Database_Compatibility_List]
AS
SELECT DISTINCT DENSE_RANK() OVER(ORDER BY rsr.REG_Server_Name, REG_Database_Name) AS VID
, '['+rsr.REG_Server_Name+'].['+rdr.REG_Database_Name+']' AS Target_Database
, lsd.LNK_T2_ID
, lsd.LNK_FK_0100_ID
, lsd.LNK_FK_0200_ID
, rsr.REG_Server_Name
, rdr.REG_Database_Name
, CASE WHEN rdr.REG_Compatibility = 80 THEN '2000'
	WHEN rdr.REG_Compatibility = 90 THEN '2005'
	WHEN rdr.REG_Compatibility = 100 THEN '2008'
	WHEN rdr.REG_Compatibility = 110 THEN '2012'
	ELSE '????' END AS Compatibility_Model
, rdr.REG_Collation
, rdr.REG_Recovery_Model
FROM CAT.LNK_0100_0200_Server_Databases as lsd WITH(NOLOCK)
JOIN CAT.REG_0100_server_registry as rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
JOIN CAT.REG_0200_Database_registry as rdr WITH(NOLOCK)
ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
WHERE GETDATE() BETWEEN lsd.LNK_Post_Date
AND ISNULL(lsd.LNK_Term_Date, GETDATE())