USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0302_Foreign_Key_Details]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0302_Foreign_Key_Details]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0302_Foreign_Key_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0302_Foreign_Key_Details](
	[REG_0302_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[is_ms_shipped] [bit] NOT NULL,
	[is_hypothetical] [bit] NOT NULL,
	[is_published] [bit] NOT NULL,
	[is_schema_published] [bit] NOT NULL,
	[is_disabled] [bit] NOT NULL,
	[is_not_trusted] [bit] NOT NULL,
	[is_not_for_replication] [bit] NOT NULL,
	[is_system_named] [bit] NOT NULL,
	[delete_referential_action] [tinyint] NOT NULL,
	[update_referential_action] [tinyint] NOT NULL,
	[key_index_id] [int] NOT NULL,
	[principal_id] [int] NULL,
	[REG_Create_Date] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
