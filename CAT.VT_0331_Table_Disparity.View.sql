USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VT_0331_Table_Disparity]'))
DROP VIEW [CAT].[VT_0331_Table_Disparity]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VT_0331_Table_Disparity]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [CAT].[VT_0331_Table_Disparity]
AS
SELECT DENSE_Rank() OVER (ORDER BY count(distinct rcc.Data_Type_Count) * (1 - min(rcc.Column_Count)/cast(avg(rcc.Column_Count) as decimal(10,6))) DESC, REG_0300_ID) AS VID
, map.REG_0300_ID
, map.REG_Object_Name
, map.REG_Object_Type
, count(distinct rcc.REG_Server_Name) as Server_Count
, count(distinct rcc.REG_Database_Name) as Database_Count
, count(distinct rcc.REG_Schema_Name) as Schema_Count
, min(rcc.Column_Count) as Min_Column_Count
, avg(rcc.Column_Count) as Avg_Column_Count
, max(rcc.Column_Count) as Max_Column_Count
, 1 - min(rcc.Column_Count)/cast(avg(rcc.Column_Count) as decimal(10,6)) as Column_Count_Min_Diff
, count(distinct rcc.Data_Type_Count) as Data_Type_Variance
, count(distinct rcc.Data_Type_Count) * (1 - min(rcc.Column_Count)/cast(avg(rcc.Column_Count) as decimal(10,6))) as Potential_Error_Score
FROM CAT.VI_0200_Column_Tier_Latches AS map WITH(NOLOCK)
CROSS APPLY ( 
    SELECT REG_Server_Name, REG_Schema_Name, REG_Database_Name, REG_Object_Name
    , count(distinct REG_Column_Name) as Column_Count
    , count(distinct REG_Column_Type) as Data_Type_Count
    FROM CAT.VI_0200_Column_Tier_Latches WITH(NOLOCK)
    WHERE REG_Object_Type IN (''U'',''V'')
    GROUP BY REG_Server_Name, REG_Schema_Name, REG_Database_Name, REG_Object_Name
    ) AS rcc
WHERE rcc.REG_Object_Name = map.REG_Object_Name
AND rcc.REG_Server_Name = map.REG_Server_Name
AND rcc.REG_Database_Name = map.REG_Database_Name
AND rcc.REG_Schema_Name = map.REG_Schema_Name
GROUP BY map.REG_Object_Name, map.REG_0300_ID, map.REG_Object_Type
HAVING count(distinct rcc.Data_Type_Count) > 1
OR min(rcc.Column_Count) <> max(rcc.Column_Count)
' 
GO
