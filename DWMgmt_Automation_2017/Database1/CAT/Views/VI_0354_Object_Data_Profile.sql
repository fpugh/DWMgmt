

CREATE VIEW [CAT].[VI_0354_Object_Data_Profile]
AS
SELECT DENSE_RANK() OVER (ORDER BY lsd.LNK_T2_ID, lsb.LNK_T3_ID, occ.LNK_Rank, occ.LNK_T4_ID) as VID
, '['+rdr.REG_Database_Name+'].['+rds.REG_Schema_Name+'].['+ror.REG_Object_Name+']' AS Fully_Qualified_Name
, '['+rsr.REG_Server_Name+'].['+rdr.REG_Database_Name+']' AS Target_Database
, '['+rds.REG_Schema_Name+'].['+ror.REG_Object_Name+']' AS Schema_Bound_Name
, '['+rcr.REG_Column_Name + '] [' + Type_Name(rcr.REG_Column_Type)
+ CASE WHEN rcp.Is_Identity = 1 THEN '] IDENTITY' ELSE ']' END
+ CASE WHEN rcr.REG_Column_Type IN (34,98,99,106,108,165,167,173,175,231,239,241,256) AND rcp.REG_Size > -1 THEN ' ('+CAST(rcp.REG_Size AS NVARCHAR) + ')'
		WHEN rcr.REG_Column_Type IN (34,98,99,106,108,165,167,173,175,231,239,241,256) AND rcp.REG_Size = -1 THEN ' (MAX)'
		WHEN rcr.REG_Column_Type IN (106,108) THEN ' ('+ CAST(rcp.REG_Size AS NVARCHAR) + ',' + cast(rcp.REG_Scale AS NVARCHAR)+')'
	ELSE '' END AS Column_Definition
, lsd.LNK_T2_ID
, lsb.LNK_T3_ID
, occ.LNK_T4_ID
, rsr.REG_Server_Name
, rdr.REG_Database_Name
, rds.REG_Schema_Name
, ror.REG_Object_Name
, rcr.REG_Column_Name
, occ.LNK_Rank as REG_Column_Rank
, trk.TRK_Total_Values
, trk.TRK_Column_Nulls
, trk.TRK_Distinct_Values
, trk.TRK_Density
, trk.TRK_Uniqueness
, trk.TRK_Post_Date
FROM CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb WITH(NOLOCK)
ON lsb.LNK_FK_T2_ID = lsd.LNK_T2_ID
JOIN CAT.LNK_0300_0400_Object_Column_Collection AS occ WITH(NOLOCK)
ON occ.LNK_FK_T3_ID = lsb.LNK_T3_ID
AND GETDATE() BETWEEN occ.LNK_Post_Date AND occ.LNK_Term_Date
JOIN (
	SELECT sub.LNK_FK_T3_ID, trk.TRK_FK_T4_ID, trk.TRK_distinct_values
	, trk.TRK_Column_nulls, MAX(trk.TRK_total_values) as TRK_total_values
	, trk.TRK_density, trk.TRK_uniqueness, trk.TRK_Post_Date
	FROM CAT.TRK_0454_Column_Metrics AS trk WITH(NOLOCK)
	JOIN (
		SELECT occ.LNK_FK_T3_ID, trk.TRK_FK_T4_ID, MAX(TRK_Post_Date) as TRK_Post_Date
		FROM CAT.TRK_0454_Column_Metrics AS trk WITH(NOLOCK)
		JOIN CAT.LNK_0300_0400_Object_Column_Collection AS occ WITH(NOLOCK)
		ON occ.LNK_T4_ID = trk.TRK_FK_T4_ID
		GROUP BY occ.LNK_FK_T3_ID, trk.TRK_FK_T4_ID
		) AS sub
	ON sub.TRK_FK_T4_ID = trk.TRK_FK_T4_ID
	AND sub.TRK_Post_Date = trk.TRK_Post_Date
	GROUP BY sub.LNK_FK_T3_ID, trk.TRK_FK_T4_ID, trk.TRK_distinct_values
	, trk.TRK_Column_nulls, trk.TRK_density, trk.TRK_uniqueness, trk.TRK_Post_Date
	) AS trk
ON trk.LNK_FK_T3_ID = lsb.LNK_T3_ID
AND trk.TRK_FK_T4_ID = occ.LNK_T4_ID
AND trk.TRK_Post_Date BETWEEN lsb.LNK_Post_Date AND lsb.LNK_Term_Date
JOIN CAT.REG_0400_Column_registry AS rcr WITH(NOLOCK)
ON rcr.REG_0400_ID = occ.LNK_FK_0400_ID
JOIN CAT.REG_0300_Object_registry AS ror WITH(NOLOCK)
ON ror.REG_0300_ID = lsb.LNK_FK_0300_ID
JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
LEFT JOIN CAT.LNK_Tier4_Peers AS t4p WITH(NOLOCK)
ON t4p.LNK_FK_T4_ID = occ.LNK_T4_ID
LEFT JOIN CAT.REG_0401_Column_properties AS rcp WITH(NOLOCK)
ON rcp.REG_0401_ID = t4p.LNK_FK_0401_ID