CREATE TABLE [LIB].[External_String_Intake_Stack] (
    [STK_ID]        INT             IDENTITY (1, 1) NOT NULL,
    [File_Path]     NVARCHAR (2000) NULL,
    [File_Name]     NVARCHAR (256)  NULL,
    [File_Status]   NVARCHAR (65)   NULL,
    [File_Type]     NVARCHAR (65)   NULL,
    [File_Size]     INT             NULL,
    [File_Encoding] NVARCHAR (65)   NULL,
    [File_Author]   NVARCHAR (256)  NULL,
    [Code_Page]     INT             NULL,
    [File_Created]  DATETIME        NULL,
    [File_Content]  VARBINARY (MAX) NULL,
    [Post_Date]     DATETIME        CONSTRAINT [DF_ESIS_Post] DEFAULT (getdate()) NOT NULL,
    [Version_Stamp] VARCHAR (40)    NULL,
    [Batch_ID]      NCHAR (7)       CONSTRAINT [DF_SQL_Batch_ID] DEFAULT ('TXTL000') NULL
);


GO



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