USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[Collection_Alphabet_Insert]'))
DROP TRIGGER [LIB].[Collection_Alphabet_Insert]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CA_REG_Sources]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Alphabet]'))
ALTER TABLE [LIB].[HSH_Collection_Alphabet] DROP CONSTRAINT [FK_HSH_CA_REG_Sources]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CA_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Alphabet]'))
ALTER TABLE [LIB].[HSH_Collection_Alphabet] DROP CONSTRAINT [FK_HSH_CA_REG_Collections]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CA_REG_Alphabet]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Alphabet]'))
ALTER TABLE [LIB].[HSH_Collection_Alphabet] DROP CONSTRAINT [FK_HSH_CA_REG_Alphabet]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_CA_Uses]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Alphabet] DROP CONSTRAINT [DF_HSH_CA_Uses]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_CA_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Alphabet] DROP CONSTRAINT [DF_HSH_CA_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Alphabet]') AND type in (N'U'))
DROP TABLE [LIB].[HSH_Collection_Alphabet]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Alphabet]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[HSH_Collection_Alphabet](
	[Hash_ID] [int] IDENTITY(1,1) NOT NULL,
	[Collection_ID] [int] NOT NULL,
	[Source_ID] [int] NOT NULL,
	[ASCII_Char] [tinyint] NOT NULL,
	[Post_Date] [datetime] NOT NULL,
	[Use_Count] [int] NOT NULL,
 CONSTRAINT [PK_LIB_Collection_Alphabet] PRIMARY KEY NONCLUSTERED 
(
	[Collection_ID] ASC,
	[Source_ID] ASC,
	[ASCII_Char] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_CA_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Alphabet] ADD  CONSTRAINT [DF_HSH_CA_Post_Date]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_CA_Uses]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Alphabet] ADD  CONSTRAINT [DF_HSH_CA_Uses]  DEFAULT ((0)) FOR [Use_Count]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CA_REG_Alphabet]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Alphabet]'))
ALTER TABLE [LIB].[HSH_Collection_Alphabet]  WITH CHECK ADD  CONSTRAINT [FK_HSH_CA_REG_Alphabet] FOREIGN KEY([ASCII_Char])
REFERENCES [LIB].[REG_Alphabet] ([ASCII_Char])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CA_REG_Alphabet]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Alphabet]'))
ALTER TABLE [LIB].[HSH_Collection_Alphabet] CHECK CONSTRAINT [FK_HSH_CA_REG_Alphabet]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CA_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Alphabet]'))
ALTER TABLE [LIB].[HSH_Collection_Alphabet]  WITH CHECK ADD  CONSTRAINT [FK_HSH_CA_REG_Collections] FOREIGN KEY([Collection_ID])
REFERENCES [LIB].[REG_Collections] ([Collection_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CA_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Alphabet]'))
ALTER TABLE [LIB].[HSH_Collection_Alphabet] CHECK CONSTRAINT [FK_HSH_CA_REG_Collections]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CA_REG_Sources]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Alphabet]'))
ALTER TABLE [LIB].[HSH_Collection_Alphabet]  WITH CHECK ADD  CONSTRAINT [FK_HSH_CA_REG_Sources] FOREIGN KEY([Source_ID])
REFERENCES [LIB].[REG_Sources] ([Source_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_CA_REG_Sources]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Alphabet]'))
ALTER TABLE [LIB].[HSH_Collection_Alphabet] CHECK CONSTRAINT [FK_HSH_CA_REG_Sources]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[Collection_Alphabet_Insert]'))
EXEC dbo.sp_executesql @statement = N'


CREATE TRIGGER [LIB].[Collection_Alphabet_Insert]
ON  [LIB].[HSH_Collection_Alphabet]
INSTEAD OF INSERT
AS 

BEGIN

	INSERT INTO LIB.HSH_Collection_Alphabet (Collection_ID, Source_ID, ASCII_Char, Use_Count)
	SELECT Collection_ID, Source_ID, ASCII_Char, Use_Count
	FROM Inserted
	EXCEPT
	SELECT Collection_ID, Source_ID, ASCII_Char, Use_Count
	FROM LIB.HSH_Collection_Alphabet

END

' 
GO
