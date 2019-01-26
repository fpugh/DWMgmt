

CREATE VIEW [CAT].[VT_0331_Table_Disparity]
AS
SELECT DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT rcc.Data_Type_Count) * (1 - min(rcc.Column_Count)/CAST(AVG(rcc.Column_Count) as decimal(10,6))) DESC, map.LNK_FK_0300_ID) AS VID
, map.LNK_FK_0300_ID
, map.REG_Object_Name
, map.REG_Object_Type
, COUNT(DISTINCT rcc.REG_Server_Name) as Server_Count
, COUNT(DISTINCT rcc.REG_Database_Name) as Database_Count
, COUNT(DISTINCT rcc.REG_Schema_Name) as Schema_Count
, min(rcc.Column_Count) as Min_Column_Count
, AVG(rcc.Column_Count) as Avg_Column_Count
, MAX(rcc.Column_Count) as Max_Column_Count
, 1 - min(rcc.Column_Count)/CAST(AVG(rcc.Column_Count) as decimal(10,6)) as Column_Count_Min_Diff
, COUNT(DISTINCT rcc.Data_Type_Count) as Data_Type_Variance
, COUNT(DISTINCT rcc.Data_Type_Count) * (1 - min(rcc.Column_Count)/CAST(AVG(rcc.Column_Count) as decimal(10,6))) as Potential_Error_Score
FROM CAT.VI_0300_Full_Object_Map AS map WITH(NOLOCK)
CROSS APPLY ( 
    SELECT REG_Server_Name, REG_Schema_Name, REG_Database_Name, REG_Object_Name
    , COUNT(DISTINCT REG_Column_Name) as Column_Count
    , COUNT(DISTINCT REG_Column_Type) as Data_Type_Count
    FROM CAT.VI_0200_Column_Tier_Latches WITH(NOLOCK)
    WHERE REG_Object_Type IN ('U','V')
    GROUP BY REG_Server_Name, REG_Schema_Name, REG_Database_Name, REG_Object_Name
    ) AS rcc
WHERE rcc.REG_Object_Name = map.REG_Object_Name
AND rcc.REG_Server_Name = map.REG_Server_Name
AND rcc.REG_Database_Name = map.REG_Database_Name
AND rcc.REG_Schema_Name = map.REG_Schema_Name
GROUP BY map.REG_Object_Name, map.LNK_FK_0300_ID, map.REG_Object_Type
HAVING COUNT(DISTINCT rcc.Data_Type_Count) > 1
OR min(rcc.Column_Count) <> MAX(rcc.Column_Count)