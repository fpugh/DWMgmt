USE [DWMgmt]
GO


CREATE PROCEDURE [LIB].[TXT_010_File_System_Logging]
@ExecuteStatus TINYINT = 0
, @BatchCapacity BIGINT = 2600000
, @ForceTextParse TINYINT = 0
, @ForceLongParse TINYINT = 0


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

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'pk_TXT_Process_Hash')
BEGIN
	ALTER TABLE [TMP].[TXT_Process_Hash] DROP CONSTRAINT [pk_TXT_Process_Hash]
END


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

INSERT INTO LIB.REG_Sources (Version_Stamp, File_Path, Post_Date)

SELECT DISTINCT T1.Version_Stamp, T1.File_Path, T1.Post_Date
FROM LIB.External_String_Intake_Stack AS T1 WITH(NOLOCK)
LEFT JOIN LIB.REG_Sources AS T2 WITH(NOLOCK)
ON T2.Version_Stamp = T1.Version_Stamp
AND T2.Post_Date = T1.Post_Date
WHERE T2.Source_ID IS NULL


/* Insert into REG_Documents */

INSERT INTO LIB.REG_Documents (Title, Author, Created_Date)

SELECT File_Name, File_Author, File_Created
FROM LIB.External_String_Intake_Stack with(nolock)


/* Insert into Collection Documents 
	Use REG_Collections again to get peripheral associations such as File System.
*/

INSERT INTO LIB.HSH_Collection_Documents (Collection_ID, Source_ID, Document_ID, Post_Date)

SELECT DISTINCT col.Collection_ID, src.Source_ID, doc.Document_ID, stk.Post_Date
FROM LIB.External_String_Intake_Stack AS stk
LEFT JOIN LIB.REG_Sources AS src
ON src.Version_Stamp = stk.Version_Stamp
LEFT JOIN LIB.REG_Documents AS doc
ON doc.Title = stk.File_Name
AND doc.Author = stk.File_Author
CROSS APPLY LIB.REG_Collections AS col
WHERE (stk.File_Size-2)/2 > 0
AND (col.Name = 'File Types'
OR stk.File_Type = col.Name)


/* Assign unknown item types to the File_System collection as a default */

SELECT DISTINCT stk.File_Type as Name, 'Job Catalog Process' as Curator
INTO #Collection_Insert
FROM LIB.External_String_Intake_Stack AS stk
LEFT JOIN LIB.REG_Collections AS rcl
ON rcl.[Name] = stk.[File_Type]
WHERE rcl.Collection_ID IS NULL


INSERT INTO LIB.REG_Collections (Name, Curator)

SELECT Name, Curator
FROM #Collection_Insert


/* ToDo: Add documenation about Link_Type: Originally DURL_Flag with with D/U representing heirarchy postion, 
	and R/L representing latitudinal position among heirarchy peers. Now Link_Type 1 = D/U axis, 2 = R/L axis,
	and expansive room for additional type relations - currently upto 256 types */

INSERT INTO LIB.HSH_Collection_Hierarchy (Link_Type, rk_Collection_ID, fk_Collection_ID)

SELECT 1, clt1.Collection_ID, clt2.Collection_ID
FROM LIB.REG_Collections as clt1
CROSS APPLY LIB.REG_Collections as clt2
WHERE clt1.Name = 'File Types'
AND clt2.Name in (SELECT Name FROM #Collection_Insert)

DROP TABLE #Collection_Insert


/* Register File Paths and Heirarchy */

SELECT STK_ID, ID as Directory_Level, Value as Directory
INTO #Paths
FROM LIB.External_String_Intake_Stack AS stk
CROSS APPLY LIB.Document_Directory_Structure (stk.File_Path)
WHERE Value != File_Name


INSERT INTO LIB.REG_Collections (Name)

SELECT DISTINCT Directory
FROM #Paths


INSERT INTO LIB.HSH_Collection_Hierarchy (Link_Type, RK_Collection_ID, FK_Collection_ID)

SELECT 1, clt1.Collection_ID, clt2.Collection_ID
FROM LIB.REG_Collections as clt1
CROSS APPLY LIB.REG_Collections as clt2
WHERE clt1.Name = 'File Paths'
AND clt2.name in (SELECT DISTINCT Directory FROM #Paths)
UNION
SELECT 1, clt1.Collection_ID, clt2.Collection_ID
FROM (
	SELECT STK_ID, Directory_Level, Collection_ID
	FROM LIB.REG_Collections AS reg
	JOIN #Paths AS tmp
	ON tmp.Directory = reg.Name
	) AS clt1
JOIN (
	SELECT STK_ID, Directory_Level, Collection_ID
	FROM LIB.REG_Collections AS reg
	JOIN #Paths AS tmp
	ON tmp.Directory = reg.Name
	AND tmp.Directory_Level > 1
	) AS clt2
ON clt1.STK_ID = clt2.STK_ID
AND clt1.Directory_Level = clt2.Directory_Level - 1


/** Run batch sizing logic **/

/* Assign Batch_ID values based on known types and Collection rules.

	Files which cannot be processed - Archives for example - are marked by a Batch_ID ending in 'Z'.

	Files without an existing parent collection and less than 2.6 million characters are treated as composite text. 
		They are processed together with any other mix of files in tightly packed batches. 
		They are subject to full parsing, and associated with collections and any existing rule sets.
		They will have a Batch_ID like 'CMPF' possibly with an additional number.

	Files which belong to a Quick Parse collection are identified by a Batch_ID ending in 'Q'.
		XML files have their own quicker path for processing values and schema changes.
		SQL from external sources is not automatically processed under the SQL rules, as foreign code may not be part of the Catalog.
			After processing as composite text, it may be submitted for catalog processing.
		Excel (or any) spreadsheets and Database files are connected too and imported in a different process.
		Delimited files, such as .csv files may have unique quick parse or data processing collections.
			During parsing, files which appear to have structured data will be further analyzed to determine if
				Quick Parsing, or Data Processing can be performed instead.

	Files which belong to to Collection with a strong ruleset and a length less than 2.6 million characters are still subject to full parsing.
		They will be subject to further collection based rules.

	Files which are over 2.6 million characters and not part of a Quick Parse or collection with a strong ruleset are identified with a batch ending in 'L'.
		These require splitting into processable chunks. The @MaxStringLength variable can be passed to the LIB.SplitTable function and in most cases
			a managable number of batches for the file can be derived. Cases where this is still not possible haven't been encountered yet.
		Large files are tested for structured data - if present they are processed that way.
		Large files with strong rule sets *may* have limited parsing burdens.
		Large files should be deprioritized by any server agent job running routine processing.
		Extremely large files can be single-threaded and left to run in the background.
*/

UPDATE stk SET Batch_ID = CASE WHEN viw.Parent_Collection IN ('Archives') THEN 'ARCZ'
	WHEN viw.Parent_Collection IS NULL AND stk.File_Size < 2600000 THEN 'CMPF'
	WHEN viw.Parent_Collection IS NOT NULL THEN UPPER(LEFT(viw.Parent_Collection,3))
	+ CASE WHEN qps.Subordinate_Collection = stk.File_Type THEN 'Q'
		WHEN qps.Subordinate_Collection IS NULL AND stk.File_Size < 2600000 THEN 'F' 
		ELSE 'L' END
	ELSE UPPER(LEFT(REPLACE(File_Type,'.',''),3)) + 'L' END
FROM LIB.External_String_Intake_Stack AS stk WITH(NOLOCK)
LEFT JOIN LIB.VI_2119_Simple_Collection_List AS viw WITH(NOLOCK)
ON viw.Subordinate_Collection = stk.File_Type
AND viw.Parent_Collection NOT IN ('File Types','Quick Parse')
LEFT JOIN (
	SELECT DISTINCT scl1.Subordinate_Collection
	FROM LIB.VI_2119_Simple_Collection_List AS scl1 WITH(NOLOCK)
	JOIN LIB.VI_2119_Simple_Collection_List AS scl2 WITH(NOLOCK)
	ON scl2.Subordinate_Collection = scl1.Parent_Collection
	AND	scl2.Subordinate_Collection IN ('XML','Delimited','Foreign Databases')
	AND scl1.Link_Type = 2
	) AS qps 
ON qps.Subordinate_Collection = stk.File_Type


/* Pack the composite batches
	This uses an implicit cursor to perform a simple
	batch size fitting by taking the largest file, and
	adding the next largest file to it until the batch
	size limit is reached. Then a new batch is created
	with the next biggest file and repeated until full.
 */

SELECT DISTINCT stk.Batch_ID, stk.File_Type
, LEFT(Version_Stamp,4) as Version_Family
, REPLACE(stk.File_Path, stk.File_Name,'') as File_Path
, stk.File_Name
, stk.STK_ID
, stk.File_Size as Batch_Size
, RIGHT(RTRIM(Batch_ID),1) as Process_Style
INTO #BatchComposites
FROM LIB.External_String_Intake_Stack AS stk
WHERE RIGHT(RTRIM(Batch_ID),1) NOT IN ('Z','Q')
AND stk.File_Size < 2600000

CREATE CLUSTERED INDEX tdx_BatchOpperants_K6D ON #BatchComposites (Batch_Size DESC)

SET NOCOUNT OFF

DECLARE @Batch_Size INT = 0
, @CompositeID TINYINT = 1
, @File_Names varchar(8000) = ''

UPDATE trf SET @CompositeID = CASE WHEN (@Batch_Size + Batch_Size) > 2600000 THEN @CompositeID + 1
	ELSE @CompositeID END
	, Batch_ID = 'CMP'+CAST(@CompositeID AS VARCHAR)
	, @Batch_Size = CASE WHEN @Batch_Size + Batch_Size > 2600000 THEN Batch_Size
	ELSE @Batch_Size + Batch_Size END
FROM #BatchComposites AS trf
OPTION (MAXDOP 1)


/* Assign the composite batches to the appropriate files */

UPDATE stk SET Batch_ID = tmp.Batch_ID
FROM LIB.External_String_Intake_Stack AS stk
JOIN #BatchComposites AS tmp
ON tmp.STK_ID = stk.STK_ID


/* Remove any non-parsable batches from this point forward. */

DELETE FROM LIB.External_String_Intake_Stack WHERE RIGHT(RTRIM(Batch_ID),1) = 'Z'
