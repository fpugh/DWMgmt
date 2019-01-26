

CREATE VIEW [CAT].[VT_0302_New_Objects_Last_Seven_Days]
AS
SELECT DENSE_RANK() OVER(ORDER BY LNK_T2_ID, LNK_T3_ID, REG_Object_Type) AS VID
, sub.Fully_Qualified_Name
, sub.Target_Database
, sub.Schema_Bound_Name
, sub.LNK_T2_ID
, sub.LNK_T3_ID
, sub.REG_0100_ID
, sub.REG_0200_ID
, sub.REG_0300_ID
, sub.REG_Server_Name
, sub.REG_Database_Name
, sub.REG_Schema_Name
, sub.REG_Object_Name
, sub.REG_Object_Type
, COUNT(*) as Incarnations
, MIN(LNK_Post_Date) as Inception
, AVG(Days_Life_Span) as Avg_Days_Life_Span
FROM (
	SELECT lsd.LNK_T2_ID, lsb.LNK_T3_ID
	, rsr.REG_0100_ID, rdr.REG_0200_ID, ror.REG_0300_ID
	, rsr.REG_Server_Name
	, rdr.REG_Database_Name
	, rsr.REG_Server_Name+'.'+rdr.REG_Database_Name AS Target_Database
	, rds.REG_Schema_Name
	, ror.REG_Object_Name
	, rds.REG_Schema_Name+'.'+ror.REG_Object_Name AS Schema_Bound_Name
	, rdr.REG_Database_Name+'.'+rds.REG_Schema_Name+'.'+ror.REG_Object_Name AS Fully_Qualified_Name
	, ror.REG_Object_Type
	, lsb.LNK_Post_Date
	, DATEDIFF("day", ror.REG_Create_Date, lsb.LNK_Term_Date) as Days_Life_Span
	FROM CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
	JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb WITH(NOLOCK)
	ON lsb.LNK_FK_T2_ID = lsd.LNK_T2_ID
	JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
	ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
	JOIN CAT.REG_0200_Database_registry AS rdr WITH(NOLOCK)
	ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
	JOIN CAT.REG_0204_Database_schemas AS rds WITH(NOLOCK)
	ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
	JOIN CAT.REG_0300_Object_registry AS ror WITH(NOLOCK)
	ON ror.REG_0300_ID = lsb.LNK_FK_0300_ID
	WHERE lsb.LNK_Post_Date between getdate() - 7 and getdate()
	AND lsb.LNK_Term_Date > getdate()
	AND rds.REG_Schema_Name NOT IN ('sys','INFORMATION_SCHEMA')
	) as sub
GROUP BY sub.LNK_T2_ID, sub.LNK_T3_ID, sub.REG_0100_ID
, sub.REG_0200_ID, sub.REG_0300_ID
, sub.REG_Server_Name, sub.REG_Database_Name
, sub.Target_Database, sub.REG_Schema_Name
, sub.REG_Object_Name, sub.Schema_Bound_Name
, sub.Fully_Qualified_Name, sub.REG_Object_Type