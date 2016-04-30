USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Alphabet_Post]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[REG_Alphabet] DROP CONSTRAINT [DF_Alphabet_Post]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Alphabet_Print]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[REG_Alphabet] DROP CONSTRAINT [DF_Alphabet_Print]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[REG_Alphabet]') AND type in (N'U'))
DROP TABLE [LIB].[REG_Alphabet]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[REG_Alphabet]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[REG_Alphabet](
	[ASCII_Char] [tinyint] NOT NULL,
	[Char_Val] [nchar](1) NOT NULL,
	[Printable] [bit] NOT NULL,
	[Post_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Alphabet] PRIMARY KEY CLUSTERED 
(
	[ASCII_Char] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Alphabet_Print]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[REG_Alphabet] ADD  CONSTRAINT [DF_Alphabet_Print]  DEFAULT ((0)) FOR [Printable]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Alphabet_Post]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[REG_Alphabet] ADD  CONSTRAINT [DF_Alphabet_Post]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
