USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_FK_Insert_ServerID]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Foreign_Key_insert] DROP CONSTRAINT [DF_FK_Insert_ServerID]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_Foreign_Key_insert]') AND type in (N'U'))
DROP TABLE [TMP].[REG_Foreign_Key_insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_Foreign_Key_insert]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_Foreign_Key_insert](
	[LNK_T2_ID] [int] NOT NULL,
	[LNK_T3_ID] [int] NOT NULL,
	[LNK_T4_ID] [int] NOT NULL,
	[REG_0204_ID] [int] NOT NULL,
	[REG_0300_Prm_ID] [int] NOT NULL,
	[REG_0300_Ref_ID] [int] NOT NULL,
	[REG_0302_ID] [int] NOT NULL,
	[REG_0400_ID] [int] NOT NULL,
	[REG_0403_ID] [int] NOT NULL,
	[Server_ID] [int] NULL,
	[Database_ID] [smallint] NULL,
	[Schema_ID] [int] NOT NULL,
	[Key_Object_ID] [int] NOT NULL,
	[Sub_Object_Rank] [bigint] NULL,
	[Key_Name] [nvarchar](256) NOT NULL,
	[Key_Type] [nvarchar](30) NULL,
	[Key_Column_ID] [int] NOT NULL,
	[Referenced_Object_Name] [nvarchar](225) NOT NULL,
	[Referenced_Object_ID] [int] NOT NULL,
	[Referenced_Column_Name] [nvarchar](225) NOT NULL,
	[Referenced_column_type] [int] NOT NULL,
	[Referenced_Column_ID] [int] NOT NULL,
	[Create_Date] [datetime] NOT NULL,
	[is_ms_shipped] [bit] NOT NULL,
	[is_published] [bit] NOT NULL,
	[is_schema_published] [bit] NOT NULL,
	[Key_Index_ID] [int] NULL,
	[is_disabled] [bit] NOT NULL,
	[is_not_for_replication] [bit] NOT NULL,
	[is_not_trusted] [bit] NOT NULL,
	[delete_referential_action] [tinyint] NULL,
	[delete_referential_action_desc] [nvarchar](60) NULL,
	[update_referential_action] [tinyint] NULL,
	[update_referential_action_desc] [nvarchar](60) NULL,
	[is_system_named] [bit] NOT NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_FK_Insert_ServerID]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Foreign_Key_insert] ADD  CONSTRAINT [DF_FK_Insert_ServerID]  DEFAULT ((0)) FOR [Server_ID]
END

GO
