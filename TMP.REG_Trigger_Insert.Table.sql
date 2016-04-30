USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__REG_Trigg__Serve__01D345B0]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Trigger_Insert] DROP CONSTRAINT [DF__REG_Trigg__Serve__01D345B0]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__REG_Trigg__REG_0__00DF2177]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Trigger_Insert] DROP CONSTRAINT [DF__REG_Trigg__REG_0__00DF2177]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__REG_Trigg__REG_0__7FEAFD3E]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Trigger_Insert] DROP CONSTRAINT [DF__REG_Trigg__REG_0__7FEAFD3E]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__REG_Trigg__REG_0__7EF6D905]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Trigger_Insert] DROP CONSTRAINT [DF__REG_Trigg__REG_0__7EF6D905]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__REG_Trigg__LNK_T__7E02B4CC]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Trigger_Insert] DROP CONSTRAINT [DF__REG_Trigg__LNK_T__7E02B4CC]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__REG_Trigg__LNK_T__7D0E9093]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Trigger_Insert] DROP CONSTRAINT [DF__REG_Trigg__LNK_T__7D0E9093]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_Trigger_Insert]') AND type in (N'U'))
DROP TABLE [TMP].[REG_Trigger_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_Trigger_Insert]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_Trigger_Insert](
	[LNK_T2_ID] [int] NULL,
	[LNK_T3_ID] [int] NULL,
	[REG_0204_ID] [int] NULL,
	[REG_0300_Prm_ID] [int] NULL,
	[REG_0300_Ref_ID] [int] NULL,
	[Server_ID] [int] NULL,
	[Database_ID] [int] NULL,
	[Schema_ID] [int] NULL,
	[Schema_Name] [nvarchar](256) NULL,
	[Parent_Object_ID] [int] NULL,
	[Parent_Object_Name] [nvarchar](256) NULL,
	[Sub_Object_Rank] [tinyint] NULL,
	[Trigger_Object_ID] [int] NULL,
	[Trigger_Name] [nvarchar](256) NULL,
	[Trigger_Type] [nvarchar](256) NULL,
	[is_ms_shipped] [bit] NULL,
	[is_disabled] [bit] NULL,
	[is_not_for_replication] [bit] NULL,
	[is_instead_of_trigger] [bit] NULL,
	[Create_Date] [datetime] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__REG_Trigg__LNK_T__7D0E9093]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Trigger_Insert] ADD  DEFAULT ((0)) FOR [LNK_T2_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__REG_Trigg__LNK_T__7E02B4CC]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Trigger_Insert] ADD  DEFAULT ((0)) FOR [LNK_T3_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__REG_Trigg__REG_0__7EF6D905]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Trigger_Insert] ADD  DEFAULT ((0)) FOR [REG_0204_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__REG_Trigg__REG_0__7FEAFD3E]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Trigger_Insert] ADD  DEFAULT ((0)) FOR [REG_0300_Prm_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__REG_Trigg__REG_0__00DF2177]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Trigger_Insert] ADD  DEFAULT ((0)) FOR [REG_0300_Ref_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__REG_Trigg__Serve__01D345B0]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Trigger_Insert] ADD  DEFAULT ((0)) FOR [Server_ID]
END

GO
