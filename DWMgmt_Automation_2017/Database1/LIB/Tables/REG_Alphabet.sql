CREATE TABLE [LIB].[REG_Alphabet] (
    [ASCII_Char] TINYINT   NOT NULL,
    [Char_Val]   NCHAR (1) NOT NULL,
    [Printable]  BIT       CONSTRAINT [DF_Alphabet_Print] DEFAULT ((0)) NOT NULL,
    [Post_Date]  DATETIME  CONSTRAINT [DF_Alphabet_Post] DEFAULT (getdate()) NOT NULL,
    [Class_VCNS] NCHAR (1) DEFAULT ('C') NULL,
    CONSTRAINT [PK_Alphabet] PRIMARY KEY CLUSTERED ([ASCII_Char] ASC)
);

