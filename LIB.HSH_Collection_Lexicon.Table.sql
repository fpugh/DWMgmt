USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[Collection_Lexicon_Insert]'))
DROP TRIGGER [LIB].[Collection_Lexicon_Insert]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_Lex_REG_Sources]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Lexicon]'))
ALTER TABLE [LIB].[HSH_Collection_Lexicon] DROP CONSTRAINT [FK_Lex_REG_Sources]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_Lex_REG_Dictionary]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Lexicon]'))
ALTER TABLE [LIB].[HSH_Collection_Lexicon] DROP CONSTRAINT [FK_Lex_REG_Dictionary]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_Lex_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Lexicon]'))
ALTER TABLE [LIB].[HSH_Collection_Lexicon] DROP CONSTRAINT [FK_Lex_REG_Collections]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Lex_Uses]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Lexicon] DROP CONSTRAINT [DF_HSH_Lex_Uses]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Lex_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Lexicon] DROP CONSTRAINT [DF_HSH_Lex_Term_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Lex_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Lexicon] DROP CONSTRAINT [DF_HSH_Lex_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[D_Column_ID_0]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Lexicon] DROP CONSTRAINT [D_Column_ID_0]
END

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Lexicon]') AND name = N'IDX_CI_LIB_Collection_Lexicon')
DROP INDEX [IDX_CI_LIB_Collection_Lexicon] ON [LIB].[HSH_Collection_Lexicon] WITH ( ONLINE = OFF )
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Lexicon]') AND type in (N'U'))
DROP TABLE [LIB].[HSH_Collection_Lexicon]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Lexicon]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[HSH_Collection_Lexicon](
	[Hash_ID] [int] IDENTITY(1,1) NOT NULL,
	[Collection_ID] [int] NOT NULL,
	[Source_ID] [int] NOT NULL,
	[Column_ID] [int] NOT NULL,
	[Word_ID] [bigint] NOT NULL,
	[Post_Date] [datetime] NOT NULL,
	[Term_Date] [datetime] NOT NULL,
	[Use_Count] [int] NOT NULL,
 CONSTRAINT [PK_LIB_Collection_Lexicon] PRIMARY KEY NONCLUSTERED 
(
	[Collection_ID] ASC,
	[Source_ID] ASC,
	[Column_ID] ASC,
	[Word_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Lexicon]') AND name = N'IDX_CI_LIB_Collection_Lexicon')
CREATE CLUSTERED INDEX [IDX_CI_LIB_Collection_Lexicon] ON [LIB].[HSH_Collection_Lexicon]
(
	[Term_Date] DESC,
	[Use_Count] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[D_Column_ID_0]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Lexicon] ADD  CONSTRAINT [D_Column_ID_0]  DEFAULT ((0)) FOR [Column_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Lex_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Lexicon] ADD  CONSTRAINT [DF_HSH_Lex_Post_Date]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Lex_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Lexicon] ADD  CONSTRAINT [DF_HSH_Lex_Term_Date]  DEFAULT ('12/31/2013') FOR [Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Lex_Uses]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Lexicon] ADD  CONSTRAINT [DF_HSH_Lex_Uses]  DEFAULT ((0)) FOR [Use_Count]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_Lex_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Lexicon]'))
ALTER TABLE [LIB].[HSH_Collection_Lexicon]  WITH CHECK ADD  CONSTRAINT [FK_Lex_REG_Collections] FOREIGN KEY([Collection_ID])
REFERENCES [LIB].[REG_Collections] ([Collection_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_Lex_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Lexicon]'))
ALTER TABLE [LIB].[HSH_Collection_Lexicon] CHECK CONSTRAINT [FK_Lex_REG_Collections]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_Lex_REG_Dictionary]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Lexicon]'))
ALTER TABLE [LIB].[HSH_Collection_Lexicon]  WITH CHECK ADD  CONSTRAINT [FK_Lex_REG_Dictionary] FOREIGN KEY([Word_ID])
REFERENCES [LIB].[REG_Dictionary] ([Word_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_Lex_REG_Dictionary]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Lexicon]'))
ALTER TABLE [LIB].[HSH_Collection_Lexicon] CHECK CONSTRAINT [FK_Lex_REG_Dictionary]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_Lex_REG_Sources]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Lexicon]'))
ALTER TABLE [LIB].[HSH_Collection_Lexicon]  WITH CHECK ADD  CONSTRAINT [FK_Lex_REG_Sources] FOREIGN KEY([Source_ID])
REFERENCES [LIB].[REG_Sources] ([Source_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_Lex_REG_Sources]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Lexicon]'))
ALTER TABLE [LIB].[HSH_Collection_Lexicon] CHECK CONSTRAINT [FK_Lex_REG_Sources]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[Collection_Lexicon_Insert]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [LIB].[Collection_Lexicon_Insert]
ON  [LIB].[HSH_Collection_Lexicon]
INSTEAD OF INSERT
AS 

BEGIN
	
	INSERT INTO LIB.HSH_Collection_Lexicon (Collection_ID, Source_ID, Column_ID, Word_ID)
	SELECT Collection_ID, Source_ID, Column_ID, Word_ID
	FROM inserted AS tmp
	EXCEPT
	SELECT Collection_ID, Source_ID, Column_ID, Word_ID
	FROM LIB.HSH_Collection_Lexicon 

	UPDATE dic SET Use_Count = dic.Use_Count + ins.Use_Count
	FROM LIB.HSH_Collection_Lexicon AS dic
	JOIN inserted AS ins
	ON ins.Word_ID = dic.Word_ID
	AND ins.Column_ID = dic.Column_ID
	AND ins.Collection_ID = dic.Collection_ID
	AND ins.Source_ID != dic.Source_ID

END
' 
GO
