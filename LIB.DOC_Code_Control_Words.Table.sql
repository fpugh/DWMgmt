USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_DOC_CCW_REG_Dictionary]') AND parent_object_id = OBJECT_ID(N'[LIB].[DOC_Code_Control_Words]'))
ALTER TABLE [LIB].[DOC_Code_Control_Words] DROP CONSTRAINT [FK_DOC_CCW_REG_Dictionary]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_DOC_CCW_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[DOC_Code_Control_Words]'))
ALTER TABLE [LIB].[DOC_Code_Control_Words] DROP CONSTRAINT [FK_DOC_CCW_REG_Collections]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[DOC_Code_Control_Words]') AND type in (N'U'))
DROP TABLE [LIB].[DOC_Code_Control_Words]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[DOC_Code_Control_Words]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[DOC_Code_Control_Words](
	[tbl_ID] [int] IDENTITY(1,1) NOT NULL,
	[Collection_ID] [int] NOT NULL,
	[Word_ID] [bigint] NULL,
	[Word] [nvarchar](256) NOT NULL,
	[Category] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_DOC_CCW] PRIMARY KEY CLUSTERED 
(
	[Collection_ID] ASC,
	[Word] ASC,
	[Category] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_DOC_CCW_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[DOC_Code_Control_Words]'))
ALTER TABLE [LIB].[DOC_Code_Control_Words]  WITH CHECK ADD  CONSTRAINT [FK_DOC_CCW_REG_Collections] FOREIGN KEY([Collection_ID])
REFERENCES [LIB].[REG_Collections] ([Collection_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_DOC_CCW_REG_Collections]') AND parent_object_id = OBJECT_ID(N'[LIB].[DOC_Code_Control_Words]'))
ALTER TABLE [LIB].[DOC_Code_Control_Words] CHECK CONSTRAINT [FK_DOC_CCW_REG_Collections]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_DOC_CCW_REG_Dictionary]') AND parent_object_id = OBJECT_ID(N'[LIB].[DOC_Code_Control_Words]'))
ALTER TABLE [LIB].[DOC_Code_Control_Words]  WITH CHECK ADD  CONSTRAINT [FK_DOC_CCW_REG_Dictionary] FOREIGN KEY([Word_ID])
REFERENCES [LIB].[REG_Dictionary] ([Word_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_DOC_CCW_REG_Dictionary]') AND parent_object_id = OBJECT_ID(N'[LIB].[DOC_Code_Control_Words]'))
ALTER TABLE [LIB].[DOC_Code_Control_Words] CHECK CONSTRAINT [FK_DOC_CCW_REG_Dictionary]
GO
