USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[Collection_Source_Insert]'))
DROP TRIGGER [LIB].[Collection_Source_Insert]
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[LIB].[C_CSC_Collection_ID]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Source_Catalog]'))
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] DROP CONSTRAINT [C_CSC_Collection_ID]
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[LIB].[C_CSC_Catalog_ID]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Source_Catalog]'))
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] DROP CONSTRAINT [C_CSC_Catalog_ID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_CSC_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Source_Catalog]'))
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] DROP CONSTRAINT [FK_CSC_REG_Collections]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_CSC_REG_0300_Object_registry]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Source_Catalog]'))
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] DROP CONSTRAINT [FK_CSC_REG_0300_Object_registry]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_CSC_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] DROP CONSTRAINT [DF_HSH_CSC_Term_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_CSC_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] DROP CONSTRAINT [DF_HSH_CSC_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[D_CSC_Source_ID]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] DROP CONSTRAINT [D_CSC_Source_ID]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Source_Catalog]') AND type in (N'U'))
DROP TABLE [LIB].[HSH_Collection_Source_Catalog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Source_Catalog]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[HSH_Collection_Source_Catalog](
	[Hash_ID] [int] IDENTITY(1,1) NOT NULL,
	[Collection_ID] [int] NOT NULL,
	[Source_ID] [int] NOT NULL,
	[Catalog_ID] [int] NOT NULL,
	[Post_Date] [datetime] NOT NULL,
	[Term_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_CollectionSourceCatalog] PRIMARY KEY CLUSTERED 
(
	[Collection_ID] ASC,
	[Source_ID] ASC,
	[Catalog_ID] ASC,
	[Post_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_CSC_Hash_ID] UNIQUE NONCLUSTERED 
(
	[Hash_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[D_CSC_Source_ID]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] ADD  CONSTRAINT [D_CSC_Source_ID]  DEFAULT ((0)) FOR [Source_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_CSC_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] ADD  CONSTRAINT [DF_HSH_CSC_Post_Date]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_CSC_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] ADD  CONSTRAINT [DF_HSH_CSC_Term_Date]  DEFAULT ('12/31/2099') FOR [Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_CSC_REG_0300_Object_registry]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Source_Catalog]'))
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog]  WITH CHECK ADD  CONSTRAINT [FK_CSC_REG_0300_Object_registry] FOREIGN KEY([Catalog_ID])
REFERENCES [CAT].[REG_0300_Object_registry] ([REG_0300_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_CSC_REG_0300_Object_registry]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Source_Catalog]'))
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] CHECK CONSTRAINT [FK_CSC_REG_0300_Object_registry]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_CSC_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Source_Catalog]'))
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog]  WITH CHECK ADD  CONSTRAINT [FK_CSC_REG_Collections] FOREIGN KEY([Collection_ID])
REFERENCES [LIB].[REG_Collections] ([Collection_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_CSC_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Source_Catalog]'))
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] CHECK CONSTRAINT [FK_CSC_REG_Collections]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[LIB].[C_CSC_Catalog_ID]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Source_Catalog]'))
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog]  WITH CHECK ADD  CONSTRAINT [C_CSC_Catalog_ID] CHECK  (([Catalog_ID]>(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[LIB].[C_CSC_Catalog_ID]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Source_Catalog]'))
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] CHECK CONSTRAINT [C_CSC_Catalog_ID]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[LIB].[C_CSC_Collection_ID]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Source_Catalog]'))
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog]  WITH CHECK ADD  CONSTRAINT [C_CSC_Collection_ID] CHECK  (([Collection_ID]>(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[LIB].[C_CSC_Collection_ID]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Source_Catalog]'))
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] CHECK CONSTRAINT [C_CSC_Collection_ID]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[Collection_Source_Insert]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [LIB].[Collection_Source_Insert]
ON  [LIB].[HSH_Collection_Source_Catalog]
INSTEAD OF INSERT
AS 

BEGIN

	INSERT INTO LIB.HSH_Collection_Source_Catalog (Collection_ID, Source_ID, Catalog_ID, Post_Date)
	SELECT Collection_ID, Source_ID, Catalog_ID, Post_Date
	FROM inserted AS tmp
	EXCEPT
	SELECT Collection_ID, Source_ID, Catalog_ID, Post_Date
	FROM LIB.HSH_Collection_Source_Catalog

END
' 
GO
