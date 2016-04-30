USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VT_0241_Schema_Inventory_Tracking]'))
DROP VIEW [CAT].[VT_0241_Schema_Inventory_Tracking]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VT_0241_Schema_Inventory_Tracking]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [CAT].[VT_0241_Schema_Inventory_Tracking]
AS
SELECT DENSE_RANK() OVER(ORDER BY isnull(stdev(trk.Object_Count),0) DESC, max(trk.Object_Count) DESC) 
AS VID
, trk.REG_Server_Name, trk.REG_Database_Name, trk.REG_Schema_Name, trk.REG_Object_Type
, min(trk.Object_Count) as min_Object_Count
, avg(trk.Object_Count) as avg_Object_Count
, med.median_Object_Count
, max(trk.Object_Count) as max_Object_Count
, isnull(stdev(trk.Object_Count),0) as stdev_Object_Count
, max(trk.LNK_Post_Date) as Last_Post_Date
FROM CAT.VI_0201_Schema_Inventory_Core AS trk WITH(NOLOCK)
JOIN (
	SELECT REG_Server_Name, REG_Database_Name, REG_Schema_Name, REG_Object_Type
	, AVG(Object_Count) as median_Object_Count
	FROM (
		SELECT REG_Server_Name, REG_Database_Name, REG_Schema_Name, REG_Object_Type, Object_Count
		,	ROW_NUMBER() OVER (PARTITION BY REG_Server_Name, REG_Database_Name, REG_Schema_Name, REG_Object_Type ORDER BY Object_Count ASC) AS RowAsc
		,	ROW_NUMBER() OVER (PARTITION BY REG_Server_Name, REG_Database_Name, REG_Schema_Name, REG_Object_Type ORDER BY Object_Count DESC) AS RowDesc
		FROM CAT.VI_0201_Schema_Inventory_Core WITH(NOLOCK)
		) AS sub
	WHERE RowAsc IN (RowDesc, RowDesc - 1, RowDesc + 1)
	GROUP BY REG_Server_Name, REG_Database_Name, REG_Schema_Name, REG_Object_Type
	) AS med
ON med.REG_Server_Name = trk.REG_Server_Name
AND med.REG_Database_Name = trk.REG_Database_Name
AND med.REG_Schema_Name = trk.REG_Schema_Name
AND med.REG_Object_Type = trk.REG_Object_Type
GROUP BY trk.REG_Server_Name, trk.REG_Database_Name, trk.REG_Schema_Name, trk.REG_Object_Type, med.median_Object_Count
' 
GO
