CREATE TABLE [LIB].[REG_Dictionary] (
    [Word_ID]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [Word]      NVARCHAR (256) NOT NULL,
    [Post_Date] DATETIME       CONSTRAINT [DF_Dictionary_Post] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_LIB_Lexicon] PRIMARY KEY CLUSTERED ([Word] ASC),
    CONSTRAINT [UQ_Dictionary_WordID] UNIQUE NONCLUSTERED ([Word_ID] ASC)
);


GO




CREATE TRIGGER [LIB].[Dictionary_Insert]
ON  [LIB].[REG_Dictionary]
INSTEAD OF INSERT
AS 

BEGIN
	
	INSERT INTO LIB.REG_Dictionary (Word)
	SELECT Word
	FROM inserted AS tmp
	EXCEPT
	SELECT Word
	FROM LIB.REG_Dictionary

END