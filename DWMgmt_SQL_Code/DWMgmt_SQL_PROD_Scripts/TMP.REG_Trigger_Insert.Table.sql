USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

GO
ALTER TABLE [TMP].[REG_Trigger_Insert] ADD  DEFAULT ((0)) FOR [LNK_T2_ID]
GO
ALTER TABLE [TMP].[REG_Trigger_Insert] ADD  DEFAULT ((0)) FOR [LNK_T3_ID]
GO
ALTER TABLE [TMP].[REG_Trigger_Insert] ADD  DEFAULT ((0)) FOR [REG_0204_ID]
GO
ALTER TABLE [TMP].[REG_Trigger_Insert] ADD  DEFAULT ((0)) FOR [REG_0300_Prm_ID]
GO
ALTER TABLE [TMP].[REG_Trigger_Insert] ADD  DEFAULT ((0)) FOR [REG_0300_Ref_ID]
GO
ALTER TABLE [TMP].[REG_Trigger_Insert] ADD  DEFAULT ((0)) FOR [Server_ID]
GO
