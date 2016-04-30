USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__REG_Const__Serve__5A7A4CC4]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Constraint_Insert] DROP CONSTRAINT [DF__REG_Const__Serve__5A7A4CC4]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_Constraint_Insert]') AND type in (N'U'))
DROP TABLE [TMP].[REG_Constraint_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_Constraint_Insert]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_Constraint_Insert](
	[LNK_T2_ID] [int] NULL,
	[LNK_T3_ID] [int] NULL,
	[LNK_T4_ID] [int] NULL,
	[REG_0204_ID] [int] NULL,
	[REG_0300_Ref_ID] [int] NULL,
	[REG_0300_Prm_ID] [int] NULL,
	[REG_0302_ID] [int] NULL,
	[REG_0400_ID] [int] NULL,
	[Server_ID] [int] NOT NULL,
	[Database_ID] [int] NULL,
	[Schema_ID] [int] NULL,
	[Parent_Object_ID] [int] NULL,
	[Parent_Object_Name] [nvarchar](256) NULL,
	[Parent_object_type] [nvarchar](5) NULL,
	[Parent_Column_Name] [nvarchar](256) NULL,
	[Parent_Column_Type] [int] NULL,
	[Parent_Column_ID] [int] NULL,
	[Constraint_Object_ID] [int] NULL,
	[Constraint_name] [nvarchar](256) NULL,
	[Constraint_type] [nvarchar](2) NULL,
	[Constraint_Definition] [nvarchar](4000) NULL,
	[is_ms_shipped] [bit] NULL,
	[is_published] [bit] NULL,
	[is_schema_published] [bit] NULL,
	[is_system_named] [bit] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__REG_Const__Serve__5A7A4CC4]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Constraint_Insert] ADD  DEFAULT ((0)) FOR [Server_ID]
END

GO
