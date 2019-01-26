CREATE TABLE [LIB].[HSH_Collection_Source_Catalog] (
    [Hash_ID]       INT      IDENTITY (1, 1) NOT NULL,
    [Collection_ID] INT      NOT NULL,
    [Source_ID]     INT      CONSTRAINT [D_CSC_Source_ID] DEFAULT ((0)) NOT NULL,
    [Catalog_ID]    INT      NOT NULL,
    [Post_Date]     DATETIME CONSTRAINT [DF_HSH_CSC_Post_Date] DEFAULT (getdate()) NOT NULL,
    [Term_Date]     DATETIME CONSTRAINT [DF_HSH_CSC_Term_Date] DEFAULT ('12/31/2099') NOT NULL,
    CONSTRAINT [PK_CollectionSourceCatalog] PRIMARY KEY CLUSTERED ([Collection_ID] ASC, [Source_ID] ASC, [Catalog_ID] ASC, [Post_Date] ASC),
    CONSTRAINT [C_CSC_Catalog_ID] CHECK ([Catalog_ID]>(0)),
    CONSTRAINT [C_CSC_Collection_ID] CHECK ([Collection_ID]>(0)),
    CONSTRAINT [FK_CSC_REG_0300_Object_registry] FOREIGN KEY ([Catalog_ID]) REFERENCES [CAT].[REG_0300_Object_Registry] ([REG_0300_ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_CSC_REG_Collections] FOREIGN KEY ([Collection_ID]) REFERENCES [LIB].[REG_Collections] ([Collection_ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [UQ_CSC_Hash_ID] UNIQUE NONCLUSTERED ([Hash_ID] ASC)
);


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