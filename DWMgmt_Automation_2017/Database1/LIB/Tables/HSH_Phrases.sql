CREATE TABLE [LIB].[HSH_Phrases] (
    [Hash_ID]       INT      IDENTITY (1, 1) NOT NULL,
    [Collection_ID] INT      NOT NULL,
    [Word_ID]       INT      NOT NULL,
    [Position]      INT      NOT NULL,
    [Post_Date]     DATETIME NOT NULL,
    [Use_Count]     INT      NOT NULL,
    CONSTRAINT [PK_LIB_Phrases] PRIMARY KEY NONCLUSTERED ([Collection_ID] ASC, [Word_ID] ASC, [Position] ASC),
    CONSTRAINT [FK_HSH_Phrases_REG_Collections] FOREIGN KEY ([Collection_ID]) REFERENCES [LIB].[REG_Collections] ([Collection_ID]),
    CONSTRAINT [UQ_HSH_Phrase_ID] UNIQUE NONCLUSTERED ([Hash_ID] ASC)
);

