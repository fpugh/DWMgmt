USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TMP].[REG_Index_Insert](
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

GO
ALTER TABLE [TMP].[REG_Index_Insert] ADD  DEFAULT ((0)) FOR [Server_ID]
GO
