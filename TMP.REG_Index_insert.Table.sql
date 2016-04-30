USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__REG_Index__Serve__4C2C2D6D]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Index_insert] DROP CONSTRAINT [DF__REG_Index__Serve__4C2C2D6D]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_Index_insert]') AND type in (N'U'))
DROP TABLE [TMP].[REG_Index_insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_Index_insert]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_Index_insert](
	[LNK_T2_ID] [int] NULL,
	[LNK_T3_ID] [int] NULL,
	[LNK_T4_ID] [int] NULL,
	[REG_0204_ID] [int] NULL,
	[REG_0300_Ref_ID] [int] NULL,
	[REG_0300_Prm_ID] [int] NULL,
	[REG_0301_ID] [int] NULL,
	[REG_0400_ID] [int] NULL,
	[REG_0402_ID] [int] NULL,
	[Server_ID] [int] NOT NULL,
	[Database_ID] [int] NULL,
	[Schema_ID] [int] NULL,
	[Parent_Object_ID] [int] NULL,
	[Parent_Object_Name] [nvarchar](256) NULL,
	[parent_object_type] [nvarchar](5) NULL,
	[Index_Name] [nvarchar](256) NULL,
	[Index_Type] [nvarchar](2) NULL,
	[Index_Rank] [int] NULL,
	[is_unique] [bit] NULL,
	[data_space_ID] [int] NULL,
	[ignore_dup_key] [bit] NULL,
	[is_primary_key] [bit] NULL,
	[is_unique_constraint] [bit] NULL,
	[fill_factor] [int] NULL,
	[is_padded] [bit] NULL,
	[is_disabled] [bit] NULL,
	[is_hypothetical] [bit] NULL,
	[Allow_Row_Locks] [bit] NULL,
	[Allow_Page_Locks] [bit] NULL,
	[Parent_Column_Name] [nvarchar](256) NULL,
	[Parent_Column_Type] [int] NULL,
	[Index_Column_ID] [int] NULL,
	[Column_ID] [int] NULL,
	[is_descending_key] [bit] NULL,
	[is_included_column] [bit] NULL,
	[key_ordinal] [smallint] NULL,
	[partition_ordinal] [smallint] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__REG_Index__Serve__4C2C2D6D]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_Index_insert] ADD  DEFAULT ((0)) FOR [Server_ID]
END

GO
