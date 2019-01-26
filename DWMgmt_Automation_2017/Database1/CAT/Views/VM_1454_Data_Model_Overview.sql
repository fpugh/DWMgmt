

CREATE VIEW CAT.VM_1454_Data_Model_Overview
AS
SELECT Tier_Anchor
, CASE WHEN Tier_Level = 0 THEN 'Server Summary'
	WHEN Tier_Level = 1 THEN 'Database Summary'
	WHEN Tier_Level = 2 THEN 'Schema Summary'
	WHEN Tier_Level = 3 THEN 'Object Summary'
	WHEN Tier_Level = 4 THEN 'Column Summary'
	END AS Summary_Level
, sub.Target_Name
, sub.DatabaseCount
, sub.Schema_Count
, sub.Object_Count
, sub.Column_Count
, sub.Percent_Content_Scanned
, sub.Scanned_Columns
, sub.AverageDensity
, sub.StdDevDensity
, sub.MaximumDensity
, sub.AverageUniqueness
, sub.StdDevUniqueness
FROM (
	SELECT 0 as Tier_Level
	, CAST(lsd.LNK_FK_0100_ID AS NVARCHAR) as Tier_Anchor
	, REG_Server_Name as Target_Name
	, COUNT(DISTINCT lsd.LNK_FK_0200_ID) as DatabaseCount
	, COUNT(DISTINCT lsb.LNK_FK_0204_ID) as Schema_Count
	, COUNT(DISTINCT lsb.LNK_FK_0300_ID) as Object_Count
	, COUNT(DISTINCT loc.LNK_FK_0400_ID) as Column_Count
	, COUNT(DISTINCT trk.TRK_FK_T4_ID) as Scanned_Columns
	, COUNT(DISTINCT trk.TRK_FK_T4_ID) / CAST(COUNT(DISTINCT loc.LNK_FK_0400_ID) as money) as Percent_Content_Scanned
	, AVG(trk.TRK_Density) as AverageDensity
	, STDEV(trk.TRK_Density) as StdDevDensity
	, MAX(trk.TRK_Density) as MaximumDensity
	, AVG(trk.TRK_Uniqueness) as AverageUniqueness
	, STDEV(trk.TRK_Uniqueness) as StdDevUniqueness
	FROM CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
	JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb WITH(NOLOCK)
	ON lsb.LNK_FK_T2_ID = lsd.LNK_T2_ID
	JOIN CAT.LNK_0300_0400_Object_Column_Collection AS loc WITH(NOLOCK)
	ON loc.LNK_FK_T3_ID = lsb.LNK_T3_ID
	JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
	ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
	JOIN CAt.REG_0300_Object_registry AS ror WITH(NOLOCK)
	ON ror.REG_Object_Type = 'U'
	AND ror.REG_0300_ID = lsb.LNK_FK_0300_ID
	LEFT JOIN CAT.TRK_0454_Column_Metrics AS trk
	ON loc.LNK_T4_ID = trk.TRK_FK_T4_ID
	GROUP BY lsd.LNK_FK_0100_ID, rsr.REG_Server_Name
	UNION
	SELECT 1 as Tier_Level
	, CAST(lsd.LNK_FK_0100_ID AS NVARCHAR)
	+'.'+ CAST(lsd.LNK_FK_0200_ID AS NVARCHAR) AS Tier_Anchor
	, rsr.REG_Server_Name
	+'.'+ rdr.REG_Database_Name as Target_Name
	, COUNT(DISTINCT lsd.LNK_FK_0200_ID) as DatabaseCount
	, COUNT(DISTINCT lsb.LNK_FK_0204_ID) as Schema_Count
	, COUNT(DISTINCT lsb.LNK_FK_0300_ID) as Object_Count
	, COUNT(DISTINCT loc.LNK_FK_0400_ID) as Column_Count
	, COUNT(DISTINCT trk.TRK_FK_T4_ID) as Scanned_Columns
	, COUNT(DISTINCT trk.TRK_FK_T4_ID) / CAST(COUNT(DISTINCT loc.LNK_FK_0400_ID) as money) as Percent_Content_Scanned
	, AVG(trk.TRK_Density) as AverageDensity
	, STDEV(trk.TRK_Density) as StdDevDensity
	, MAX(trk.TRK_Density) as MaximumDensity
	, AVG(trk.TRK_Uniqueness) as AverageUniqueness
	, STDEV(trk.TRK_Uniqueness) as StdDevUniqueness
	FROM CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
	JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb WITH(NOLOCK)
	ON lsb.LNK_FK_T2_ID = lsd.LNK_T2_ID
	JOIN CAT.LNK_0300_0400_Object_Column_Collection AS loc WITH(NOLOCK)
	ON loc.LNK_FK_T3_ID = lsb.LNK_T3_ID
	JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
	ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
	JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
	ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
	JOIN CAt.REG_0300_Object_registry AS ror WITH(NOLOCK)
	ON ror.REG_Object_Type = 'U'
	AND ror.REG_0300_ID = lsb.LNK_FK_0300_ID
	LEFT JOIN CAT.TRK_0454_Column_Metrics AS trk
	ON loc.LNK_T4_ID = trk.TRK_FK_T4_ID
	GROUP BY lsd.LNK_FK_0100_ID, rsr.REG_Server_Name
	, lsd.LNK_FK_0200_ID, rdr.REG_Database_Name
	UNION
	SELECT 2 as Tier_Level
	, CAST(lsd.LNK_FK_0100_ID as nvarchar)
	+'.'+ CAST(lsd.LNK_FK_0200_ID as nvarchar)
	+'.'+ CAST(lsb.LNK_FK_0204_ID as nvarchar) as Tier_Anchor
	, rsr.REG_Server_Name 
	+'.'+ rdr.REG_Database_Name
	+'.'+ rds.REG_Schema_Name as Target_Name
	, COUNT(DISTINCT lsd.LNK_FK_0200_ID) as DatabaseCount
	, COUNT(DISTINCT lsb.LNK_FK_0204_ID) as Schema_Count
	, COUNT(DISTINCT lsb.LNK_FK_0300_ID) as Object_Count
	, COUNT(DISTINCT loc.LNK_FK_0400_ID) as Column_Count
	, COUNT(DISTINCT trk.TRK_FK_T4_ID) as Scanned_Columns
	, COUNT(DISTINCT trk.TRK_FK_T4_ID) / CAST(COUNT(DISTINCT loc.LNK_FK_0400_ID) as money) as Percent_Content_Scanned
	, AVG(trk.TRK_Density) as AverageDensity
	, STDEV(trk.TRK_Density) as StdDevDensity
	, MAX(trk.TRK_Density) as MaximumDensity
	, AVG(trk.TRK_Uniqueness) as AverageUniqueness
	, STDEV(trk.TRK_Uniqueness) as StdDevUniqueness
	FROM CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
	JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb WITH(NOLOCK)
	ON lsb.LNK_FK_T2_ID = lsd.LNK_T2_ID
	JOIN CAT.LNK_0300_0400_Object_Column_Collection AS loc WITH(NOLOCK)
	ON loc.LNK_FK_T3_ID = lsb.LNK_T3_ID
	JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
	ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
	JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
	ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
	JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
	ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
	JOIN CAT.REG_0300_Object_registry AS ror WITH(NOLOCK)
	ON ror.REG_Object_Type = 'U'
	AND ror.REG_0300_ID = lsb.LNK_FK_0300_ID
	LEFT JOIN CAT.TRK_0454_Column_Metrics AS trk
	ON loc.LNK_T4_ID = trk.TRK_FK_T4_ID
	GROUP BY lsd.LNK_FK_0100_ID, rsr.REG_Server_Name
	, lsd.LNK_FK_0200_ID, rdr.REG_Database_Name
	, lsb.LNK_FK_0204_ID, rds.REG_Schema_Name
	UNION
	SELECT 3 as Tier_Level
	, CAST(lsd.LNK_FK_0100_ID as nvarchar)
	+'.'+ CAST(lsd.LNK_FK_0200_ID as nvarchar)
	+'.'+ CAST(lsb.LNK_FK_0204_ID as nvarchar) 
	+'.'+ CAST(lsb.LNK_FK_0300_ID as nvarchar) as Tier_Anchor
	, rsr.REG_Server_Name 
	+'.'+ rdr.REG_Database_Name
	+'.'+ rds.REG_Schema_Name
	+'.'+ ror.REG_Object_Name as Target_Name
	, COUNT(DISTINCT lsd.LNK_FK_0200_ID) as DatabaseCount
	, COUNT(DISTINCT lsb.LNK_FK_0204_ID) as Schema_Count
	, COUNT(DISTINCT lsb.LNK_FK_0300_ID) as Object_Count
	, COUNT(DISTINCT loc.LNK_FK_0400_ID) as Column_Count
	, COUNT(DISTINCT trk.TRK_FK_T4_ID) as Scanned_Columns
	, COUNT(DISTINCT trk.TRK_FK_T4_ID) / CAST(COUNT(DISTINCT loc.LNK_FK_0400_ID) as money) as Percent_Content_Scanned
	, AVG(trk.TRK_Density) as AverageDensity
	, STDEV(trk.TRK_Density) as StdDevDensity
	, MAX(trk.TRK_Density) as MaximumDensity
	, AVG(trk.TRK_Uniqueness) as AverageUniqueness
	, STDEV(trk.TRK_Uniqueness) as StdDevUniqueness
	FROM CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
	JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb WITH(NOLOCK)
	ON lsb.LNK_FK_T2_ID = lsd.LNK_T2_ID
	JOIN CAT.LNK_0300_0400_Object_Column_Collection AS loc WITH(NOLOCK)
	ON loc.LNK_FK_T3_ID = lsb.LNK_T3_ID
	JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
	ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
	JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
	ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
	JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
	ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
	JOIN CAt.REG_0300_Object_registry AS ror WITH(NOLOCK)
	ON ror.REG_Object_Type = 'U'
	AND ror.REG_0300_ID = lsb.LNK_FK_0300_ID
	LEFT JOIN CAT.TRK_0454_Column_Metrics AS trk
	ON loc.LNK_T4_ID = trk.TRK_FK_T4_ID
	GROUP BY lsd.LNK_FK_0100_ID, rsr.REG_Server_Name
	, lsd.LNK_FK_0200_ID, rdr.REG_Database_Name
	, lsb.LNK_FK_0204_ID, rds.REG_Schema_Name
	, lsb.LNK_FK_0300_ID, ror.REG_Object_Name
	UNION
	SELECT 4 as Tier_Level
	, CAST(lsd.LNK_FK_0100_ID as nvarchar)
	+'.'+ CAST(lsd.LNK_FK_0200_ID as nvarchar)
	+'.'+ CAST(lsb.LNK_FK_0204_ID as nvarchar) 
	+'.'+ CAST(lsb.LNK_FK_0300_ID as nvarchar)
	+'.'+ CAST(loc.LNK_FK_0400_ID as nvarchar) as Tier_Anchor
	, rsr.REG_Server_Name 
	+'.'+ rdr.REG_Database_Name
	+'.'+ rds.REG_Schema_Name
	+'.'+ ror.REG_Object_Name
	+'.'+ rcr.REG_Column_Name as Target_Name
	, COUNT(DISTINCT lsd.LNK_FK_0200_ID) as DatabaseCount
	, COUNT(DISTINCT lsb.LNK_FK_0204_ID) as Schema_Count
	, COUNT(DISTINCT lsb.LNK_FK_0300_ID) as Object_Count
	, COUNT(DISTINCT loc.LNK_FK_0400_ID) as Column_Count
	, COUNT(DISTINCT trk.TRK_FK_T4_ID) as Scanned_Columns
	, COUNT(DISTINCT trk.TRK_FK_T4_ID) / CAST(COUNT(DISTINCT loc.LNK_FK_0400_ID) as money) as Percent_Content_Scanned
	, AVG(trk.TRK_Density) as AverageDensity
	, STDEV(trk.TRK_Density) as StdDevDensity
	, MAX(trk.TRK_Density) as MaximumDensity
	, AVG(trk.TRK_Uniqueness) as AverageUniqueness
	, STDEV(trk.TRK_Uniqueness) as StdDevUniqueness
	FROM CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
	JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb WITH(NOLOCK)
	ON lsb.LNK_FK_T2_ID = lsd.LNK_T2_ID
	JOIN CAT.LNK_0300_0400_Object_Column_Collection AS loc WITH(NOLOCK)
	ON loc.LNK_FK_T3_ID = lsb.LNK_T3_ID
	JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
	ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
	JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
	ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
	JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
	ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
	JOIN CAT.REG_0300_Object_registry AS ror WITH(NOLOCK)
	ON ror.REG_Object_Type = 'U'
	AND ror.REG_0300_ID = lsb.LNK_FK_0300_ID
	JOIN CAT.REG_0400_Column_registry AS rcr
	ON rcr.REG_0400_ID = loc.LNK_FK_0400_ID
	LEFT JOIN CAT.TRK_0454_Column_Metrics AS trk
	ON loc.LNK_T4_ID = trk.TRK_FK_T4_ID
	GROUP BY lsd.LNK_FK_0100_ID, rsr.REG_Server_Name
	, lsd.LNK_FK_0200_ID, rdr.REG_Database_Name
	, lsb.LNK_FK_0204_ID, rds.REG_Schema_Name
	, lsb.LNK_FK_0300_ID, ror.REG_Object_Name
	, loc.LNK_FK_0400_ID, rcr.REG_Column_Name
	) AS sub