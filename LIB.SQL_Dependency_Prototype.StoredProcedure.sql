USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[SQL_Dependency_Prototype]') AND type in (N'P', N'PC'))
DROP PROCEDURE [LIB].[SQL_Dependency_Prototype]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[SQL_Dependency_Prototype]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [LIB].[SQL_Dependency_Prototype]

AS

-- TRUNCATE TABLE ##CodeObjectLinks
CREATE TABLE ##CodeObjectLinks (Qualified_Object_Name NVARCHAR(512), REG_0600_ID INT, REG_Code_Content NVARCHAR(MAX))


DECLARE @QualifiedOBject NVARCHAR(512)
, @SQL NVARCHAR(max)

DECLARE ObjectList CURSOR FOR
SELECT DISTINCT Schema_Bound_Name
FROM CAT.VI_0300_Full_Object_Map
WHERE Schema_Bound_Name IS NOT NULL
AND REG_Schema_Name <> ''dbo''
UNION
SELECT DISTINCT REG_Object_Name
FROM CAT.VI_0300_Full_Object_Map
WHERE Schema_Bound_Name IS NOT NULL
AND REG_Schema_Name = ''dbo''

OPEN ObjectList

FETCH NEXT FROM ObjectList
INTO @QualifiedObject

WHILE @@FETCH_STATUS = 0

BEGIN
SET @SQL = ''

INSERT INTO ##CodeObjectLinks (Qualified_Object_Name, REG_0600_ID, REG_Code_Content)

SELECT ''''''+@QualifiedObject+'''''', REG_0600_ID, REG_Code_Content
FROM DWMgmt.CAT.REG_0600_Object_Code_Library
WHERE CONTAINS(REG_Code_Content, ''''''+@QualifiedObject+'''''')
  ''

EXECUTE sys.sp_executeSQL @SQL

FETCH NEXT FROM ObjectList
INTO @QualifiedObject

END

CLOSE ObjectList
DEALLOCATE ObjectList


SELECT *
FROM ##CodeObjectLinks


/* ToDo:
Create a stoplist for "noise" objects such as "Catalog", "Roles", etc. 
These are often control words or are simply too common to be useful. Such objects should be renamed or bound to a custom schema.
*/' 
END
GO
