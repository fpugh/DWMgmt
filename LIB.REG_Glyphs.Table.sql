USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_Glyphs_Alphabet2]') AND parent_object_id = OBJECT_ID(N'[LIB].[REG_Glyphs]'))
ALTER TABLE [LIB].[REG_Glyphs] DROP CONSTRAINT [FK_Glyphs_Alphabet2]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_Glyphs_Alphabet1]') AND parent_object_id = OBJECT_ID(N'[LIB].[REG_Glyphs]'))
ALTER TABLE [LIB].[REG_Glyphs] DROP CONSTRAINT [FK_Glyphs_Alphabet1]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Glyphs_Post]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[REG_Glyphs] DROP CONSTRAINT [DF_Glyphs_Post]
END

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[LIB].[REG_Glyphs]') AND name = N'idx_nc_Glyph_K3_I1')
DROP INDEX [idx_nc_Glyph_K3_I1] ON [LIB].[REG_Glyphs]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[REG_Glyphs]') AND type in (N'U'))
DROP TABLE [LIB].[REG_Glyphs]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[REG_Glyphs]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[REG_Glyphs](
	[Glyph_ID] [int] IDENTITY(1,1) NOT NULL,
	[ASCII_Char1] [tinyint] NOT NULL,
	[ASCII_Char2] [tinyint] NOT NULL,
	[Post_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_LIB_Glyphs] PRIMARY KEY NONCLUSTERED 
(
	[ASCII_Char1] ASC,
	[ASCII_Char2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Glyphs_IDKey] UNIQUE NONCLUSTERED 
(
	[Glyph_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[LIB].[REG_Glyphs]') AND name = N'idx_nc_Glyph_K3_I1')
CREATE NONCLUSTERED INDEX [idx_nc_Glyph_K3_I1] ON [LIB].[REG_Glyphs]
(
	[ASCII_Char2] ASC
)
INCLUDE ( 	[ASCII_Char1]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Glyphs_Post]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[REG_Glyphs] ADD  CONSTRAINT [DF_Glyphs_Post]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_Glyphs_Alphabet1]') AND parent_object_id = OBJECT_ID(N'[LIB].[REG_Glyphs]'))
ALTER TABLE [LIB].[REG_Glyphs]  WITH CHECK ADD  CONSTRAINT [FK_Glyphs_Alphabet1] FOREIGN KEY([ASCII_Char1])
REFERENCES [LIB].[REG_Alphabet] ([ASCII_Char])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_Glyphs_Alphabet1]') AND parent_object_id = OBJECT_ID(N'[LIB].[REG_Glyphs]'))
ALTER TABLE [LIB].[REG_Glyphs] CHECK CONSTRAINT [FK_Glyphs_Alphabet1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_Glyphs_Alphabet2]') AND parent_object_id = OBJECT_ID(N'[LIB].[REG_Glyphs]'))
ALTER TABLE [LIB].[REG_Glyphs]  WITH CHECK ADD  CONSTRAINT [FK_Glyphs_Alphabet2] FOREIGN KEY([ASCII_Char2])
REFERENCES [LIB].[REG_Alphabet] ([ASCII_Char])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_Glyphs_Alphabet2]') AND parent_object_id = OBJECT_ID(N'[LIB].[REG_Glyphs]'))
ALTER TABLE [LIB].[REG_Glyphs] CHECK CONSTRAINT [FK_Glyphs_Alphabet2]
GO
