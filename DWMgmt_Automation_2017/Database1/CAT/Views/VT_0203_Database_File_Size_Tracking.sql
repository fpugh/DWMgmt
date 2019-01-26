

CREATE VIEW [CAT].[VT_0203_Database_File_Size_Tracking]
AS
SELECT DENSE_RANK() OVER(ORDER BY trk.TRK_File_Path) as VID
, rsr.REG_Server_Name+'.'+rdr.REG_Database_Name AS Target_Database
, t2p.LNK_FK_T2_ID
, rsr.REG_0100_ID
, rdr.REG_0200_ID
, rsr.REG_Server_Name
, rdr.REG_Database_Name
, trk.TRK_File_Path
, t2p.LNK_Post_Date
, t2p.LNK_Term_Date
, MIN(trk.TRK_File_Size) as min_File_Size_Size
, AVG(trk.TRK_File_Size) as avg_File_Size
, median.median_File_Size
, mode.mode_File_Size
, mode.mode_Record_Count
, MAX(trk.TRK_File_Size) as max_File_Size
, ISNULL(STDEV(trk.TRK_File_Size), 0) as stdev_File_Size
, COUNT(DISTINCT trk.TRK_File_Size) as CDE_File_Size
, last.TRK_File_Size as last_File_Size
, last.TRK_Growth_Factor as last_Growth_Factor
, COUNT(DISTINCT trk.TRK_Growth_Factor) as CDE_Growth_Factor
, last.TRK_Post_Date as last_Post_Date
, COUNT(DISTINCT trk.TRK_Post_Date) as Post_Count
, CONVERT(datetime, DATEADD(ms, DATEDIFF(ms, MIN(trk.TRK_Post_Date), MAX(trk.TRK_Post_Date)), 0)) as AGE_Post_Date
FROM CAT.TRK_0203_Database_File_Changes AS trk WITH(NOLOCK)
JOIN CAT.LNK_Tier2_Peers AS t2p WITH(NOLOCK)
ON trk.TRK_FK_0203_ID = t2p.LNK_FK_0203_ID
AND trk.TRK_Post_Date BETWEEN t2p.LNK_Post_Date AND t2p.LNK_Term_Date
JOIN CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
ON t2p.LNK_FK_T2_ID = lsd.LNK_T2_ID
JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
ON lsd.LNK_FK_0100_ID = rsr.REG_0100_ID
JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
ON lsd.LNK_FK_0200_ID = rdr.REG_0200_ID
LEFT JOIN (
	SELECT TRK_File_path,
	   AVG(TRK_File_Size) as median_File_Size
	FROM
	(
	   SELECT
		  TRK_File_path,
		  TRK_File_Size,
		  ROW_NUMBER() OVER (
			 PARTITION BY TRK_File_path 
			 ORDER BY TRK_File_Size ASC) AS RowAsc,
		  ROW_NUMBER() OVER (
			 PARTITION BY TRK_File_path 
			 ORDER BY TRK_File_Size DESC) AS RowDesc
	   FROM CAT.TRK_0203_Database_File_Changes AS dfc WITH(NOLOCK)
	) x
	WHERE 
	   RowAsc IN (RowDesc, RowDesc - 1, RowDesc + 1)
	GROUP BY TRK_File_path
	) AS median
ON median.TRK_File_Path = trk.TRK_File_Path
LEFT JOIN (
	SELECT src.TRK_File_Path, src.TRK_File_Size as mode_File_Size, src.Record_Count as mode_Record_Count
	, MIN_Post_Date, MAX_Post_Date
	FROM (
		SELECT dfc.TRK_File_Path, dfc.TRK_File_Size
		, min(dfc.TRK_Post_Date) as MIN_Post_Date
		, max(dfc.TRK_Post_Date) as MAX_Post_Date
		, count(*) as Record_Count
		FROM CAT.TRK_0203_Database_File_Changes AS dfc WITH(NOLOCK)
		GROUP BY dfc.TRK_File_Path, dfc.TRK_File_Size
		) AS src
	JOIN (
		SELECT sub1.TRK_File_Path, MAX(sub1.Record_Count) as Record_Count
		FROM (
			SELECT dfc.TRK_File_Path, dfc.TRK_File_Size, count(*) as Record_Count
			FROM CAT.TRK_0203_Database_File_Changes AS dfc WITH(NOLOCK)
			GROUP BY dfc.TRK_File_Path, dfc.TRK_File_Size
			) AS sub1
		GROUP BY sub1.TRK_File_Path
		) AS sub2
	ON sub2.TRK_File_Path = src.TRK_File_Path
	AND sub2.Record_Count = src.Record_Count
	) AS mode
ON mode.TRK_File_Path = trk.TRK_File_Path
LEFT JOIN (
	SELECT trk.TRK_File_Path, trk.TRK_File_Size, trk.TRK_Post_Date, trk.TRK_Growth_Factor
	FROM CAT.TRK_0203_Database_File_Changes AS trk WITH(NOLOCK)
	JOIN (
		SELECT dfc.TRK_File_Path, MAX(dfc.TRK_Post_Date) as TRK_Post_Date
		FROM CAT.TRK_0203_Database_File_Changes AS dfc WITH(NOLOCK)
		--WHERE dfc.TRK_Post_Date BETWEEN mode.MIN_Post_Date AND mode.MAX_Post_Date 
		GROUP BY dfc.TRK_File_Path
		) AS sub
	ON trk.TRK_File_Path = sub.TRK_File_Path
	AND trk.TRK_Post_Date = sub.TRK_Post_Date
	) AS last
ON last.TRK_File_Path = trk.TRK_File_Path

GROUP BY trk.TRK_File_path, median.median_File_Size
, mode.mode_File_Size, mode.mode_Record_Count
, last.TRK_File_Size, last.TRK_Post_Date, last.TRK_Growth_Factor
, t2p.LNK_FK_T2_ID, rsr.REG_0100_ID, rdr.REG_0200_ID
, rsr.REG_Server_Name, rdr.REG_Database_Name, t2p.LNK_Post_Date , t2p.LNK_Term_Date