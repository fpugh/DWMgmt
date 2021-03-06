USE [DWMgmt]
GO


/* Create Schemas for all required tables 
	CAT - 'Catalog' schema for all system metadata, and tracking data and summaries.
	LIB - 'Library' schema for all content analysis such as data profiles, code analysis
		, and text processing. Used for feeding some CAT schema tables, as well as providing
		a baseline for managed SQL code, SSIS, and RDL schemas.
	TMP - 'Temporary' schema for staging and large work tables. These tables are managed by
		processes in both CAT and LIB schemas, are regularly truncated by standard workflows,
		and never backed up or groomed.
*/

CREATE SCHEMA [CAT]
GO

CREATE SCHEMA [LIB]
GO

CREATE SCHEMA [TMP]
GO

CREATE SCHEMA [ECO]
GO

/* Create the fundamental tables required for deployment and operation
	CAT.TRK_SSIS_Import_Errors - custom error log table which exposes select errors
		from internal SQL execution errors, and external SSIS package failures.
		Used by the automated management process to identify and correct problem areas
		in an environment.

	LIB.External_String_Intake_Stack - A library table which recieves all external file
		content for logging and processing. Initially, files from the SQL, SSIS, and SSRS
		solutions are loaded and processes.

	LIB.Internal_String_Intake_Stack - A library table which recieves internal code detected
		during environment scans (REG_0100_SERVER_CENSUS.sql or REG_Server_Master.dtsx) from
		internal SQL modules, and statement captures.

	LIB.REG_Sources - A library registry that uniquely tracks each VersionStamp identifier.
		Required by the External_String_Version_Stamp trigger.

	TMP.TMP_File_Stage - A simple file I/O stack
 */

CREATE TABLE [CAT].[TRK_SSIS_Import_Errors](
	[Post_Date] [datetime] NOT NULL,
	[Execution_ID] [uniqueidentifier] NOT NULL,
	[Target_Server] [nvarchar](256) NULL,
	[Target_Database] [nvarchar](256) NULL,
	[Task_Name] [nvarchar](256) NULL,
	[Error_Code] [int] NULL,
	[Error_Description] [nvarchar](max) NULL,
	[Records] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE TABLE [LIB].[External_String_Intake_Stack](
	[STK_ID] [int] IDENTITY(1,1) NOT NULL,
	[File_Path] [nvarchar](2000) NULL,
	[File_Name] [nvarchar](256) NULL,
	[File_Status] [nvarchar](65) NULL,
	[File_Type] [nvarchar](65) NULL,
	[File_Size] [int] NULL,
	[File_Encoding] [nvarchar](65) NULL,
	[File_Author] [nvarchar](256) NULL,
	[Code_Page] [int] NULL,
	[File_Created] [datetime] NULL,
	[File_Content] [varbinary](max) NULL,
	[Post_Date] [datetime] NOT NULL,
	[Version_Stamp] [varchar](40) NULL,
	[Batch_ID] [nchar](7) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE TABLE [LIB].[Internal_String_Intake_Stack](
	[ID_Type] [tinyint] NOT NULL,
	[Server_ID] [int] NOT NULL,
	[Server_Name] [nvarchar](256) NULL,
	[Database_ID] [int] NULL,
	[Database_Name] [nvarchar](256) NULL,
	[Schema_ID] [int] NULL,
	[Schema_Name] [nvarchar](256) NULL,
	[Object_ID] [int] NULL,
	[Object_Name] [nvarchar](256) NULL,
	[Object_Type] [nvarchar](25) NULL,
	[Object_Owner] [nvarchar](256) NULL,
	[Column_ID] [int] NULL,
	[Column_Name] [nvarchar](256) NULL,
	[Version_Stamp] [char](40) NULL,
	[Create_Date] [datetime] NULL,
	[Post_Date] [datetime] NOT NULL,
	[Code_Content] [nvarchar](max) NOT NULL,
	[Batch_ID] [nchar](7) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE TABLE [LIB].[REG_Sources](
	[Source_ID] [int] IDENTITY(1,1) NOT NULL,
	[Version_Stamp] [char](40) NOT NULL,
	[Post_Date] [datetime] NOT NULL,
	[File_Path] [varchar](512) NOT NULL,
CONSTRAINT [PK_LIB_Sources] PRIMARY KEY CLUSTERED 
(
	[Version_Stamp] ASC
	, [File_Path] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
CONSTRAINT [UQ_Source_ID] UNIQUE NONCLUSTERED 
(
	[Source_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [TMP].[TMP_File_Stage](
	[File_ID] [int] IDENTITY(1,1) NOT NULL,
	[File_Name] [nvarchar](256) NULL,
	[File_Type] [nvarchar](256) NULL,
	[File_Size] [nvarchar](256) NULL,
	[File_Created] [nvarchar](256) NULL,
	[File_Modified] [nvarchar](256) NULL,
	[IsReadOnly] [nvarchar](256) NULL,
	[File_Path] [nvarchar](2000) NULL,
	[Encoding] [nvarchar](256) NULL
) ON [PRIMARY]
GO


/* Add various default constraints for the fundamentaltables */

ALTER TABLE [CAT].[TRK_SSIS_Import_Errors] ADD  CONSTRAINT [DF_LogErrors_Post]  DEFAULT (getdate()) FOR [Post_Date]
GO
ALTER TABLE [LIB].[External_String_Intake_Stack] ADD  DEFAULT (getdate()) FOR [Post_Date]
GO
ALTER TABLE [LIB].[External_String_Intake_Stack] ADD  CONSTRAINT [DF_Batch_ID]  DEFAULT ('TXTL000') FOR [Batch_ID]
GO
ALTER TABLE [LIB].[Internal_String_Intake_Stack] ADD  CONSTRAINT [DF_Int_String_Stack_ID_Type]  DEFAULT ((0)) FOR [ID_Type]
GO
ALTER TABLE [LIB].[Internal_String_Intake_Stack] ADD  CONSTRAINT [DF_Int_String_Stack_Create_Date]  DEFAULT (getdate()) FOR [Create_Date]
GO
ALTER TABLE [LIB].[Internal_String_Intake_Stack] ADD  CONSTRAINT [DF_Int_String_Stack_Post_Date]  DEFAULT (getdate()) FOR [Post_Date]
GO
ALTER TABLE [LIB].[Internal_String_Intake_Stack] ADD  CONSTRAINT [DF_ISIS_Batch_ID]  DEFAULT ('TXTL000') FOR [Batch_ID]
GO
ALTER TABLE [LIB].[REG_Sources] ADD  CONSTRAINT [DF_Sources_Post]  DEFAULT (getdate()) FOR [Post_Date]
GO
ALTER TABLE [LIB].[REG_Sources] ADD  DEFAULT ('C:\') FOR [File_Path]
GO


/* LIB.Decimator finds ten characters within the string
	content and returns a 10 character 'word' that helps
	uniquify the text as part of a VersionStamp algorithm. */

CREATE FUNCTION [LIB].[Decimator] (@String nvarchar(max), @Length bigint)
RETURNS NVARCHAR(9)

AS

BEGIN

DECLARE @Decimate INT
, @Position BIGINT = 1
, @Namex NVARCHAR(10) = ''

SELECT @Decimate = (@Length/9)

WHILE @Position <= @Length
BEGIN
	SELECT @Namex = @Namex + CASE WHEN PATINDEX('[A-Za-z0-9]', ISNULL(SUBSTRING(@String, @Position, 1),'')) > 0
		THEN SUBSTRING(@String, @Position, 1)
		ELSE '-' END 
	, @Position = @Position + @Decimate
END

RETURN @Namex

END
GO


/* These triggers exist on the string intake stack tables and apply a version stamp, as well
	as filter out duplicate entries detected during table insertion. */

CREATE TRIGGER [LIB].[Internal_String_Version_Stamp]
ON [LIB].[Internal_String_Intake_Stack]
INSTEAD OF INSERT

AS


INSERT INTO LIB.Internal_String_Intake_Stack (Server_ID, Database_ID, Database_Name
, Schema_ID, Schema_Name, Object_ID, Object_Name, Object_Type, Create_Date, Version_Stamp, Code_Content)

SELECT Server_ID, Database_ID, Database_Name, Schema_ID, Schema_Name
, Object_ID, Object_Name, Object_Type, Create_Date
, SOUNDEX(LEFT(Object_Name, LEN(Object_Name)/2))+'-'+SOUNDEX(RIGHT(Object_Name, LEN(Object_Name)/2)) -- Namex Code
+':'+right('000'+cast(Server_ID as nvarchar),3)
+'.'+right('000'+cast(Database_ID as nvarchar),3)
+'.'+right('0000000000'+cast(Object_ID as nvarchar),10)
+':'+right('0000000000'+cast(DATALENGTH(Code_Content) as nvarchar),10) as Version_Stamp -- Datamass Code
, Code_Content
FROM inserted


/* These triggers exist on the string intake stack tables and apply a version stamp, as well
	as filter out duplicate entries detected during table insertion. */

CREATE TRIGGER [LIB].[External_String_Version_Stamp]  
ON [LIB].[External_String_Intake_Stack]
INSTEAD OF INSERT

AS

/* Create a Version Stamp for the file based on the name, size, and content.
	Included in the Version Stamp algorithm are the following:
	- SOUNDEX function of the file name
	- Decimated Text Key, a combination of 10 apha-numeic characters picked from the string. Symbol or unprintable characters converted to ''-'' character
	-- Characters are picked based on file size, so as the same file changes over time, this key will probably detect different keys.
	- Datamass Code; the bytes of the source string
	- Created Date YYYYMMDD
*/

SELECT File_Path, File_Name, File_Status, File_Type, File_Size, File_Encoding, File_Author, Code_Page, File_Created, File_Content, Post_Date
, SOUNDEX(REPLACE(File_Name, File_Type, ''))
+':'+ LIB.Decimator(
		CASE WHEN LEFT(inserted.File_Content,2) = 'ÿþ' THEN CAST(inserted.File_Content AS NVARCHAR(MAX)) ELSE CAST(CAST(inserted.File_Content AS VARCHAR(MAX)) AS NVARCHAR(MAX)) END
	, CASE WHEN LEFT(inserted.File_Content,2) = 'ÿþ' THEN (inserted.File_Size)/2 ELSE inserted.File_Size END) -- Decimated Text Key
+':'+right('0000000000'+CAST(File_Size AS NVARCHAR),10) -- Datamass Code
+':'+right('0000000000'+CONVERT(VARCHAR(8), CAST(File_Created as datetime), 112),10) AS Version_Stamp
INTO #Version_Stamp_List
FROM inserted


/* Insert only brand new code with original Version_Stamp */

INSERT INTO LIB.External_String_Intake_Stack (File_Path, File_Name, File_Status, File_Type, File_Size
, File_Encoding, File_Author, Code_Page, File_Created, File_Content, Post_Date, Version_Stamp)

SELECT DISTINCT obj.File_Path, obj.File_Name, obj.File_Status, obj.File_Type, obj.File_Size
, obj.File_Encoding, obj.File_Author, obj.Code_Page, obj.File_Created, obj.File_Content, obj.Post_Date
,obj.Version_Stamp + ':' + RIGHT('000'+CAST(DENSE_RANK() OVER(PARTITION BY obj.Version_Stamp ORDER BY obj.File_Created, obj.File_Size, obj.File_Path, obj.File_Name, obj.File_Content) AS NVARCHAR),3)
FROM #Version_Stamp_List AS obj

