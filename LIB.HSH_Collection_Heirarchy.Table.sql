USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[LIB].[CK_HCH_Flag_Values]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Heirarchy]'))
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] DROP CONSTRAINT [CK_HCH_Flag_Values]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_RK_CollectionsID]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Heirarchy]'))
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] DROP CONSTRAINT [FK_HSH_RK_CollectionsID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_FK_CollectionsID]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Heirarchy]'))
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] DROP CONSTRAINT [FK_HSH_FK_CollectionsID]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HCH_Count_Base]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] DROP CONSTRAINT [DF_HCH_Count_Base]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HCH_Term_Default]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] DROP CONSTRAINT [DF_HCH_Term_Default]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HCH_Post_Default]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] DROP CONSTRAINT [DF_HCH_Post_Default]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HCH_FkID_Default]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] DROP CONSTRAINT [DF_HCH_FkID_Default]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HCH_RkID_Default]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] DROP CONSTRAINT [DF_HCH_RkID_Default]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HCH_Flag_Default]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] DROP CONSTRAINT [DF_HCH_Flag_Default]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Heirarchy]') AND type in (N'U'))
DROP TABLE [LIB].[HSH_Collection_Heirarchy]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Heirarchy]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[HSH_Collection_Heirarchy](
	[Hash_ID] [int] IDENTITY(1,1) NOT NULL,
	[DURLFlag] [tinyint] NOT NULL,
	[RK_Collection_ID] [int] NOT NULL,
	[FK_Collection_ID] [int] NOT NULL,
	[Post_Date] [datetime] NOT NULL,
	[Term_Date] [datetime] NOT NULL,
	[Use_Count] [int] NOT NULL,
 CONSTRAINT [PK_LNK_Collections] PRIMARY KEY NONCLUSTERED 
(
	[DURLFlag] ASC,
	[RK_Collection_ID] ASC,
	[FK_Collection_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_HSH_Collection_ID] UNIQUE NONCLUSTERED 
(
	[Hash_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HCH_Flag_Default]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] ADD  CONSTRAINT [DF_HCH_Flag_Default]  DEFAULT ((0)) FOR [DURLFlag]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HCH_RkID_Default]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] ADD  CONSTRAINT [DF_HCH_RkID_Default]  DEFAULT ((0)) FOR [RK_Collection_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HCH_FkID_Default]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] ADD  CONSTRAINT [DF_HCH_FkID_Default]  DEFAULT ((0)) FOR [FK_Collection_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HCH_Post_Default]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] ADD  CONSTRAINT [DF_HCH_Post_Default]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HCH_Term_Default]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] ADD  CONSTRAINT [DF_HCH_Term_Default]  DEFAULT ('12/31/2099') FOR [Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_HCH_Count_Base]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] ADD  CONSTRAINT [DF_HCH_Count_Base]  DEFAULT ((0)) FOR [Use_Count]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_FK_CollectionsID]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Heirarchy]'))
ALTER TABLE [LIB].[HSH_Collection_Heirarchy]  WITH CHECK ADD  CONSTRAINT [FK_HSH_FK_CollectionsID] FOREIGN KEY([FK_Collection_ID])
REFERENCES [LIB].[REG_Collections] ([Collection_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_FK_CollectionsID]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Heirarchy]'))
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] CHECK CONSTRAINT [FK_HSH_FK_CollectionsID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_RK_CollectionsID]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Heirarchy]'))
ALTER TABLE [LIB].[HSH_Collection_Heirarchy]  WITH CHECK ADD  CONSTRAINT [FK_HSH_RK_CollectionsID] FOREIGN KEY([RK_Collection_ID])
REFERENCES [LIB].[REG_Collections] ([Collection_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[LIB].[FK_HSH_RK_CollectionsID]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Heirarchy]'))
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] CHECK CONSTRAINT [FK_HSH_RK_CollectionsID]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[LIB].[CK_HCH_Flag_Values]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Heirarchy]'))
ALTER TABLE [LIB].[HSH_Collection_Heirarchy]  WITH CHECK ADD  CONSTRAINT [CK_HCH_Flag_Values] CHECK  (([DURLFlag]=(5) OR [DURLFlag]=(4) OR [DURLFlag]=(3) OR [DURLFlag]=(2) OR [DURLFlag]=(1) OR [DURLFlag]=(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[LIB].[CK_HCH_Flag_Values]') AND parent_object_id = OBJECT_ID(N'[LIB].[HSH_Collection_Heirarchy]'))
ALTER TABLE [LIB].[HSH_Collection_Heirarchy] CHECK CONSTRAINT [CK_HCH_Flag_Values]
GO
