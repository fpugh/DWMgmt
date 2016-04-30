USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[Internal_String_Version_Stamp]'))
DROP TRIGGER [LIB].[Internal_String_Version_Stamp]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Int_String_Stack_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[Internal_String_Intake_Stack] DROP CONSTRAINT [DF_Int_String_Stack_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Int_String_Stack_Create_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[Internal_String_Intake_Stack] DROP CONSTRAINT [DF_Int_String_Stack_Create_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Int_String_Stack_ID_Type]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[Internal_String_Intake_Stack] DROP CONSTRAINT [DF_Int_String_Stack_ID_Type]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[Internal_String_Intake_Stack]') AND type in (N'U'))
DROP TABLE [LIB].[Internal_String_Intake_Stack]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[Internal_String_Intake_Stack]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[Internal_String_Intake_Stack](
	[STK_ID] [int] IDENTITY(1,1) NOT NULL,
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
	[Column_ID] [int] NULL,
	[Column_Name] [nvarchar](256) NULL,
	[Version_Stamp] [char](40) NULL,
	[Create_Date] [datetime] NULL,
	[Post_Date] [datetime] NOT NULL,
	[Code_Content] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Int_String_Stack_ID_Type]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[Internal_String_Intake_Stack] ADD  CONSTRAINT [DF_Int_String_Stack_ID_Type]  DEFAULT ((0)) FOR [ID_Type]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Int_String_Stack_Create_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[Internal_String_Intake_Stack] ADD  CONSTRAINT [DF_Int_String_Stack_Create_Date]  DEFAULT (getdate()) FOR [Create_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Int_String_Stack_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[Internal_String_Intake_Stack] ADD  CONSTRAINT [DF_Int_String_Stack_Post_Date]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[Internal_String_Version_Stamp]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [LIB].[Internal_String_Version_Stamp]
ON [LIB].[Internal_String_Intake_Stack]
INSTEAD OF INSERT

AS

SELECT ID_Type, Server_ID, Server_Name, Database_ID, Database_Name, Schema_ID, Schema_Name
, Object_ID, Object_Name, Object_Type, Create_Date, Column_Name, Column_ID
, SOUNDEX(LEFT(Object_Name, LEN(Object_Name)/2))+''-''+SOUNDEX(RIGHT(Object_Name, LEN(Object_Name)/2)) -- Namex Code
+'':''+right(''000''+cast(Server_ID as nvarchar),3)
+''.''+right(''000''+cast(Database_ID as nvarchar),3)
+''.''+right(''0000000000''+cast(Object_ID as nvarchar),10)
+'':''+right(''0000000000''+cast(DATALENGTH(Code_Content) as nvarchar),10) as Version_Stamp -- Datamass Code
, Code_Content
INTO #Version_Stamp_List
FROM inserted


/* Insert only brand new code with original Version_Stamp */
INSERT INTO LIB.Internal_String_Intake_Stack (ID_Type, Server_ID, Server_Name, Database_ID, Database_Name
, Schema_ID, Schema_Name, Object_ID, Object_Name, Object_Type, Column_ID, Column_Name, Version_Stamp, Create_Date, Code_Content)

SELECT DISTINCT obj.ID_Type, obj.Server_ID, obj.Server_Name, obj.Database_ID, obj.Database_Name, obj.Schema_ID, obj.Schema_Name
, obj.Object_ID, obj.Object_Name, obj.Object_Type, Column_ID, Column_Name, obj.Version_Stamp, obj.Create_Date, obj.Code_Content
FROM #Version_Stamp_List AS obj
LEFT JOIN LIB.REG_Sources AS src WITH(NOLOCK)
ON src.Version_Stamp = obj.Version_Stamp
WHERE src.Source_ID IS NULL
' 
GO
