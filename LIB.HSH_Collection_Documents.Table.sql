USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[Collection_Documents_Insert]'))
DROP TRIGGER [LIB].[Collection_Documents_Insert]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_CXD_REG_Sources]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Documents]'))
ALTER TABLE [LIB].[HSH_Collection_Documents] DROP CONSTRAINT [FK_CXD_REG_Sources]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_CXD_REG_Documents]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Documents]'))
ALTER TABLE [LIB].[HSH_Collection_Documents] DROP CONSTRAINT [FK_CXD_REG_Documents]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_CXD_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Documents]'))
ALTER TABLE [LIB].[HSH_Collection_Documents] DROP CONSTRAINT [FK_CXD_REG_Collections]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_CXD_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Documents] DROP CONSTRAINT [DF_HSH_CXD_Term_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_CXD_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Documents] DROP CONSTRAINT [DF_HSH_CXD_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[D_CXD_Source_ID]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Documents] DROP CONSTRAINT [D_CXD_Source_ID]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Documents]') AND type in (N'U'))
DROP TABLE [LIB].[HSH_Collection_Documents]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Documents]') AND type in (N'U'))
BEGIN
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
	[Document_ID] ASC,
	[Post_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_CXD_Hash_ID] UNIQUE NONCLUSTERED 
(
	[Hash_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[D_CXD_Source_ID]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Documents] ADD  CONSTRAINT [D_CXD_Source_ID]  DEFAULT ((0)) FOR [Source_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_CXD_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Documents] ADD  CONSTRAINT [DF_HSH_CXD_Post_Date]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HSH_CXD_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Documents] ADD  CONSTRAINT [DF_HSH_CXD_Term_Date]  DEFAULT ('12/31/2099') FOR [Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_CXD_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Documents]'))
ALTER TABLE [LIB].[HSH_Collection_Documents]  WITH CHECK ADD  CONSTRAINT [FK_CXD_REG_Collections] FOREIGN KEY([Collection_ID])
REFERENCES [LIB].[REG_Collections] ([Collection_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_CXD_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Documents]'))
ALTER TABLE [LIB].[HSH_Collection_Documents] CHECK CONSTRAINT [FK_CXD_REG_Collections]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_CXD_REG_Documents]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Documents]'))
ALTER TABLE [LIB].[HSH_Collection_Documents]  WITH CHECK ADD  CONSTRAINT [FK_CXD_REG_Documents] FOREIGN KEY([Document_ID])
REFERENCES [LIB].[REG_Documents] ([Document_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_CXD_REG_Documents]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Documents]'))
ALTER TABLE [LIB].[HSH_Collection_Documents] CHECK CONSTRAINT [FK_CXD_REG_Documents]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_CXD_REG_Sources]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Documents]'))
ALTER TABLE [LIB].[HSH_Collection_Documents]  WITH CHECK ADD  CONSTRAINT [FK_CXD_REG_Sources] FOREIGN KEY([Source_ID])
REFERENCES [LIB].[REG_Sources] ([Source_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_CXD_REG_Sources]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Documents]'))
ALTER TABLE [LIB].[HSH_Collection_Documents] CHECK CONSTRAINT [FK_CXD_REG_Sources]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[Collection_Documents_Insert]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [LIB].[Collection_Documents_Insert]
ON  [LIB].[HSH_Collection_Documents]
INSTEAD OF INSERT
AS 

BEGIN

	INSERT INTO LIB.HSH_Collection_Documents (Collection_ID, Source_ID, Document_ID, Post_Date)
	SELECT Collection_ID, Source_ID, Document_ID, Post_Date
	FROM inserted AS tmp
	EXCEPT
	SELECT Collection_ID, Source_ID, Document_ID, Post_Date
	FROM LIB.HSH_Collection_Documents

END

' 
GO
