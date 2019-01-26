CREATE TABLE [LIB].[REG_Graphemes] (
    [Graph_ID]    INT       IDENTITY (1, 1) NOT NULL,
    [ASCII_Char1] TINYINT   NOT NULL,
    [ASCII_Char2] TINYINT   NOT NULL,
    [Post_Date]   DATETIME  CONSTRAINT [DF_Morphemes_Post] DEFAULT (getdate()) NOT NULL,
    [Use_Class]   NCHAR (2) DEFAULT ('FS') NOT NULL,
    CONSTRAINT [PK_LIB_Graphemes] PRIMARY KEY NONCLUSTERED ([ASCII_Char1] ASC, [ASCII_Char2] ASC, [Use_Class] ASC),
    CONSTRAINT [FK_Morphemes_Alphabet1] FOREIGN KEY ([ASCII_Char1]) REFERENCES [LIB].[REG_Alphabet] ([ASCII_Char]),
    CONSTRAINT [FK_Morphemes_Alphabet2] FOREIGN KEY ([ASCII_Char2]) REFERENCES [LIB].[REG_Alphabet] ([ASCII_Char]),
    CONSTRAINT [UQ_Morphemes_IDKey] UNIQUE NONCLUSTERED ([Graph_ID] ASC)
);

