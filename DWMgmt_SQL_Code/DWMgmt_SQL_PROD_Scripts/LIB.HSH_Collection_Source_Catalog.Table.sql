USE [DWMgmt]
GO


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
GO
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] ADD  CONSTRAINT [D_CSC_Source_ID]  DEFAULT ((0)) FOR [Source_ID]
GO
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] ADD  CONSTRAINT [DF_HSH_CSC_Post_Date]  DEFAULT (getdate()) FOR [Post_Date]
GO
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] ADD  CONSTRAINT [DF_HSH_CSC_Term_Date]  DEFAULT ('12/31/2099') FOR [Term_Date]
GO

ALTER TABLE [LIB].[HSH_Collection_Source_Catalog]  WITH CHECK ADD  CONSTRAINT [FK_CSC_REG_0300_Object_registry] FOREIGN KEY([Catalog_ID])
REFERENCES [CAT].[REG_0300_Object_Registry] ([REG_0300_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] CHECK CONSTRAINT [FK_CSC_REG_0300_Object_registry]
GO

ALTER TABLE [LIB].[HSH_Collection_Source_Catalog]  WITH CHECK ADD  CONSTRAINT [FK_CSC_REG_Collections] FOREIGN KEY([Collection_ID])
REFERENCES [LIB].[REG_Collections] ([Collection_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] CHECK CONSTRAINT [FK_CSC_REG_Collections]
GO

ALTER TABLE [LIB].[HSH_Collection_Source_Catalog]  WITH CHECK ADD  CONSTRAINT [C_CSC_Catalog_ID] CHECK  (([Catalog_ID]>(0)))
GO
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] CHECK CONSTRAINT [C_CSC_Catalog_ID]
GO
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog]  WITH CHECK ADD  CONSTRAINT [C_CSC_Collection_ID] CHECK  (([Collection_ID]>(0)))
GO
ALTER TABLE [LIB].[HSH_Collection_Source_Catalog] CHECK CONSTRAINT [C_CSC_Collection_ID]
GO


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

GO
