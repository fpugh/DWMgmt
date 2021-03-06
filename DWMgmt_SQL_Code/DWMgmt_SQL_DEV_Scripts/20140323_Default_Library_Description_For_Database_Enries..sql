/****** Script for SelectTopNRows command from SSMS  ******/

/* Only functional after databases have been added to collection catalog */

UPDATE T2 SET Description = [Summary_Level]+': '+[Target_Name]+'
	Schemas: '+cast([Schema_Count] as nvarchar)+'
	Objects: '+cast([Object_Count] as nvarchar)+'
	Columns: '+cast([Column_Count] as nvarchar)+'
	Content Catalog Scanned: '+CASE WHEN [Scanned_Columns] = 0 THEN 'NONE'
	ELSE cast(cast([Scanned_Columns]/[Column_Count] as money) as nvarchar) END
FROM CAT.vi_1450_Data_Model_Overview AS t1
JOIN LIB.REG_Collections AS T2
ON T2.Name = T1.Target_Name
WHERE T2.Description IS NULL




SELECT *
FROM LIB.REG_Collections



