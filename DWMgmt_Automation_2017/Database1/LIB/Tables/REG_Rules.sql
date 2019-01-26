CREATE TABLE [LIB].[REG_Rules] (
    [Rule_ID]   INT             IDENTITY (1, 1) NOT NULL,
    [Rule_Name] NVARCHAR (256)  NOT NULL,
    [Rule_Type] NVARCHAR (128)  NOT NULL,
    [Rule_Desc] NVARCHAR (4000) NULL,
    [Post_Date] DATETIME        CONSTRAINT [DF_Rules_Post] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Rules] PRIMARY KEY CLUSTERED ([Rule_Name] ASC, [Rule_Type] ASC),
    CONSTRAINT [UQ_Rule_IDKey] UNIQUE NONCLUSTERED ([Rule_ID] ASC)
);

