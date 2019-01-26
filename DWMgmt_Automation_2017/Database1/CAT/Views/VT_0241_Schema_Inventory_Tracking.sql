

CREATE VIEW [CAT].[VT_0241_Schema_Inventory_Tracking]
AS

WITH LastChages (Ordinal, LNK_T2_ID, LNK_Post_Date, TRK_Last_Object_Count)
AS (
	SELECT Ordinal, LNK_T2_ID, LNK_Post_Date, TRK_Last_Object_Count
	FROM (
		SELECT DENSE_RANK() OVER (PARTITION BY ctl.LNK_T2_ID ORDER BY ctl.LNK_Post_Date DESC) as Ordinal
		, ctl.LNK_T2_ID
		, ctl.LNK_Post_Date
		, COUNT(DISTINCT ctl.LNK_T3_ID) as TRK_Last_Object_Count
		FROM CAT.VH_0300_Full_Object_Map AS ctl WITH(NOLOCK)
		GROUP BY ctl.LNK_T2_ID
		, ctl.LNK_Post_Date
		) AS SUB
	WHERE Ordinal IN (1,2)
	)

SELECT DENSE_RANK() OVER(ORDER BY isnull(stdev(trk.Object_Count),0) DESC, max(trk.Object_Count) DESC) AS VID
, trk.REG_Server_Name+'.'+trk.REG_Database_Name as Target_Database
, trk.REG_Server_Name
, trk.REG_Database_Name
, trk.REG_Schema_Name
, trk.REG_Object_Type
, min(trk.Object_Count) as min_Object_Count
, avg(trk.Object_Count) as avg_Object_Count
, med.median_Object_Count
, max(trk.Object_Count) as max_Object_Count
, isnull(stdev(trk.Object_Count),0) as stdev_Object_Count
, max(trk.Recent_Post_Date) as Last_Post_Date

, CASE WHEN crap.LNK_Post_Date IS NULL OR crap.TRK_Last_Object_Count = lcv.TRK_Last_Object_Count THEN 0
	ELSE lcv.TRK_Last_Object_Count - crap.TRK_Last_Object_Count END AS Vector_Object_Count

FROM CAT.VI_0201_Schema_Inventory_Core AS trk WITH(NOLOCK)
JOIN (
	SELECT REG_Server_Name
	, REG_Database_Name
	, REG_Schema_Name
	, REG_Object_Type
	, AVG(Object_Count) as Median_Object_Count
	FROM (
		SELECT REG_Server_Name
		, REG_Database_Name
		, REG_Schema_Name
		, REG_Object_Type
		, Object_Count
		,	ROW_NUMBER() OVER (PARTITION BY REG_Server_Name, REG_Database_Name, REG_Schema_Name, REG_Object_Type ORDER BY Object_Count ASC) AS RowAsc
		,	ROW_NUMBER() OVER (PARTITION BY REG_Server_Name, REG_Database_Name, REG_Schema_Name, REG_Object_Type ORDER BY Object_Count DESC) AS RowDesc
		FROM CAT.VI_0201_Schema_Inventory_Core WITH(NOLOCK)
		) AS sub
	WHERE RowAsc IN (RowDesc, RowDesc - 1, RowDesc + 1)
	GROUP BY REG_Server_Name
	, REG_Database_Name
	, REG_Schema_Name
	, REG_Object_Type
	) AS med
ON med.REG_Server_Name = trk.REG_Server_Name
AND med.REG_Database_Name = trk.REG_Database_Name
AND med.REG_Schema_Name = trk.REG_Schema_Name
AND med.REG_Object_Type = trk.REG_Object_Type
JOIN LastChages AS lcv
ON lcv.LNK_T2_ID = trk.LNK_FK_T2_ID
AND lcv.Ordinal = 1
CROSS APPLY (
	SELECT LNK_T2_ID
	, LNK_Post_Date
	, TRK_Last_Object_Count
	FROM LastChages
	WHERE Ordinal = 2
) AS crap
WHERE crap.LNK_T2_ID = trk.LNK_FK_T2_ID
GROUP BY trk.REG_Server_Name
, trk.REG_Database_Name
, trk.REG_Schema_Name
, trk.REG_Object_Type
, med.median_Object_Count
, CASE WHEN crap.LNK_Post_Date IS NULL OR crap.TRK_Last_Object_Count = lcv.TRK_Last_Object_Count THEN 0
	ELSE lcv.TRK_Last_Object_Count - crap.TRK_Last_Object_Count END