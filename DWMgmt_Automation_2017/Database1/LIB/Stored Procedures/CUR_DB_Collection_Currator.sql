

CREATE PROCEDURE [LIB].[CUR_DB_Collection_Currator]
AS

/* Get new entries from the Database Registry */

SELECT Target_Name
, [Summary_Level]+': '+[Target_Name]+'
	Schemas: '+cast([Schema_Count] as nvarchar)+'
	Objects: '+cast([Object_Count] as nvarchar)+'
	Columns: '+cast([Column_Count] as nvarchar)+'
	Content Catalog Scanned: '+CASE WHEN [Scanned_Columns] = 0 THEN 'NONE'
	ELSE cast(cast([Scanned_Columns]/[Column_Count] as money) as nvarchar) END as DB_Desccription
INTO #NewTitles
FROM CAT.VI_1454_Data_Model_Overview AS T1
LEFT JOIN LIB.reg_Collections AS T2
ON T2.Name = T1.Target_Name
WHERE T1.Summary_Level = 'Database Summary'
AND T2.Name IS NULL

/* New Databases are Collection Titles */

INSERT INTO LIB.reg_Collections (Name, Description)

SELECT Target_Name, DB_Desccription
FROM #NewTitles
EXCEPT
SELECT Name, Description
FROM LIB.reg_Collections

/* New Databases belong under "User Databases" collection */

INSERT INTO LIB.HSH_Collection_Hierarchy (rk_Collection_ID, fk_Collection_ID)

SELECT T2.Collection_ID, T1.Collection_ID
FROM LIB.reg_Collections AS T1
JOIN #NewTitles AS tmp
ON tmp.Target_Name = T1.Name
JOIN LIB.reg_Collections AS T2
ON T2.Name IN ('User Databases')
EXCEPT 
SELECT rk_Collection_ID, fk_Collection_ID
FROM LIB.HSH_Collection_Hierarchy
WHERE getdate() BETWEEN Post_Date AND Term_Date