USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[Collection_Glyphs_Insert]'))
DROP TRIGGER [LIB].[Collection_Glyphs_Insert]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CGlyphs_REG_Sources]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Glyphs]'))
ALTER TABLE [LIB].[HSH_Collection_Glyphs] DROP CONSTRAINT [FK_HSH_CGlyphs_REG_Sources]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CGlyphs_REG_Glyphs]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Glyphs]'))
ALTER TABLE [LIB].[HSH_Collection_Glyphs] DROP CONSTRAINT [FK_HSH_CGlyphs_REG_Glyphs]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CGlyphs_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Glyphs]'))
ALTER TABLE [LIB].[HSH_Collection_Glyphs] DROP CONSTRAINT [FK_HSH_CGlyphs_REG_Collections]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Glyphs_Uses]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Glyphs] DROP CONSTRAINT [DF_HSH_Glyphs_Uses]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Glyphs_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Glyphs] DROP CONSTRAINT [DF_HSH_Glyphs_Term_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Glyphs_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Glyphs] DROP CONSTRAINT [DF_HSH_Glyphs_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Glyphs]') AND name = N'IDX_CI_LIB_Collection_Glyphs')
DROP INDEX [IDX_CI_LIB_Collection_Glyphs] ON [LIB].[HSH_Collection_Glyphs] WITH ( ONLINE = OFF )
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Glyphs]') AND type in (N'U'))
DROP TABLE [LIB].[HSH_Collection_Glyphs]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Glyphs]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[HSH_Collection_Glyphs](
	[Hash_ID] [int] IDENTITY(1,1) NOT NULL,
	[Collection_ID] [int] NOT NULL,
	[Source_ID] [int] NOT NULL,
	[Glyph_ID] [int] NOT NULL,
	[Post_Date] [datetime] NOT NULL,
	[Term_Date] [datetime] NOT NULL,
	[Use_Count] [int] NOT NULL,
 CONSTRAINT [PK_LIB_Collection_Glyphs] PRIMARY KEY NONCLUSTERED 
(
	[Collection_ID] ASC,
	[Source_ID] ASC,
	[Glyph_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Glyphs]') AND name = N'IDX_CI_LIB_Collection_Glyphs')
CREATE CLUSTERED INDEX [IDX_CI_LIB_Collection_Glyphs] ON [LIB].[HSH_Collection_Glyphs]
(
	[Term_Date] DESC,
	[Use_Count] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Glyphs_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Glyphs] ADD  CONSTRAINT [DF_HSH_Glyphs_Post_Date]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Glyphs_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Glyphs] ADD  CONSTRAINT [DF_HSH_Glyphs_Term_Date]  DEFAULT ('12/31/2013') FOR [Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Glyphs_Uses]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Glyphs] ADD  CONSTRAINT [DF_HSH_Glyphs_Uses]  DEFAULT ((0)) FOR [Use_Count]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CGlyphs_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Glyphs]'))
ALTER TABLE [LIB].[HSH_Collection_Glyphs]  WITH CHECK ADD  CONSTRAINT [FK_HSH_CGlyphs_REG_Collections] FOREIGN KEY([Collection_ID])
REFERENCES [LIB].[REG_Collections] ([Collection_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CGlyphs_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Glyphs]'))
ALTER TABLE [LIB].[HSH_Collection_Glyphs] CHECK CONSTRAINT [FK_HSH_CGlyphs_REG_Collections]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CGlyphs_REG_Glyphs]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Glyphs]'))
ALTER TABLE [LIB].[HSH_Collection_Glyphs]  WITH CHECK ADD  CONSTRAINT [FK_HSH_CGlyphs_REG_Glyphs] FOREIGN KEY([Glyph_ID])
REFERENCES [LIB].[REG_Glyphs] ([Glyph_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CGlyphs_REG_Glyphs]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Glyphs]'))
ALTER TABLE [LIB].[HSH_Collection_Glyphs] CHECK CONSTRAINT [FK_HSH_CGlyphs_REG_Glyphs]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CGlyphs_REG_Sources]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Glyphs]'))
ALTER TABLE [LIB].[HSH_Collection_Glyphs]  WITH CHECK ADD  CONSTRAINT [FK_HSH_CGlyphs_REG_Sources] FOREIGN KEY([Source_ID])
REFERENCES [LIB].[REG_Sources] ([Source_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CGlyphs_REG_Sources]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Glyphs]'))
ALTER TABLE [LIB].[HSH_Collection_Glyphs] CHECK CONSTRAINT [FK_HSH_CGlyphs_REG_Sources]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[Collection_Glyphs_Insert]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [LIB].[Collection_Glyphs_Insert]
ON  [LIB].[HSH_Collection_Glyphs]
INSTEAD OF INSERT
AS 

BEGIN
	
	INSERT INTO LIB.HSH_Collection_Glyphs (Collection_ID, Source_ID, Glyph_ID, Use_Count)
	SELECT Collection_ID, Source_ID, Glyph_ID, Use_Count
	FROM inserted AS tmp
	EXCEPT
	SELECT Collection_ID, Source_ID, Glyph_ID, Use_Count
	FROM LIB.HSH_Collection_Glyphs

END
' 
GO
