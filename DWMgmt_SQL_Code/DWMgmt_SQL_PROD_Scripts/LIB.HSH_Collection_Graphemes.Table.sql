USE [DWMgmt]
GO


CREATE TABLE [LIB].[HSH_Collection_Graphemes](
	[Hash_ID] [int] IDENTITY(1,1) NOT NULL,
	[Collection_ID] [int] NOT NULL,
	[Source_ID] [int] NOT NULL,
	[Graph_ID] [int] NOT NULL,
	[Post_Date] [datetime] NOT NULL,
	[Use_Count] [int] NOT NULL,
 CONSTRAINT [PK_LIB_Collection_Graphemes] PRIMARY KEY NONCLUSTERED 
(
	[Collection_ID] ASC,
	[Source_ID] ASC,
	[Graph_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [LIB].[HSH_Collection_Graphemes] ADD  CONSTRAINT [DF_HSH_Graphemes_Post_Date]  DEFAULT (getdate()) FOR [Post_Date]
GO
ALTER TABLE [LIB].[HSH_Collection_Graphemes] ADD  CONSTRAINT [DF_HSH_Graphemes_Uses]  DEFAULT ((0)) FOR [Use_Count]
GO


ALTER TABLE [LIB].[HSH_Collection_Graphemes]  WITH CHECK ADD  CONSTRAINT [FK_HSH_CGraphemes_REG_Collections] FOREIGN KEY([Collection_ID])
REFERENCES [LIB].[REG_Collections] ([Collection_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [LIB].[HSH_Collection_Graphemes] CHECK CONSTRAINT [FK_HSH_CGraphemes_REG_Collections]
GO

ALTER TABLE [LIB].[HSH_Collection_Graphemes]  WITH CHECK ADD  CONSTRAINT [FK_HSH_CGraphemes_REG_Graphemes] FOREIGN KEY([Graph_ID])
REFERENCES [LIB].[REG_Graphemes] ([Graph_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [LIB].[HSH_Collection_Graphemes] CHECK CONSTRAINT [FK_HSH_CGraphemes_REG_Graphemes]
GO

ALTER TABLE [LIB].[HSH_Collection_Graphemes]  WITH CHECK ADD  CONSTRAINT [FK_HSH_CGraphemes_REG_Sources] FOREIGN KEY([Source_ID])
REFERENCES [LIB].[REG_Sources] ([Source_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [LIB].[HSH_Collection_Graphemes] CHECK CONSTRAINT [FK_HSH_CGraphemes_REG_Sources]
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

GO
