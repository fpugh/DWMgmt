CREATE TABLE [LIB].[HSH_Word_Categories] (
    [Hash_ID]       INT      IDENTITY (1, 1) NOT NULL,
    [Collection_ID] INT      NOT NULL,
    [Word_ID]       INT      NOT NULL,
    [Category_ID]   INT      NOT NULL,
    [Post_Date]     DATETIME NOT NULL,
    [Term_Date]     DATETIME NOT NULL,
    CONSTRAINT [PK_LIB_Word_Categories] PRIMARY KEY CLUSTERED ([Collection_ID] ASC, [Word_ID] ASC, [Category_ID] ASC),
    CONSTRAINT [FK_HSH_WordCat_REG_Categories] FOREIGN KEY ([Category_ID]) REFERENCES [LIB].[REG_Categories] ([Category_ID]),
    CONSTRAINT [FK_HSH_WordCat_REG_Collections] FOREIGN KEY ([Collection_ID]) REFERENCES [LIB].[REG_Collections] ([Collection_ID]),
    CONSTRAINT [UQ_HSH_Word_Cat_ID] UNIQUE NONCLUSTERED ([Hash_ID] ASC)
);

