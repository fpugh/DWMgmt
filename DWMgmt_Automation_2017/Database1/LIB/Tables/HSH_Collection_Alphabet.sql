CREATE TABLE [LIB].[HSH_Collection_Alphabet] (
    [Hash_ID]       INT      IDENTITY (1, 1) NOT NULL,
    [Collection_ID] INT      NOT NULL,
    [Source_ID]     INT      NOT NULL,
    [ASCII_Char]    TINYINT  NOT NULL,
    [Post_Date]     DATETIME CONSTRAINT [DF_HSH_CA_Post_Date] DEFAULT (getdate()) NOT NULL,
    [Use_Count]     INT      CONSTRAINT [DF_HSH_CA_Uses] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_LIB_Collection_Alphabet] PRIMARY KEY NONCLUSTERED ([Collection_ID] ASC, [Source_ID] ASC, [ASCII_Char] ASC),
    CONSTRAINT [FK_HSH_CA_REG_Alphabet] FOREIGN KEY ([ASCII_Char]) REFERENCES [LIB].[REG_Alphabet] ([ASCII_Char]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_HSH_CA_REG_Collections] FOREIGN KEY ([Collection_ID]) REFERENCES [LIB].[REG_Collections] ([Collection_ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_HSH_CA_REG_Sources] FOREIGN KEY ([Source_ID]) REFERENCES [LIB].[REG_Sources] ([Source_ID]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO


CREATE TRIGGER [LIB].[Collection_Alphabet_Insert]
ON  [LIB].[HSH_Collection_Alphabet]
INSTEAD OF INSERT
AS 

BEGIN

	/* Alphabet should be fully preloaded with all 256 ASCII values 
		Inserting new values to Alphabet not required, but 
		statistical update is.
	*/

	INSERT INTO LIB.HSH_Collection_Alphabet (Collection_ID, Source_ID, ASCII_Char, Use_Count)
	SELECT src.Collection_ID, src.Source_ID, src.ASCII_Char, src.Use_Count
	FROM Inserted AS src
	JOIN (
		SELECT Collection_ID, Source_ID, ASCII_Char
		FROM Inserted
		EXCEPT
		SELECT Collection_ID, Source_ID, ASCII_Char
		FROM LIB.HSH_Collection_Alphabet
		) AS sub
	ON sub.Collection_ID = src.Collection_ID
	AND sub.Source_ID = src.Source_ID
	AND sub.ASCII_Char = src.ASCII_Char



END