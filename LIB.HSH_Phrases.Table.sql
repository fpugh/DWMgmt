USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_Phrases_REG_Dictionary]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Phrases]'))
ALTER TABLE [LIB].[HSH_Phrases] DROP CONSTRAINT [FK_HSH_Phrases_REG_Dictionary]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_Phrases_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Phrases]'))
ALTER TABLE [LIB].[HSH_Phrases] DROP CONSTRAINT [FK_HSH_Phrases_REG_Collections]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Phrase_Uses]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Phrases] DROP CONSTRAINT [DF_HSH_Phrase_Uses]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Phrase_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Phrases] DROP CONSTRAINT [DF_HSH_Phrase_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Phrase_Position]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Phrases] DROP CONSTRAINT [DF_HSH_Phrase_Position]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Phrase_Collection_ID]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Phrases] DROP CONSTRAINT [DF_HSH_Phrase_Collection_ID]
END

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Phrases]') AND name = N'IDX_CI_HSH_Phrases_K6')
DROP INDEX [IDX_CI_HSH_Phrases_K6] ON [LIB].[HSH_Phrases] WITH ( ONLINE = OFF )
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Phrases]') AND type in (N'U'))
DROP TABLE [LIB].[HSH_Phrases]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Phrases]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[HSH_Phrases](
	[Hash_ID] [int] IDENTITY(1,1) NOT NULL,
	[Collection_ID] [int] NOT NULL,
	[Word_ID] [bigint] NOT NULL,
	[Position] [int] NOT NULL,
	[Post_Date] [datetime] NOT NULL,
	[Use_Count] [int] NOT NULL,
 CONSTRAINT [PK_LIB_Phrases] PRIMARY KEY NONCLUSTERED 
(
	[Collection_ID] ASC,
	[Word_ID] ASC,
	[Position] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_HSH_Phrase_ID] UNIQUE NONCLUSTERED 
(
	[Hash_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Phrases]') AND name = N'IDX_CI_HSH_Phrases_K6')
CREATE CLUSTERED INDEX [IDX_CI_HSH_Phrases_K6] ON [LIB].[HSH_Phrases]
(
	[Use_Count] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Phrase_Collection_ID]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Phrases] ADD  CONSTRAINT [DF_HSH_Phrase_Collection_ID]  DEFAULT ((0)) FOR [Collection_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Phrase_Position]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Phrases] ADD  CONSTRAINT [DF_HSH_Phrase_Position]  DEFAULT ((0)) FOR [Position]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Phrase_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Phrases] ADD  CONSTRAINT [DF_HSH_Phrase_Post_Date]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_Phrase_Uses]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Phrases] ADD  CONSTRAINT [DF_HSH_Phrase_Uses]  DEFAULT ((0)) FOR [Use_Count]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_Phrases_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Phrases]'))
ALTER TABLE [LIB].[HSH_Phrases]  WITH CHECK ADD  CONSTRAINT [FK_HSH_Phrases_REG_Collections] FOREIGN KEY([Collection_ID])
REFERENCES [LIB].[REG_Collections] ([Collection_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_Phrases_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Phrases]'))
ALTER TABLE [LIB].[HSH_Phrases] CHECK CONSTRAINT [FK_HSH_Phrases_REG_Collections]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_Phrases_REG_Dictionary]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Phrases]'))
ALTER TABLE [LIB].[HSH_Phrases]  WITH CHECK ADD  CONSTRAINT [FK_HSH_Phrases_REG_Dictionary] FOREIGN KEY([Word_ID])
REFERENCES [LIB].[REG_Dictionary] ([Word_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_Phrases_REG_Dictionary]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Phrases]'))
ALTER TABLE [LIB].[HSH_Phrases] CHECK CONSTRAINT [FK_HSH_Phrases_REG_Dictionary]
GO
