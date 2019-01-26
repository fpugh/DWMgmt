CREATE TABLE [LIB].[REG_Documents] (
    [Document_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [Title]        NVARCHAR (256) NOT NULL,
    [Author]       NVARCHAR (128) NOT NULL,
    [Created_Date] DATETIME       NOT NULL,
    CONSTRAINT [PK_LIB_Documents] PRIMARY KEY NONCLUSTERED ([Title] ASC, [Author] ASC, [Created_Date] ASC),
    CONSTRAINT [UQ_LRD_Document_ID] UNIQUE NONCLUSTERED ([Document_ID] ASC)
);

