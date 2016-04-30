USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Documents_Post]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[REG_Documents] DROP CONSTRAINT [DF_Documents_Post]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[REG_Documents]') AND type in (N'U'))
DROP TABLE [LIB].[REG_Documents]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[REG_Documents]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[REG_Documents](
	[Document_ID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](512) NOT NULL,
	[Author] [nvarchar](256) NOT NULL,
	[File_Path] [nvarchar](1024) NOT NULL,
	[File_Size] [int] NOT NULL,
	[Post_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_LIB_Documents] PRIMARY KEY NONCLUSTERED 
(
	[File_Path] ASC,
	[File_Size] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_LRD_Document_ID] UNIQUE NONCLUSTERED 
(
	[Document_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Documents_Post]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[REG_Documents] ADD  CONSTRAINT [DF_Documents_Post]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
