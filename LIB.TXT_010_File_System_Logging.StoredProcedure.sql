USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[TXT_010_File_System_Logging]') AND type in (N'P', N'PC'))
DROP PROCEDURE [LIB].[TXT_010_File_System_Logging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[TXT_010_File_System_Logging]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [LIB].[TXT_010_File_System_Logging]
@ExecuteStatus TINYINT = 2


/** Concepts:
	The original concept of this process was a universal file staging table from which
	various types of work would be performed based on the known file type, or by assimilating
	new types into the collection.
	
	Building functional SQL and XML processing became higher priority; consequently two seperate
	processing stacks emerged. These may remain partially in place after this development push.
	This logging procedure should be the basis for ALL file types; each specialized processing
	branch picking up work from this point and carrying forward with specialized procedures.
	
	A universal TXT_STRING_MAP process should be implemented in line with this to build the primary
	shredding structures from which the specialized procedures can work.
	
	New file types should be heavilly parsed for struture and control words - i.e. a .cpp file
	contains C++ syntax, after some level of confidence this type should be established as its own
	category and special processing derived.
	
	Q? At what frequency should a control word be established?
		Total Files of Type / Files of Type Containig (word) between .8 and 1.
	Q? How to handle multiple types -
		Some extensions used by different types - parse for expected content (control words 
		used in structured context)


	File Processing Logic

	1. ALL external files are collected into LIB.External_String_Intake_Stack
	2. Content stack is logged and processed.
	3. TXT String_Map is built
	4. Specialty file types are shunted to their own processing queues - XML, SQL, TXT, etc.
	5a. XML Documents have their own routines which: 
	-	Test the schema against known schema types
	--	Log and process new schmeas
	--	Execute derivative queries against known schemas to extract critical values (connection strings, attributes, etc.)
	5b. SQL documents DO NOT move into the SQL processing collection automatically
	-	Files are tested against catalog objects
	--	Files associated with a catalog object are parsed for version attribution
	--	Files unassociated with a catalog object are logged under Foreign Server/Foreign Database and staged for SQL_012_Shredder
	5c. String based documents such as .txt or .doc, or any unknown types are parsed for strong structure (potential code file or structured data) or 

	natural language structure (looser syntax, language detection, etc.)
	5d. Binary/Stream type files such as images, audio files, or sensor streams have minimal parsing available.

**/


AS

/* Drop primary key index on table for insert */

IF EXISTS (SELECT * FROM sys.indexes WHERE name = ''pk_TXT_Process_Hash'')
BEGIN
	ALTER TABLE [TMP].[TXT_Process_Hash] DROP CONSTRAINT [pk_TXT_Process_Hash]
END


/* Eliminate extant code - reduces process volume 
	ToDo Notes: A Trigger mechanism exists on the source
	where performs the same function as this during initial
	table load. Evaluate the need for this implementation by
	10/31/2015. If no errors on different system deployments
	occur, drop this code.

--DELETE T1
--FROM LIB.External_String_Intake_Stack AS T1
--JOIN LIB.REG_Sources AS T2
--ON T2.Version_Stamp = T1.Version_Stamp

*/



/* Keep only the most recent post of each item in case multiple scans have
	transpired between code analysis. */

DELETE T1
FROM LIB.External_String_Intake_Stack AS T1 WITH(NOLOCK)
LEFT JOIN (
	SELECT T1.Version_Stamp, T1.Post_Date
	FROM LIB.External_String_Intake_Stack AS T1
	JOIN (
		SELECT Version_Stamp, MAX(Post_Date) as Post_Date
		FROM LIB.External_String_Intake_Stack WITH(NOLOCK)
		GROUP BY Version_Stamp
		HAVING COUNT(*) > 1
		UNION
		SELECT Version_Stamp, MAX(Post_Date) as Post_Date
		FROM LIB.External_String_Intake_Stack WITH(NOLOCK)
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

SELECT DISTINCT T1.Version_Stamp, T1.Post_Date
FROM LIB.External_String_Intake_Stack AS T1 WITH(NOLOCK)
LEFT JOIN LIB.REG_Sources AS T2 WITH(NOLOCK)
ON T2.Version_Stamp = T1.Version_Stamp
AND T2.Create_Date = T1.Post_Date
WHERE T2.Source_ID IS NULL



/* File sources under appropriate collection(s) 
	Use/Modify case statement below until reliable tag from file import script task can be compiled
	This case statement will currently detect ASCII and UTF8 encoding types.
*/

INSERT INTO TMP.TXT_Process_Hash (Collection_ID, Source_ID, Version_Stamp, Post_Date, File_Type, String_Length, String)

SELECT DISTINCT C1.Collection_ID, S1.Source_ID, stk.Version_Stamp, min(stk.Post_Date), stk.File_Type
, CASE WHEN LEFT(stk.File_Content,2) = ''ÿþ'' THEN (stk.File_Size)/2 
	ELSE stk.File_Size END as String_Length
, CASE WHEN LEFT(stk.File_Content,2) = ''ÿþ'' THEN CAST(stk.File_Content AS NVARCHAR(MAX))
	ELSE CAST(CAST(stk.File_Content AS VARCHAR(MAX)) AS NVARCHAR(MAX)) END as String_Convert
FROM LIB.External_String_Intake_Stack AS stk
JOIN LIB.REG_Sources AS S1
ON S1.Version_Stamp = stk.Version_Stamp
CROSS APPLY LIB.REG_Collections AS C1
WHERE (stk.File_Size-2)/2 > 0
AND CASE WHEN ISNULL(stk.File_Type,'''') = '''' THEN ''File System'' ELSE stk.File_Type END = C1.Name
GROUP BY C1.Collection_ID, S1.Source_ID, stk.Version_Stamp, stk.File_Type, stk.File_Size, stk.File_Content
ORDER BY stk.Version_Stamp


/* Create Primary Key on SQL_Process_Hash */

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = ''pk_TXT_Process_Hash'')
BEGIN
	ALTER TABLE [TMP].[TXT_Process_Hash] ADD CONSTRAINT [pk_TXT_Process_Hash] PRIMARY KEY CLUSTERED 
	(Version_Stamp ASC) 
	ON [PRIMARY]
END


/* Insert into REG_Documents */

INSERT INTO LIB.REG_Documents (Title, Author, File_Path, File_Size, Post_Date)

SELECT File_Name, File_Author, File_Path, File_Size, File_Created
FROM LIB.External_String_Intake_Stack
EXCEPT
SELECT Title, Author, File_Path, File_Size, Post_Date
FROM LIB.REG_Documents


/* Insert into Collection Documents 
	Use REG_Collections again to get peripheral associations such as File System.	
*/

INSERT INTO LIB.HSH_Collection_Documents (Collection_ID, Source_ID, Document_ID, Post_Date)

SELECT C1.Collection_ID, T1.Source_ID, T3.Document_ID, T2.Post_Date
FROM TMP.TXT_Process_Hash AS T1
JOIN LIB.External_String_Intake_Stack AS T2
ON T2.Version_Stamp = T1.Version_Stamp
JOIN LIB.REG_Documents AS T3
ON T3.File_Path = T2.File_Path
AND T3.File_Size = T2.File_Size
CROSS APPLY LIB.REG_Collections AS C1
WHERE (T2.File_Size-2)/2 > 0
AND (C1.Name = ''File System''
OR T2.File_Type = C1.Name)


/* 
	20151115:4est - RETAIN THIS CODE - REPLICATE FOR SQL and other Defined code types as they become available.

	Insert new collection items 
	ToDo: Complete file type switch for processing known file structures:
		.sql, .rdl, .dtsx, .xml, etc.


INSERT INTO TMP.XML_Process_Hash (Collection_ID, Source_ID, Version_Stamp, Post_Date, String_Length, String)

SELECT Collection_ID, Source_ID, Version_Stamp, Post_Date, String_Length, String
FROM TMP.TXT_Process_Hash AS hsh
JOIN LIB.VI_2019_Simple_Collection_List AS vew 
ON hsh.File_Type = Subordinate_Collection
WHERE vew.Parent_Collection = ''XML''

DELETE hsh
FROM TMP.TXT_Process_Hash AS hsh
JOIN LIB.VI_2019_Simple_Collection_List AS vew 
ON hsh.File_Type = Subordinate_Collection
WHERE vew.Parent_Collection = ''XML''

*/
' 
END
GO
