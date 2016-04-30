USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_WordCat_REG_Dictionary]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Word_Categories]'))
ALTER TABLE [LIB].[HSH_Word_Categories] DROP CONSTRAINT [FK_HSH_WordCat_REG_Dictionary]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_WordCat_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Word_Categories]'))
ALTER TABLE [LIB].[HSH_Word_Categories] DROP CONSTRAINT [FK_HSH_WordCat_REG_Collections]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_WordCat_REG_Categories]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Word_Categories]'))
ALTER TABLE [LIB].[HSH_Word_Categories] DROP CONSTRAINT [FK_HSH_WordCat_REG_Categories]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Word_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Word_Categories] DROP CONSTRAINT [DF_HSH_Word_Term_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Word_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Word_Categories] DROP CONSTRAINT [DF_HSH_Word_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Word_Categories]') AND type in (N'U'))
DROP TABLE [LIB].[HSH_Word_Categories]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Word_Categories]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[HSH_Word_Categories](
	[Hash_ID] [int] IDENTITY(1,1) NOT NULL,
	[Collection_ID] [int] NOT NULL,
	[Word_ID] [bigint] NOT NULL,
	[Category_ID] [int] NOT NULL,
	[Post_Date] [datetime] NOT NULL,
	[Term_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_LIB_Word_Categories] PRIMARY KEY CLUSTERED 
(
	[Collection_ID] ASC,
	[Word_ID] ASC,
	[Category_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_HSH_Word_Cat_ID] UNIQUE NONCLUSTERED 
(
	[Hash_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Word_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Word_Categories] ADD  CONSTRAINT [DF_HSH_Word_Post_Date]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Word_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Word_Categories] ADD  CONSTRAINT [DF_HSH_Word_Term_Date]  DEFAULT ('12/31/2099') FOR [Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_WordCat_REG_Categories]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Word_Categories]'))
ALTER TABLE [LIB].[HSH_Word_Categories]  WITH CHECK ADD  CONSTRAINT [FK_HSH_WordCat_REG_Categories] FOREIGN KEY([Category_ID])
REFERENCES [LIB].[REG_Categories] ([Category_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_WordCat_REG_Categories]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Word_Categories]'))
ALTER TABLE [LIB].[HSH_Word_Categories] CHECK CONSTRAINT [FK_HSH_WordCat_REG_Categories]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_WordCat_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Word_Categories]'))
ALTER TABLE [LIB].[HSH_Word_Categories]  WITH CHECK ADD  CONSTRAINT [FK_HSH_WordCat_REG_Collections] FOREIGN KEY([Collection_ID])
REFERENCES [LIB].[REG_Collections] ([Collection_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_WordCat_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Word_Categories]'))
ALTER TABLE [LIB].[HSH_Word_Categories] CHECK CONSTRAINT [FK_HSH_WordCat_REG_Collections]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_WordCat_REG_Dictionary]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Word_Categories]'))
ALTER TABLE [LIB].[HSH_Word_Categories]  WITH CHECK ADD  CONSTRAINT [FK_HSH_WordCat_REG_Dictionary] FOREIGN KEY([Word_ID])
REFERENCES [LIB].[REG_Dictionary] ([Word_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_WordCat_REG_Dictionary]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Word_Categories]'))
ALTER TABLE [LIB].[HSH_Word_Categories] CHECK CONSTRAINT [FK_HSH_WordCat_REG_Dictionary]
GO
