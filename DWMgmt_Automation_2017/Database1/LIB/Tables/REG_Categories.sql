CREATE TABLE [LIB].[REG_Categories] (
    [Category_ID] INT             IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (256)  NOT NULL,
    [Description] NVARCHAR (2000) NOT NULL,
    [Post_Date]   DATETIME        CONSTRAINT [DF_Categories_Post] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED ([Name] ASC),
    CONSTRAINT [UQ_Category_IDKey] UNIQUE NONCLUSTERED ([Category_ID] ASC)
);

