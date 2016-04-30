USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_File_Rank]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[DOC_File_Staging] DROP CONSTRAINT [DF_File_Rank]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[DOC_File_Staging]') AND type in (N'U'))
DROP TABLE [TMP].[DOC_File_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[DOC_File_Staging]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[DOC_File_Staging](
	[File_Rank] [int] NOT NULL,
	[File_Path] [nvarchar](2000) NOT NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_File_Rank]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[DOC_File_Staging] ADD  CONSTRAINT [DF_File_Rank]  DEFAULT ((0)) FOR [File_Rank]
END

GO
