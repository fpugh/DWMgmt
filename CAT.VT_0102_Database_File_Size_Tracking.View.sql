USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VT_0102_Database_File_Size_Tracking]'))
DROP VIEW [CAT].[VT_0102_Database_File_Size_Tracking]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VT_0102_Database_File_Size_Tracking]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [CAT].[VT_0102_Database_File_Size_Tracking]
AS
SELECT DENSE_RANK() OVER(ORDER BY trk.TRK_File_Path) as VID
, trk.TRK_File_Path, MIN(trk.TRK_File_Size) as min_File_Size_Size
, AVG(trk.TRK_File_Size) as avg_File_Size
, median.median_File_Size
, MAX(trk.TRK_File_Size) as max_File_Size
, ISNULL(STDEV(trk.TRK_File_Size), 0) as stdev_File_Size
, last.TRK_File_Size as last_File_Size
, last.TRK_Post_Date as last_Post_Date
, COUNT(DISTINCT trk.TRK_Post_Date) as Post_Count
FROM CAT.TRK_0203_Database_File_Changes AS trk WITH(NOLOCK)
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
	SELECT trk.TRK_File_Path, trk.TRK_File_Size, trk.TRK_Post_Date
	FROM CAT.TRK_0203_Database_File_Changes AS trk WITH(NOLOCK)
	JOIN (
		SELECT dfc.TRK_File_Path, MAX(dfc.TRK_Post_Date) as TRK_Post_Date
		FROM CAT.TRK_0203_Database_File_Changes AS dfc WITH(NOLOCK)
		GROUP BY dfc.TRK_File_Path
		) AS sub
	ON trk.TRK_File_Path = sub.TRK_File_Path
	AND trk.TRK_Post_Date = sub.TRK_Post_Date
	) AS last
ON last.TRK_File_Path = trk.TRK_File_Path
GROUP BY trk.TRK_File_path, median.median_File_Size
, last.TRK_File_Size, last.TRK_Post_Date
' 
GO
