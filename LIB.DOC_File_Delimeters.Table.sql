USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[DOC_File_Delimeters]') AND type in (N'U'))
DROP TABLE [LIB].[DOC_File_Delimeters]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[DOC_File_Delimeters]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[DOC_File_Delimeters](
	[FD_ID] [int] NOT NULL,
	[Name] [nvarchar](256) NULL,
	[Glyph] [nvarchar](2) NULL,
	[CHAR_Code] [nvarchar](25) NULL,
	[Hexi_Dec] [nvarchar](25) NULL
) ON [PRIMARY]
END
GO
