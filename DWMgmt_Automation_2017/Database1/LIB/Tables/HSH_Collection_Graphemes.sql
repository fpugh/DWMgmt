CREATE TABLE [LIB].[HSH_Collection_Graphemes] (
    [Hash_ID]       INT      IDENTITY (1, 1) NOT NULL,
    [Collection_ID] INT      NOT NULL,
    [Source_ID]     INT      NOT NULL,
    [Graph_ID]      INT      NOT NULL,
    [Post_Date]     DATETIME CONSTRAINT [DF_HSH_Graphemes_Post_Date] DEFAULT (getdate()) NOT NULL,
    [Use_Count]     INT      CONSTRAINT [DF_HSH_Graphemes_Uses] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_LIB_Collection_Graphemes] PRIMARY KEY NONCLUSTERED ([Collection_ID] ASC, [Source_ID] ASC, [Graph_ID] ASC),
    CONSTRAINT [FK_HSH_CGraphemes_REG_Collections] FOREIGN KEY ([Collection_ID]) REFERENCES [LIB].[REG_Collections] ([Collection_ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_HSH_CGraphemes_REG_Graphemes] FOREIGN KEY ([Graph_ID]) REFERENCES [LIB].[REG_Graphemes] ([Graph_ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_HSH_CGraphemes_REG_Sources] FOREIGN KEY ([Source_ID]) REFERENCES [LIB].[REG_Sources] ([Source_ID]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO


CREATE TRIGGER [LIB].[Collection_Grapheme_Insert]
ON  [LIB].[HSH_Collection_Graphemes]
INSTEAD OF INSERT
AS 

BEGIN

	/* Grapheme should be fully preloaded with all 69302 ASCII value pairs 
		Inserting new values to the Grapheme list us not required, but 
		statistical updates to the collection hash table is. 
	*/

	INSERT INTO LIB.HSH_Collection_Graphemes (Collection_ID, Source_ID, Graph_ID, Use_Count)
	
	SELECT src.Collection_ID, src.Source_ID, src.Graph_ID, src.Use_Count
	FROM inserted AS src
	JOIN (
		SELECT Collection_ID, Source_ID, Graph_ID
		FROM inserted
		EXCEPT
		SELECT Collection_ID, Source_ID, Graph_ID
		FROM LIB.HSH_Collection_Graphemes
		) AS sub
	ON sub.Collection_ID = src.Collection_ID
	AND sub.Source_ID = src.Source_ID
	AND sub.Graph_ID = src.Graph_ID

END