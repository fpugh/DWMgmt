USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[CUR_DB_Collection_Currator]') AND type in (N'P', N'PC'))
DROP PROCEDURE [LIB].[CUR_DB_Collection_Currator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[CUR_DB_Collection_Currator]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [LIB].[CUR_DB_Collection_Currator]
AS

/* Get new entries from the Database Registry */

SELECT Target_Name
, [Summary_Level]+'': ''+[Target_Name]+''
	Schemas: ''+cast([Schema_Count] as nvarchar)+''
	Objects: ''+cast([Object_Count] as nvarchar)+''
	Columns: ''+cast([Column_Count] as nvarchar) as DB_Description
INTO #NewTitles
FROM CAT.VI_1454_Data_Model_Overview AS T1
LEFT JOIN LIB.REG_Collections AS T2
ON T2.Name = T1.Target_Name
WHERE T1.Summary_Level = ''Database Summary''
AND T2.Name IS NULL


/* New Databases are Collection Titles */

INSERT INTO LIB.REG_Collections (Name, Description)
SELECT Target_Name, DB_Description
FROM #NewTitles
EXCEPT
SELECT Name, Description
FROM LIB.REG_Collections



/* New Databases belong under "User Databases" collection */

INSERT INTO LIB.HSH_Collection_Heirarchy (RK_Collection_ID, FK_Collection_ID)
SELECT T2.Collection_ID, T1.Collection_ID
FROM LIB.REG_Collections AS T1
JOIN #NewTitles AS tmp
ON TMP.Target_Name = T1.Name
JOIN LIB.REG_Collections AS T2
ON T2.Name IN (''User Databases'')
UNION
SELECT T2.Collection_ID, T1.Collection_ID
FROM LIB.REG_Collections AS T1
JOIN #NewTitles AS tmp
ON TMP.Target_Name = T1.Name
JOIN LIB.REG_Collections AS T2
ON T2.Name IN (''Structures'')
EXCEPT 
SELECT RK_Collection_ID, FK_Collection_ID
FROM LIB.HSH_Collection_Heirarchy
WHERE getdate() BETWEEN Post_Date AND Term_Date

' 
END
GO
