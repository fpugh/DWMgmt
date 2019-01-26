

CREATE PROCEDURE [LIB].[MP_Load_Library_Defaults]
AS

/* Initialize Version_Stamp schemas collection
	20150820 - Many portions of this procedure could be replicated by file import. Consider this the minimal required
		pre-loading for the Library functions to work. This code should be retained so long as 2008 and 2005 databases
		are viable targets.

	20140505 - This is currently uncertain work, designed as a prototype code template source.
		Its intent is to provide a standard script to capture and currate files based on type using AI rules.
		The template script will beceome a secured record accessible to the AI job process that asssesses source curration.
		As of this notation date it is retained as a sample, but should not be deployed as normal code.
		See view [Management].[LIB].[VI_Version_Stamp_Reference] for a listing of topics and filings for this process.


set identity_Insert LIB.DOC_Version_Stamp_Schemas on

INSERT INTO LIB.DOC_Version_Stamp_Schemas (SchemaID, ParentID, Value, Description)
SELECT 0, 0, ''ADHOC'', ''Adhoc insert/update Identifier Template.'' 
UNION
SELECT 1, 0, ''CAT'', ''Catalog Event Identifier Template''
UNION
SELECT 2, 0, ''LIB'', ''Library Event Identifier Template''
UNION
SELECT 3, 0, ''DOC'', ''Document Event Identifier Template''

set identity_Insert LIB.DOC_Version_Stamp_Schemas off


INSERT INTO LIB.DOC_Version_Stamp_Schemas (ParentID, Value, Description)
SELECT 0, ''ADLIB'', ''Basic Library Template: <Code> --''''ADLIB<Target =:>''''+{REG_0204_ID}+''''.''''+{REG_0300_ID}+''''</Target><Date =:>getdate()</Date><Agent=:>{suser_ID()}<>''''''
UNION
SELECT 0, ''ADCAT'', ''Unregistered Catalog Event Identifier Template --''''ADCAT<Target =:>''''+{REG_0204_ID}+''''.''''+{REG_0300_ID}+''''</Target><Date =:>getdate()</Date><Agent=:>{suser_ID()}</Agent>''''''
UNION
SELECT 2, ''SQLLIB'', ''SQL Module Intake Stack Identifier Template -- <TEMPLATE COMPLETE>''
UNION
SELECT 1, ''SQLCAT'', ''SQL Event Identifier from Catalog analysis procedures --''''<Job>{jobid}</Job><Sequence>{seqid}</Sequence><Post_Date>getdate()</Post_Date><Target>{REG_0300_ID}</Target><Status>[tinyint]</status>''''''



!!!! 20150106:4est - These objects and methods are no longer supported. The concept of deriving a standard dynamic template to automatically generate improved code is worth keeping as an idea for future implementation.
		Retain these notes until the templating phase of development is functional.
 */


/* Initialize GLOBAL collection */

insert into LIB.REG_Collections (Name, Description, Curator)

select 'Global', 'Library Global collection aggregates select basic metrics across its entire inventory.', 'Default'


insert into LIB.REG_Collections (Name, Description, Curator)

select 'Catalog', 'Registered structures, logic, data, metrics and resources of the datawarehouse.', 'Job Catalog Process'


insert into LIB.REG_Collections (Name, Description, Curator)

select 'Foreign Databases', 'Databases and objects from foreign servers or unknown sources', 'Manual or Import Process'
union
select 'System Databases', 'System databases or system objects distributed into user databases', 'Job Catalog Process'
union
select 'User Databases', 'User or Non-OEM Databases related to a collection.', 'Job Catalog Process'


insert into LIB.REG_Collections (Name, Description, Curator)

select 'File System', 'Sources from the file system.', 'Environment Scan'


insert into LIB.REG_Collections (Name, Description, Curator)

select 'File Types', 'File extensions encountered during loading or scans.', 'Environment Scan'
union
select 'Delimited', 'Files with parsable semi-ridgid structure defined by a control character or sequence such as ",", "|", "<tab>", etc.', 'Environment Scan'
union
select 'Quick Parse', 'Files with identified schemas or structure (primarilly delimited, and XML) allowing faster ETL processes to strip values quickly without full parsing.', 'Environment Scan'
union
select 'File Paths', 'Folder locations accessed during environment scans.', 'Environment Scan'


insert into LIB.REG_Collections (Name, Description, Curator)

select 'Code', 'A collection of all procedural code found in the Datawarehouse and/or Business Intelligence system.', 'Job Catalog Process'


insert into LIB.REG_Collections (Name, Description, Curator)

select 'SQL', 'A collection of procedural SQL found in the Datawarehouse and/or Business Intelligence system.', 'Job Catalog Process'
union
select 'XML', 'A collection of procedural XML found in the Datawarehouse and/or Business Intelligence system.', 'Job Catalog Process'
union
select 'VB.NET', 'A collection of procedural Visual Basic found in the Datawarehouse and/or Business Intelligence system.', 'Job Catalog Process'
union
select 'CSS/CPP', 'A collection of procedural Visual C# and C++ found in the Datawarehouse and/or Business Intelligence system.', 'Job Catalog Process'
union
select 'VB.NET', 'A collection of procedural Visual Basic found in the Datawarehouse and/or Business Intelligence system.', 'Job Catalog Process'
union
select 'CSS/CPP', 'A collection of procedural Visual C# and C++ found in the Datawarehouse and/or Business Intelligence system.', 'Job Catalog Process'
union
select 'SSRS', 'A collection of SQL Server Reporting Services report templates found in the DHHA Business Intelligence system.', 'Job Catalog Process'
union
select 'SSIS', 'A collection of SQL Server Integration Services data transformation packages found in the Datawarehouse and/or Business Intelligence system.', 'Job Catalog Process'
union
select 'SSAS', 'A collection of SQL Server Analysis Services queries found in the Datawarehouse and/or Business Intelligence system.', 'Job Catalog Process'
union
select 'SAS', 'A collection of Statistical Analysis System code found in the Datawarehouse and/or Business Intelligence system.', 'Job Catalog Process'


insert into LIB.REG_Collections (Name, Description, Curator)

select '.sql', 'A SQL script file saved on the file system. May contain DML or DDL language such as table or view definitions, procedures, fucntions or ad-hoc user queries', 'Environment Scan'
union
select '.ssmssln', 'A SQL Server project file (SQL Server 2008+) in XML format.', 'Environment Scan'
union
select '.xml', 'A generic XML format file with unknown node structure or content.', 'Adhoc'
union
select '.cpp', 'A C++ program file.', 'Adhoc'
union
select '.css', 'A C# program file.', 'Adhoc'
union
select '.rdl', 'An Reporting Services file in XML format - contains definitions and logic for SSRS Reports.', 'Environment Scan'
union
select '.dtsx', 'An Integration Services "Package" in XML format - contains all tasks and logic for an ETL opperation', 'Job Catalog Process'
union
select '.conmgr', 'An Integration Services connection manager in XML format - contains all tasks and logic for an ETL opperation', 'Job Catalog Process'
union
select '.dtproj', 'An Integration Services project file in XML format - contains all details of package files included in a project', 'Job Catalog Process'
union
select '.params', 'An Integration Services parameter file in XML format - contains all project parameters and default values', 'Job Catalog Process'
union
select '.user', 'An Integration Services user settings file in XML format - contains all user variable settings for an instance of the VS Shell', 'Job Catalog Process'


insert into LIB.REG_Collections (Name, Description, Curator)

select 'Content', 'A collection of data metrics, and context tags for all data collections in the Datawarehouse.', 'Job Catalog Process'


insert into LIB.REG_Collections (Name, Description, Curator)

select 'Reporting', 'A collection of reporting topics, templates, and statistics found in the DHHA Business Intelligence system.', 'Job Catalog Process'
union
select 'Documents', 'Formal collections of textual information - typically natural language sourced - related to a collection.', 'Adhoc'
union
select 'Values', 'Collection of select, unique data values present in a collection - Low value data (determined by class, quality, quantity, etc.), system object values typically omitted.', 'Data Profiling Process'
union
select 'Archives', 'Compressed file collections such .zip, .rar, .tgz, etc. Not parseable.', 'Job Catalog Process'
union
select 'Profiles', 'Summaries of value profiles indicating measures such as density, uniqueness, quartiles, equivalence, select values, etc.', 'Data Profiling Process'


insert into LIB.REG_Collections (Name, Description, Curator)

select 'Access DBs', 'A collection of Access databases used for reporting, or data sampling.', 'Adhoc'
union
select 'Crystal', 'A collection of Crystal Reports templates associated with a collection', 'Adhoc'
union					
select 'Excel', 'A collection of Excel workbooks used as sources or reports.', 'Adhoc'
union
select 'Power Pivot', 'A collection of Power Pivot reports utilized in sharepoint to illustrate aggregate data.', 'Adhoc'
union
select 'Sharepoint', 'A collection of Sharepoint lists used for reporting from operational datastores', 'Adhoc'


insert into LIB.REG_Collections (Name, Description, Curator)

select '.rpt', 'A Crystal Reports output file (many file type associated with reports use this).', 'Adhoc'
union
select '.xls', 'An Excel 97 - 2003 workbook', 'Adhoc'
union
select '.xlsx', 'An Excel 2007+ workbook', 'Adhoc'
union
select '.mdb', 'An Access 97 - 2003 database file.', 'Adhoc'
union
select '.accdb', 'An Access 2007+ database file.', 'Adhoc'
union
select '.txt', 'Basic text document - likely in ASCII encoding.', 'Adhoc'
union
select '.readme', 'Usually a text document with instructions or notes about files in a direcotory - likely in ASCII encoding.', 'Adhoc'
union
select '.pdf', 'Adobe "Portable Document Format" image file.', 'Binary Stream'
union
select '.gif', 'Traditional image file. Essentially produces pixel plot of RGB scale.', 'Binary Stream'
union
select '.jpeg', 'A lossy image file format used for photography and higher quality images', 'Binary Stream'
union
select '.rtf', 'Rich Text Format - contains rudimentary formatting characters.', 'Adhoc'
union
select '.zip', 'Fundamental Windows archive format. Compresses one more files', 'Adhoc'
union
select '.rar', 'Proprietary archiving format with advanced options. Requires 3rd party application to extract.', 'Adhoc'
union
select '.7Z', 'Open source AES encryption capable archive.', 'Adhoc'
union
select '.cab', 'A file Cabinet. Used by Windows intallations.', 'Adhoc'
union
select '.tar', 'A lossy image file format used for photography and higher quality images', 'Binary Stream'


insert into LIB.REG_Collections (Name, Description, Curator)

select 'Structures', 'A collection of architecture for all objects in the datawarehouse.', 'Job Catalog Process'
union
select 'Languages', 'A collection of printed, natural/spoken language and code-based languages found in the Datawarehouse and/or Business Intelligence system.', 'Job Catalog Process'


insert into LIB.REG_Collections (Name, Description, Curator)

select 'English', 'Most common spoken language of the business and aviation world. Dialects exist and may be required for translatin/differentiation in some regions.', 'Adhoc'


set identity_insert LIB.REG_Documents on

insert into LIB.REG_Documents (Document_ID, Title, Author, Created_Date)

select -1, 'Values', 'Data Profiling Process',-1
union 
select -2, 'Profiles', 'Data Profiling Process',-1

set identity_insert LIB.REG_Documents off


set identity_insert LIB.REG_Sources on

insert into LIB.REG_Sources (Source_ID, Version_Stamp, File_Path, Post_Date)

select -1, 'VHASH:0000000000000000000000000000000000','Internal Data Profiling Process',-1

set identity_insert LIB.REG_Sources off


set identity_insert LIB.REG_Rules on

/* Initialize Text Parsing Rules */

INSERT INTO LIB.REG_Rules (Rule_ID,Rule_Name,Rule_Type,Rule_Desc)

SELECT 1,'Universal_Delimiter','Fundamental','The most common ''S'' class character, which denotes the expected delimiter for structured data.'
UNION
SELECT 2,'Line_End_Type','Fundamental','Detect if line endings indicated fixed or ragged positions.'
UNION
SELECT 3,'Common_Delimiters','Fundamental','Detects if universal delimiter in comma, pipe, or tab.'

set identity_insert LIB.REG_Rules off


/* Provide rudimentary collection heirarchies */

insert into LIB.HSH_Collection_Hierarchy (Link_Type, rk_Collection_ID, fk_Collection_ID)

select 0, 0, Collection_ID
from LIB.REG_Collections as clt
where clt.name in ('Catalog','Languages','Documents','File System')
union
select 1, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'Catalog'
and clt2.name in ('Foreign Databases','System Databases','User Databases')
union
select 1, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name in ('Foreign Databases','System Databases','User Databases')
and clt2.name in ('Structures','Code','Content')
union
select 1, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'Code'
and clt2.name in ('SQL','XML','VB.NET','CSS/CPP','SSRS','SSIS','SSAS','SAS')
union
select 2, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'SQL'
and clt2.name in ('.sql')
union
select 2, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'CSP'
and clt2.name in ('.cpp','.css')
union
select 2, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'SSIS'
and clt2.name in ('.conmgr','.dtproj','.dtsx','.params','.user')
union
select 2, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'SSRS'
and clt2.name in ('.rdl')
union
select 2, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'XML'
and clt2.name in ('.rdl','.conmgr','.dtproj','.dtsx','.params','.user','.xml','.ssmssln')
union
select 1, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'File System'
and clt2.name in ('File Paths', 'File Types')
union
select 1, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'File Types'
and clt2.name in ('.rdl','.conmgr','.dtproj','.dtsx','.params','.user','.txt','.xml','.xls','.xlsx','.mdb','.accdb','.sql','.rpt','.ssmssln','.cpp','.css','.zip','.cab','7z','.rar')
union
select 2, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'File Types'
and clt2.name in ('CSS/CPP','SQL','VB.NET','XML','Archives','Delimited','Quick Parse')
union
select 1, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'Quick Parse'
and clt2.name in ('XML','Delimited')
union
select 1, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'Content'
and clt2.name in ('Values','Reporting','Documents','Profiles')
union
select 1, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'Reporting'
and clt2.name in ('Crystal','Excel','Power Pivot','Sharepoint','Access DBs','SSRS','SAS')
union
select 1, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'Language'
and clt2.name in ('English')
union
select 2, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'Language'
and clt2.name in ('CSS/CPP','VB.NET','XML','SQL')
union
select 2, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'Documents'
and clt2.name in ('.jpeg','.gif','.pdf','.txt','.rtf','Values','Profiles')
union
select 1, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'File System'
and clt2.name in ('Archives')
union
select 2, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'File Types'
and clt2.name in ('Archives','XML','SQL','CSS/CSP','VB.NET')
union
select 2, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = 'Archives'
and clt2.name in ('.zip','.cab','7z','.rar')


/* Insert initial contextual link between DWMgmt and UserDatabases */

INSERT INTO LIB.REG_Collections (Name, Description, Curator)
SELECT 'DWMgmt', 'An alternative SQL Data Warehouse Management collection of structure, logic, and content', 'Adhoc'


INSERT INTO LIB.HSH_Collection_Hierarchy (fk_Collection_ID, rk_Collection_ID, Link_Type)
SELECT (SELECT Collection_ID FROM LIB.REG_Collections WHERE name = 'DWMgmt'), (SELECT Collection_ID FROM LIB.REG_Collections WHERE name = 'User Databases'), 1


/* Initialize standard ASCII alphabet set - Character value 0 - NULL not permitted. 
	This process loads all standard ASCII characters and classifies them as consonant (C), vowel (V), numeric (N), symbolic (S) or other (O - non-printable control characters)
	TAB is considered a printable character.
*/

INSERT INTO LIB.REG_Alphabet (ASCII_Char, Char_Val, Printable, Class_VCNS)
SELECT 0, '', 0, 'S' -- NULL loaded as blank

DECLARE @i SMALLINT = 1

WHILE @i <= 255
BEGIN

	insert into LIB.REG_Alphabet (ASCII_Char, Char_Val, Class_VCNS, Printable)
	select @i, char(@i)
	, CASE WHEN  @i IN (66,67,68,70,71,72,74,75,76,77,78,80,81,82,83,84,86,87,88,89,90,98,99,100,102,103,104,106,107,108,109,110,112,113,114,115,116,118,119,120,121,122,138,142,154,158,159,199,204,205,206,207,208,209,221,222,223,231,240,241,253,254,255) THEN 'C'
			WHEN  @i IN (65,69,73,79,85,97,101,105,111,117,161,192,193,194,195,196,197,198,200,201,202,203,210,211,212,213,214,216,217,218,219,220,224,225,226,227,228,229,230,232,233,234,235,236,237,238,239,242,243,244,245,246,248,249,250,251,252) THEN 'V'
			WHEN  @i IN (48,49,50,51,52,53,54,55,56,57) THEN 'N'
			WHEN  @i IN (9,10,13,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,58,59,60,61,62,63,64,91,92,93,94,95,96,123,124,125,126,127,128,130,131,132,133,134,135,136,137,139,140,145,146,147,148,149,150,151,152,153,155,156,162,165,166,167,168,169,170,171,172,174,173,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,215,247) THEN 'S'
			ELSE 'O' END
	, CASE WHEN @i = 9 OR @i > 31 THEN 1 ELSE 0 END

SET @i = @i + 1

END



/* Initialize Graphemes - Technically any 2-3 letter combination that mimics the sounds of human speach,
	in this case it is any two characters.

	All printable character combinations are loaded and classified.
	BK - carriage return/Line feed combination
	DC - Delimiter Character - Any character followed by one of the common delimiters - tab, comma, or pipe.
	NL - Natural Langage - any combination of vowels or consonants, or any vowel or consonant paired with a space character.
	PC - Punctuation Character - Any character associated with the termination of a sentance followed by a space character.
	OT - All other possible combination of graphemes.
*/


/** Insert Carriage Return/Line Feed as fundamental value **/

SET IDENTITY_INSERT LIB.REG_Graphemes ON
	INSERT INTO LIB.REG_Graphemes (Graph_ID, ASCII_Char1, ASCII_Char2, Use_Class)
	SELECT 0,13,10,'BK'
SET IDENTITY_INSERT LIB.REG_Graphemes OFF


/** Insert Categorized character pairs of BK, DC, NL, PC, and DC
	These are specified types consisting of a limited set of character pairs.
**/

INSERT INTO LIB.REG_Graphemes (ASCII_Char1, ASCII_Char2, Use_Class)

SELECT s1.ASCII_CHAR, s2.ASCII_CHAR, 'NL'
FROM ( 
	SELECT Char_Val, ASCII_Char, Class_VCNS
	FROM LIB.REG_Alphabet
	WHERE Class_VCNS IN ('C','V')
	OR ASCII_Char = 32
	) AS S1
CROSS APPLY ( 
	SELECT Char_Val, ASCII_Char, Class_VCNS
	FROM LIB.REG_Alphabet
	WHERE Class_VCNS IN ('C','V')
	OR ASCII_Char = 32
	) AS S2
WHERE s1.ASCII_Char != 32 AND s2.ASCII_Char != 32 -- No double spaces!

UNION

SELECT DISTINCT s1.ASCII_CHAR, 32, 'PC'
FROM ( 
	SELECT Char_Val, ASCII_Char, Class_VCNS
	FROM LIB.REG_Alphabet
	WHERE Char_Val IN (',','	',';','!',':','?','.')
	) AS S1

UNION

SELECT DISTINCT s1.ASCII_CHAR, s2.ASCII_CHAR, 'FS'
FROM ( 
	SELECT Char_Val, ASCII_Char, Class_VCNS
	FROM LIB.REG_Alphabet
	WHERE Class_VCNS IN ('C','V','N')
	OR ASCII_Char IN (9,10,13,44,124)
	) AS S1
CROSS APPLY ( 
	SELECT Char_Val, ASCII_Char, Class_VCNS
	FROM LIB.REG_Alphabet
	WHERE Class_VCNS IN ('C','V','N')
	OR ASCII_Char IN (9,10,13,44,124)
	) AS S2
WHERE (s1.ASCII_Char IN (9,44,124)
OR s2.ASCII_Char IN (9,44,124))


/** Insert all other character pairs as 'Other' **/

INSERT INTO LIB.REG_Graphemes (ASCII_Char1, ASCII_Char2, Use_Class)

SELECT DISTINCT s1.ASCII_CHAR, s2.ASCII_CHAR, 'OT'
FROM ( 
	SELECT Char_Val, ASCII_Char, Class_VCNS
	FROM LIB.REG_Alphabet
	) AS S1
CROSS APPLY ( 
	SELECT Char_Val, ASCII_Char, Class_VCNS
	FROM LIB.REG_Alphabet
	) AS S2
LEFT JOIN LIB.REG_Graphemes AS ref
ON ref.ASCII_Char1 = S1.ASCII_Char
AND ref.ASCII_Char2 = S2.ASCII_Char
WHERE ref.Graph_ID IS NULL



/* Initialize the dictionary with one-letter words.
	One letter words are a special case, and are excluded from
	automated processes. Additional 1-letter words may be found
	and added as additional languages are encountered, and imported.
*/


INSERT INTO LIB.REG_Dictionary (Word)

SELECT 'A'
UNION ALL
SELECT 'a'
UNION ALL
SELECT 'I'	-- I must always be capitalized to be considered a valid 1-letter word.
UNION ALL
SELECT 'O'	-- I must always be capitalized to be considered a valid 1-letter word.
UNION ALL
SELECT 'U'	-- SMS/Text slang for 'you'
UNION ALL
SELECT 'u'	-- SMS/Text slang for 'you'
UNION ALL
SELECT 'R'	-- SMS/Text slang for 'are'
UNION ALL
SELECT 'r'	-- SMS/Text slang for 'are'
UNION ALL
SELECT 'K'	-- SMS/Text slang for 'ok/okay'
UNION ALL
SELECT 'k'	-- SMS/Text slang for 'ok/okay'