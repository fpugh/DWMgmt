CREATE TABLE [LIB].[REG_Collections] (
    [Collection_ID] INT             IDENTITY (0, 1) NOT NULL,
    [Name]          NVARCHAR (256)  NOT NULL,
    [Description]   NVARCHAR (4000) NULL,
    [Curator]       NVARCHAR (256)  NULL,
    [Post_Date]     DATETIME        CONSTRAINT [DF_Collections_Post] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_LIB_Collections] PRIMARY KEY CLUSTERED ([Collection_ID] ASC, [Name] ASC),
    CONSTRAINT [UQ_Collections_IDKey] UNIQUE NONCLUSTERED ([Collection_ID] ASC)
);


GO

CREATE TRIGGER [LIB].[Collections_Insert]
ON  [LIB].[REG_Collections]
INSTEAD OF INSERT
AS 

BEGIN
	
	INSERT INTO LIB.REG_Collections ([Name], [Description], [Curator])
	SELECT [Name], [Description], [Curator]
	FROM inserted AS tmp
	EXCEPT
	SELECT [Name], [Description], [Curator]
	FROM LIB.REG_Collections

END