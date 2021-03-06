USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TMP].[REG_0202_Insert](
	[REG_0202_ID] [int] NOT NULL,
	[Server_ID] [int] NOT NULL,
	[Database_ID] [int] NOT NULL,
	[Is_recursive_triggers_on] [bit] NULL,
	[Is_cursor_close_on_commit_on] [bit] NULL,
	[Is_local_cursor_Default] [bit] NULL,
	[Is_fulltext_enabled] [bit] NULL,
	[Is_trustworthy_on] [bit] NULL,
	[Is_db_chaining_on] [bit] NULL,
	[Is_parameterization_forced] [bit] NULL,
	[Is_master_Key_encrypted_by_server] [bit] NOT NULL,
	[Is_Published] [bit] NOT NULL,
	[Is_subscribed] [bit] NOT NULL,
	[Is_merge_Published] [bit] NOT NULL,
	[Is_distributor] [bit] NOT NULL,
	[Is_sync_with_backup] [bit] NOT NULL,
	[Is_broker_enabled] [bit] NOT NULL,
	[Is_Date_correlation_on] [bit] NOT NULL
) ON [PRIMARY]

GO
CREATE CLUSTERED INDEX [tdx_ci_reg_0202_K2_K3] ON [TMP].[REG_0202_Insert]
(
	[Server_ID] ASC,
	[Database_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [TMP].[REG_0202_Insert] ADD  CONSTRAINT [DF_0202_Server_ID]  DEFAULT ((0)) FOR [Server_ID]
GO
