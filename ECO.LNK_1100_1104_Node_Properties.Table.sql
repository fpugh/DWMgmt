USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[ECO].[FK_NP_LNK_1104]') AND parent_object_id = OBJECT_ID(N'[ECO].[LNK_1100_1104_Node_Properties]'))
ALTER TABLE [ECO].[LNK_1100_1104_Node_Properties] DROP CONSTRAINT [FK_NP_LNK_1104]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[ECO].[FK_NP_LNK_1103]') AND parent_object_id = OBJECT_ID(N'[ECO].[LNK_1100_1104_Node_Properties]'))
ALTER TABLE [ECO].[LNK_1100_1104_Node_Properties] DROP CONSTRAINT [FK_NP_LNK_1103]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[ECO].[FK_NP_LNK_1102]') AND parent_object_id = OBJECT_ID(N'[ECO].[LNK_1100_1104_Node_Properties]'))
ALTER TABLE [ECO].[LNK_1100_1104_Node_Properties] DROP CONSTRAINT [FK_NP_LNK_1102]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[ECO].[FK_NP_LNK_1100]') AND parent_object_id = OBJECT_ID(N'[ECO].[LNK_1100_1104_Node_Properties]'))
ALTER TABLE [ECO].[LNK_1100_1104_Node_Properties] DROP CONSTRAINT [FK_NP_LNK_1100]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[ECO].[DF_L1100_1104_Term]') AND type = 'D')
BEGIN
ALTER TABLE [ECO].[LNK_1100_1104_Node_Properties] DROP CONSTRAINT [DF_L1100_1104_Term]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[ECO].[DF_L1100_1104_Post]') AND type = 'D')
BEGIN
ALTER TABLE [ECO].[LNK_1100_1104_Node_Properties] DROP CONSTRAINT [DF_L1100_1104_Post]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ECO].[LNK_1100_1104_Node_Properties]') AND type in (N'U'))
DROP TABLE [ECO].[LNK_1100_1104_Node_Properties]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ECO].[LNK_1100_1104_Node_Properties]') AND type in (N'U'))
BEGIN
CREATE TABLE [ECO].[LNK_1100_1104_Node_Properties](
	[LNK_1100_1104_ID] [int] IDENTITY(1,1) NOT NULL,
	[LNK_FK_1100_ID] [int] NOT NULL,
	[LNK_FK_1102_ID] [int] NOT NULL,
	[LNK_FK_1103_ID] [int] NOT NULL,
	[LNK_FK_1104_ID] [int] NOT NULL,
	[LNK_Rank] [int] NOT NULL,
	[LNK_Post_Date] [datetime] NULL,
	[LNK_Term_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_LNK_1100_1104] PRIMARY KEY CLUSTERED 
(
	[LNK_FK_1100_ID] ASC,
	[LNK_FK_1102_ID] ASC,
	[LNK_FK_1103_ID] ASC,
	[LNK_FK_1104_ID] ASC,
	[LNK_Rank] ASC,
	[LNK_Term_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_L1100_1104_ID] UNIQUE NONCLUSTERED 
(
	[LNK_1100_1104_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[ECO].[DF_L1100_1104_Post]') AND type = 'D')
BEGIN
ALTER TABLE [ECO].[LNK_1100_1104_Node_Properties] ADD  CONSTRAINT [DF_L1100_1104_Post]  DEFAULT (getdate()) FOR [LNK_Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[ECO].[DF_L1100_1104_Term]') AND type = 'D')
BEGIN
ALTER TABLE [ECO].[LNK_1100_1104_Node_Properties] ADD  CONSTRAINT [DF_L1100_1104_Term]  DEFAULT ('12/31/2099') FOR [LNK_Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[ECO].[FK_NP_LNK_1100]') AND parent_object_id = OBJECT_ID(N'[ECO].[LNK_1100_1104_Node_Properties]'))
ALTER TABLE [ECO].[LNK_1100_1104_Node_Properties]  WITH CHECK ADD  CONSTRAINT [FK_NP_LNK_1100] FOREIGN KEY([LNK_FK_1100_ID])
REFERENCES [ECO].[REG_1100_XML_Schema_Registry] ([REG_1100_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[ECO].[FK_NP_LNK_1100]') AND parent_object_id = OBJECT_ID(N'[ECO].[LNK_1100_1104_Node_Properties]'))
ALTER TABLE [ECO].[LNK_1100_1104_Node_Properties] CHECK CONSTRAINT [FK_NP_LNK_1100]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[ECO].[FK_NP_LNK_1102]') AND parent_object_id = OBJECT_ID(N'[ECO].[LNK_1100_1104_Node_Properties]'))
ALTER TABLE [ECO].[LNK_1100_1104_Node_Properties]  WITH CHECK ADD  CONSTRAINT [FK_NP_LNK_1102] FOREIGN KEY([LNK_FK_1102_ID])
REFERENCES [ECO].[REG_1102_XML_Nodes] ([REG_1102_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[ECO].[FK_NP_LNK_1102]') AND parent_object_id = OBJECT_ID(N'[ECO].[LNK_1100_1104_Node_Properties]'))
ALTER TABLE [ECO].[LNK_1100_1104_Node_Properties] CHECK CONSTRAINT [FK_NP_LNK_1102]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[ECO].[FK_NP_LNK_1103]') AND parent_object_id = OBJECT_ID(N'[ECO].[LNK_1100_1104_Node_Properties]'))
ALTER TABLE [ECO].[LNK_1100_1104_Node_Properties]  WITH CHECK ADD  CONSTRAINT [FK_NP_LNK_1103] FOREIGN KEY([LNK_FK_1103_ID])
REFERENCES [ECO].[REG_1103_XML_Node_Properties] ([REG_1103_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[ECO].[FK_NP_LNK_1103]') AND parent_object_id = OBJECT_ID(N'[ECO].[LNK_1100_1104_Node_Properties]'))
ALTER TABLE [ECO].[LNK_1100_1104_Node_Properties] CHECK CONSTRAINT [FK_NP_LNK_1103]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[ECO].[FK_NP_LNK_1104]') AND parent_object_id = OBJECT_ID(N'[ECO].[LNK_1100_1104_Node_Properties]'))
ALTER TABLE [ECO].[LNK_1100_1104_Node_Properties]  WITH CHECK ADD  CONSTRAINT [FK_NP_LNK_1104] FOREIGN KEY([LNK_FK_1104_ID])
REFERENCES [ECO].[REG_1104_XML_Property_Values] ([REG_1104_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[ECO].[FK_NP_LNK_1104]') AND parent_object_id = OBJECT_ID(N'[ECO].[LNK_1100_1104_Node_Properties]'))
ALTER TABLE [ECO].[LNK_1100_1104_Node_Properties] CHECK CONSTRAINT [FK_NP_LNK_1104]
GO