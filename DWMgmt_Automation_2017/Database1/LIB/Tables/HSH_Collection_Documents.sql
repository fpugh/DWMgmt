CREATE TABLE [LIB].[HSH_Collection_Documents] (
    [Hash_ID]       INT      IDENTITY (1, 1) NOT NULL,
    [Collection_ID] INT      NOT NULL,
    [Source_ID]     INT      CONSTRAINT [D_CXD_Source_ID] DEFAULT ((0)) NOT NULL,
    [Document_ID]   INT      NOT NULL,
    [Post_Date]     DATETIME CONSTRAINT [DF_HSH_CXD_Post_Date] DEFAULT (getdate()) NOT NULL,
    [Term_Date]     DATETIME CONSTRAINT [DF_HSH_CXD_Term_Date] DEFAULT ('12/31/2099') NOT NULL,
    CONSTRAINT [PK_CXD] PRIMARY KEY CLUSTERED ([Collection_ID] ASC, [Source_ID] ASC, [Document_ID] ASC),
    CONSTRAINT [FK_CXD_REG_Collections] FOREIGN KEY ([Collection_ID]) REFERENCES [LIB].[REG_Collections] ([Collection_ID]),
    CONSTRAINT [FK_CXD_REG_Documents] FOREIGN KEY ([Document_ID]) REFERENCES [LIB].[REG_Documents] ([Document_ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_CXD_REG_Sources] FOREIGN KEY ([Source_ID]) REFERENCES [LIB].[REG_Sources] ([Source_ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [UQ_CXD_Hash_ID] UNIQUE NONCLUSTERED ([Hash_ID] ASC)
);


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