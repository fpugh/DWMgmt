USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[External_String_Version_Stamp]'))
DROP TRIGGER [LIB].[External_String_Version_Stamp]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF__External___Post___38CF4036]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[External_String_Intake_Stack] DROP CONSTRAINT [DF__External___Post___38CF4036]
END

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[LIB].[External_String_Intake_Stack]') AND name = N'NC_TXT_SCIS_Type')
DROP INDEX [NC_TXT_SCIS_Type] ON [LIB].[External_String_Intake_Stack]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[LIB].[External_String_Intake_Stack]') AND name = N'NC_TXT_SCIS_Encoding')
DROP INDEX [NC_TXT_SCIS_Encoding] ON [LIB].[External_String_Intake_Stack]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[External_String_Intake_Stack]') AND type in (N'U'))
DROP TABLE [LIB].[External_String_Intake_Stack]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[External_String_Intake_Stack]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[External_String_Intake_Stack](
	[STK_ID] [int] IDENTITY(1,1) NOT NULL,
	[File_Path] [nvarchar](2000) NULL,
	[File_Name] [nvarchar](256) NULL,
	[File_Status] [nvarchar](64) NULL,
	[File_Type] [nvarchar](64) NULL,
	[File_Size] [int] NULL,
	[File_Encoding] [nvarchar](64) NULL,
	[File_Author] [nvarchar](128) NULL,
	[Code_Page] [int] NULL,
	[File_Created] [datetime] NULL,
	[File_Content] [varbinary](max) NULL,
	[Post_Date] [datetime] NOT NULL,
	[Version_Stamp] [varchar](40) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[LIB].[External_String_Intake_Stack]') AND name = N'NC_TXT_SCIS_Encoding')
CREATE NONCLUSTERED INDEX [NC_TXT_SCIS_Encoding] ON [LIB].[External_String_Intake_Stack]
(
	[File_Encoding] ASC
)
INCLUDE ( 	[STK_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[LIB].[External_String_Intake_Stack]') AND name = N'NC_TXT_SCIS_Type')
CREATE NONCLUSTERED INDEX [NC_TXT_SCIS_Type] ON [LIB].[External_String_Intake_Stack]
(
	[File_Type] ASC
)
INCLUDE ( 	[STK_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF__External___Post___38CF4036]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[External_String_Intake_Stack] ADD  DEFAULT (getdate()) FOR [Post_Date]
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[External_String_Version_Stamp]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [LIB].[External_String_Version_Stamp]  
ON [LIB].[External_String_Intake_Stack]
INSTEAD OF INSERT

AS

SELECT File_Path, File_Name, File_Status, File_Type, File_Size, File_Encoding, File_Author, Code_Page, File_Created, File_Content, Post_Date
, SOUNDEX(SUBSTRING(File_Path, CHARINDEX(''\'', File_Path)+1, CHARINDEX(''\'', File_Path, CHARINDEX(''\'', File_Path)+1)-4))
+''-''+SOUNDEX(RIGHT(REPLACE(File_Path, File_Name, ''''), CHARINDEX(''\'', REVERSE(REPLACE(File_Path, File_Name, '''')), CHARINDEX(''\'', REVERSE(REPLACE(File_Path, File_Name, ''''))) + 1) - 2))
+''-''+SOUNDEX(REVERSE(REPLACE(File_Name, File_Type, '''')))
+'':''+right(''0000000000''+CAST(File_Size AS NVARCHAR),10) -- Datamass Code
+'':''+right(''0000000000''+CONVERT(VARCHAR(8),Post_Date, 112),10)  
+'':''+right(''000''+CAST(LEN(File_Name) AS NVARCHAR),3) AS Version_Stamp
INTO #Version_Stamp_List
FROM inserted


/* Insert only brand new code with original Version_Stamp */

INSERT INTO LIB.External_String_Intake_Stack (File_Path, File_Name, File_Status, File_Type, File_Size
, File_Encoding, File_Author, Code_Page, File_Created, File_Content, Post_Date, Version_Stamp)

SELECT DISTINCT File_Path, File_Name, File_Status, File_Type, File_Size
, File_Encoding, File_Author, Code_Page, File_Created, File_Content, Post_Date, obj.Version_Stamp
FROM #Version_Stamp_List AS obj
LEFT JOIN LIB.REG_Sources AS src WITH(NOLOCK)
ON src.Version_Stamp = obj.Version_Stamp
WHERE src.Source_ID IS NULL
' 
GO
