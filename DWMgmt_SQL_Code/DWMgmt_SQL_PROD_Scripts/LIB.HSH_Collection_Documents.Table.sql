USE [DWMgmt]
GO


CREATE TABLE [LIB].[HSH_Collection_Documents](
	[Hash_ID] [int] IDENTITY(1,1) NOT NULL,
	[Collection_ID] [int] NOT NULL,
	[Source_ID] [int] NOT NULL,
	[Document_ID] [int] NOT NULL,
	[Post_Date] [datetime] NOT NULL,
	[Term_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_CXD] PRIMARY KEY CLUSTERED 
(
	[Collection_ID] ASC,
	[Source_ID] ASC,
	[Document_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_CXD_Hash_ID] UNIQUE NONCLUSTERED 
(
	[Hash_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [LIB].[HSH_Collection_Documents] ADD  CONSTRAINT [D_CXD_Source_ID]  DEFAULT ((0)) FOR [Source_ID]
GO

ALTER TABLE [LIB].[HSH_Collection_Documents] ADD  CONSTRAINT [DF_HSH_CXD_Post_Date]  DEFAULT (getdate()) FOR [Post_Date]
GO

ALTER TABLE [LIB].[HSH_Collection_Documents] ADD  CONSTRAINT [DF_HSH_CXD_Term_Date]  DEFAULT ('12/31/2099') FOR [Term_Date]
GO


ALTER TABLE [LIB].[HSH_Collection_Documents]  WITH CHECK ADD  CONSTRAINT [FK_CXD_REG_Collections] FOREIGN KEY([Collection_ID])
REFERENCES [LIB].[REG_Collections] ([Collection_ID])
GO

ALTER TABLE [LIB].[HSH_Collection_Documents] CHECK CONSTRAINT [FK_CXD_REG_Collections]
GO


ALTER TABLE [LIB].[HSH_Collection_Documents]  WITH CHECK ADD  CONSTRAINT [FK_CXD_REG_Documents] FOREIGN KEY([Document_ID])
REFERENCES [LIB].[REG_Documents] ([Document_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [LIB].[HSH_Collection_Documents] CHECK CONSTRAINT [FK_CXD_REG_Documents]
GO


ALTER TABLE [LIB].[HSH_Collection_Documents]  WITH CHECK ADD  CONSTRAINT [FK_CXD_REG_Sources] FOREIGN KEY([Source_ID])
REFERENCES [LIB].[REG_Sources] ([Source_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [LIB].[HSH_Collection_Documents] CHECK CONSTRAINT [FK_CXD_REG_Sources]
GO



CREATE TRIGGER [LIB].[Collection_Document_Insert]
ON  [LIB].[HSH_Collection_Documents]
INSTEAD OF INSERT
AS 

BEGIN

	/* Document Source_ID should indicate unqiqueness of the document
		as the VersionStamp should detect variances of the source file.
	*/

	INSERT INTO LIB.HSH_Collection_Documents (Collection_ID, Source_ID, Document_ID)

	SELECT src.Collection_ID, src.Source_ID, src.Document_ID
	FROM Inserted AS src
	EXCEPT
	SELECT Collection_ID, Source_ID, Document_ID
	FROM LIB.HSH_Collection_Documents

END
