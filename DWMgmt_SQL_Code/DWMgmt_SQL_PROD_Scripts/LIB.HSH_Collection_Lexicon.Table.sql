USE [DWMgmt]
GO


CREATE TABLE [LIB].[HSH_Collection_Lexicon](
	[Hash_ID] [int] IDENTITY(1,1) NOT NULL,
	[Collection_ID] [int] NOT NULL,
	[Source_ID] [int] NOT NULL,
	[Column_ID] [int] NOT NULL,
	[Word_ID] [bigint] NOT NULL,
	[Post_Date] [datetime] NOT NULL,
	[Use_Count] [int] NOT NULL,
 CONSTRAINT [PK_LIB_Collection_Lexicon] PRIMARY KEY NONCLUSTERED 
(
	[Collection_ID] ASC,
	[Source_ID] ASC,
	[Column_ID] ASC,
	[Word_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_nc_HSH_Collection_Lexicon_K2_K3_I5_I7]
ON [LIB].[HSH_Collection_Lexicon] ([Collection_ID],[Source_ID])
INCLUDE ([Word_ID],[Use_Count])
GO

ALTER TABLE [LIB].[HSH_Collection_Lexicon] ADD  CONSTRAINT [DF_Column_ID_0]  DEFAULT ((0)) FOR [Column_ID]
GO
ALTER TABLE [LIB].[HSH_Collection_Lexicon] ADD  CONSTRAINT [DF_HSH_Lex_Post]  DEFAULT (getdate()) FOR [Post_Date]
GO
ALTER TABLE [LIB].[HSH_Collection_Lexicon] ADD  CONSTRAINT [DF_HSH_Lex_Uses]  DEFAULT ((0)) FOR [Use_Count]
GO

ALTER TABLE [LIB].[HSH_Collection_Lexicon]  WITH CHECK ADD  CONSTRAINT [FK_Lex_REG_Collections] FOREIGN KEY([Collection_ID])
REFERENCES [LIB].[REG_Collections] ([Collection_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [LIB].[HSH_Collection_Lexicon] CHECK CONSTRAINT [FK_Lex_REG_Collections]
GO

ALTER TABLE [LIB].[HSH_Collection_Lexicon]  WITH CHECK ADD  CONSTRAINT [FK_Lex_REG_Dictionary] FOREIGN KEY([Word_ID])
REFERENCES [LIB].[REG_Dictionary] ([Word_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [LIB].[HSH_Collection_Lexicon] CHECK CONSTRAINT [FK_Lex_REG_Dictionary]
GO

ALTER TABLE [LIB].[HSH_Collection_Lexicon]  WITH CHECK ADD  CONSTRAINT [FK_Lex_REG_Sources] FOREIGN KEY([Source_ID])
REFERENCES [LIB].[REG_Sources] ([Source_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [LIB].[HSH_Collection_Lexicon] CHECK CONSTRAINT [FK_Lex_REG_Sources]
GO


CREATE TRIGGER [LIB].[Collection_Lexicon_Insert]
ON  [LIB].[HSH_Collection_Lexicon]
INSTEAD OF INSERT
AS 

BEGIN

	/* Inserts unique code blocks into the REG_Dictionary Table
		Updates the collection hash table with the current use count.
	*/

	INSERT INTO LIB.HSH_Collection_Lexicon (Collection_ID, Source_ID, Column_ID, Word_ID)
	SELECT Collection_ID, Source_ID, Column_ID, Word_ID
	FROM Inserted
	EXCEPT
	SELECT Collection_ID, Source_ID, Column_ID, Word_ID
	FROM LIB.HSH_Collection_Lexicon

	UPDATE hsh SET Use_Count = hsh.Use_Count + ins.Use_Count
	FROM LIB.HSH_Collection_Lexicon AS hsh
	JOIN Inserted AS ins
	ON ins.Collection_ID = hsh.Collection_ID
	AND ins.Source_ID = hsh.Source_ID
	AND ins.Column_ID = hsh.Column_ID
	AND ins.Word_ID = hsh.Word_ID

END