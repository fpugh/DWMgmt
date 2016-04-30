USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[SQL_010_Module_Logging]') AND type in (N'P', N'PC'))
DROP PROCEDURE [LIB].[SQL_010_Module_Logging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[SQL_010_Module_Logging]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [LIB].[SQL_010_Module_Logging]
@ExecuteStatus TINYINT = 2

AS

/* Drop primary key index on table for insert */
IF EXISTS (SELECT * FROM sys.indexes WHERE name = ''pk_SQL_Process_Hash'')
BEGIN
	ALTER TABLE [TMP].[SQL_Process_Hash] DROP CONSTRAINT [pk_SQL_Process_Hash]
END



/* Eliminate extant code - reduces process volume 
	ToDo Notes: A Trigger mechanism exists on the source
	where performs the same function as this during initial
	table load. Evaluate the need for this implementation by
	10/31/2015. If no errors on different system deployments
	occur, drop this code.
*/
--DELETE T1
--FROM LIB.Internal_String_Intake_Stack AS T1
--JOIN LIB.REG_Sources AS T2
--ON T2.Version_Stamp = T1.Version_Stamp



/* Keep only the most recent post of each item in case multiple scans have
	transpired between code analysis. */
DELETE T1
FROM LIB.Internal_String_Intake_Stack AS T1 WITH(NOLOCK)
LEFT JOIN (
	SELECT T1.Version_Stamp, T1.Post_Date
	FROM LIB.Internal_String_Intake_Stack AS T1
	JOIN (
		SELECT Version_Stamp, MAX(Post_Date) as Post_Date
		FROM LIB.Internal_String_Intake_Stack WITH(NOLOCK)
		GROUP BY Version_Stamp
		HAVING COUNT(*) > 1
		UNION
		SELECT Version_Stamp, MAX(Post_Date) as Post_Date
		FROM LIB.Internal_String_Intake_Stack WITH(NOLOCK)
		GROUP BY Version_Stamp
		HAVING COUNT(*) = 1
		) as S1
	ON S1.Version_Stamp = T1.Version_Stamp
	AND S1.Post_Date = T1.Post_Date	
	) AS S2
ON T1.Version_Stamp = S2.Version_Stamp
AND T1.Post_Date = S2.Post_Date
WHERE S2.Post_Date IS NULL



/* Log or update collections and catalogs */
INSERT INTO LIB.REG_Sources (Version_Stamp, Create_Date)
SELECT DISTINCT T1.Version_Stamp, T1.Create_Date
FROM LIB.Internal_String_Intake_Stack AS T1 WITH(NOLOCK)
LEFT JOIN LIB.REG_Sources AS T2 WITH(NOLOCK)
ON T2.Version_Stamp = T1.Version_Stamp
AND T2.Create_Date = T1.Create_Date
WHERE T2.Source_ID IS NULL
AND T1.Object_Type IN (''P'',''RF'',''V'',''TR'',''FN'',''IF'',''TF'',''R'',''D'')


/* Ad-hoc files into the catalog will not hurt right now but is not the intended destination.
	- Version_Stamp should specify which source code comes from and file accordingly.
	- Files should be registered under the LIB schema collection. Connections between
	file and object are appropriate to create facts for.
	- Frequently executed as-hoc indicate rudimentary elements and indicate a user file exists.
	Create an .Adhoc file type?
*/

INSERT INTO CAT.REG_0300_Object_Registry (REG_Object_Name, REG_Object_Type, REG_Create_Date)
SELECT T1.Object_Name, T1.Object_Type, MIN(T1.Create_Date)
FROM LIB.Internal_String_Intake_Stack AS T1 WITH(NOLOCK)
LEFT JOIN CAT.REG_0300_Object_Registry AS T2 WITH(NOLOCK)
ON T2.REG_Object_Type = T1.Object_Type
AND T2.REG_Object_Name = T1.Object_Name
WHERE T1.Object_Type IN (''P'',''RF'',''V'',''TR'',''FN'',''IF'',''TF'',''R'',''D'')
AND T2.REG_0300_ID IS NULL
GROUP BY T1.Object_Name, T1.Object_Type


/* File sources under appropriate collection(s) - Code should be filed
	directly under the TSQL collection, as well as the topic specific collection */

INSERT INTO TMP.SQL_Process_Hash (LNK_T3_ID, Source_ID, Catalog_ID, Version_Stamp, Post_Date, String_Length, String)

SELECT DISTINCT ISNULL(r2.LNK_T3_ID,0), S1.Source_ID, r3.REG_0300_ID, stk.Version_Stamp, min(stk.Post_Date)
, (dataLength(stk.Code_Content)-2)/2 as String_Length
, stk.Code_Content as String
FROM LIB.Internal_String_Intake_Stack AS stk
LEFT JOIN (
	SELECT max(l2.LNK_T3_ID) as LNK_T3_ID, REG_Database_Name+''.''+REG_Schema_Name+''.''+REG_Object_Name as Fully_Qualified_Name
	FROM CAT.LNK_0100_0200_Server_Databases AS l1
	JOIN CAT.LNK_0204_0300_Schema_Binding AS l2
	ON l1.LNK_T2_ID = l2.LNK_fk_T2_ID
	JOIN CAT.REG_0200_Database_registry AS r1
	ON r1.REG_0200_ID = l1.LNK_fk_0200_ID
	JOIN CAT.REG_0204_Database_schemas AS r2
	ON r2.REG_0204_ID = l2.LNK_fk_0204_ID
	JOIN CAT.REG_0300_Object_registry AS r3
	ON r3.REG_0300_ID = l2.LNK_fk_0300_ID
	GROUP BY REG_Database_Name+''.''+REG_Schema_Name+''.''+REG_Object_Name
	) AS r2
ON r2.Fully_Qualified_Name = stk.Database_Name+''.''+stk.Schema_Name+''.''+stk.Object_Name
LEFT JOIN CAT.REG_0300_Object_Registry AS r3 WITH(NOLOCK)
ON r3.REG_Object_Type = stk.Object_Type
AND r3.REG_Object_Name = stk.Object_Name
LEFT JOIN LIB.REG_Sources AS S1
ON S1.Version_Stamp = stk.Version_Stamp
WHERE stk.Object_Type IN (''P'',''RF'',''V'',''TR'',''FN'',''IF'',''TF'',''R'',''D'')
GROUP BY R2.LNK_T3_ID, S1.Source_ID, r3.REG_0300_ID, stk.Version_Stamp, stk.Code_Content
ORDER BY stk.Version_Stamp


/* Create Primary Key on SQL_Process_Hash */
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = ''pk_SQL_Process_Hash'')
BEGIN
	ALTER TABLE [TMP].[SQL_Process_Hash] ADD CONSTRAINT [pk_SQL_Process_Hash] PRIMARY KEY CLUSTERED 
	([Version_Stamp] ASC) 
	ON [PRIMARY]
END


/* Insert new collection items */
INSERT INTO LIB.HSH_Collection_Source_Catalog (Collection_ID, Source_ID, Catalog_ID, Post_Date)

SELECT DISTINCT C1.Collection_ID, T1.Source_ID, T1.Catalog_ID, T1.Post_Date
FROM TMP.SQL_Process_Hash AS T1
JOIN LIB.Internal_String_Intake_Stack AS T2
ON T2.Version_Stamp = T1.Version_Stamp
CROSS APPLY LIB.REG_Collections AS C1
WHERE C1.Name = CASE WHEN T1.LNK_T3_ID = 0 THEN ''Foreign Databases'' 
	WHEN T2.Database_Name IN (''master'',''model'',''msdb'',''tempdb'')
	OR T2.Schema_Name IN (''sys'',''INFORMATION_SCHEMA'') THEN ''System Databases''
	ELSE ''User Databases'' END
	OR C1.name = ''SQL''
	OR T2.Database_Name = C1.Name

' 
END
GO
