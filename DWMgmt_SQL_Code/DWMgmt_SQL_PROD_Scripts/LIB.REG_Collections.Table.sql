USE [DWMgmt]
GO


CREATE TABLE [LIB].[REG_Collections](
	[Collection_ID] [int] IDENTITY(0,1) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[Description] [nvarchar](4000) NULL,
	[Curator] [nvarchar](256) NULL,
	[Post_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_LIB_Collections] PRIMARY KEY CLUSTERED 
(
	[Collection_ID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Collections_IDKey] UNIQUE NONCLUSTERED 
(
	[Collection_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [LIB].[REG_Collections] ADD  CONSTRAINT [DF_Collections_Post]  DEFAULT (getdate()) FOR [Post_Date]
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