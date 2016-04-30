USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0202_Database_Extended_Properties_B]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0202_Database_Extended_Properties_B]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0202_Database_Extended_Properties_B]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0202_Database_Extended_Properties_B](
	[REG_0202_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[is_recursive_triggers_on] [bit] NOT NULL,
	[is_cursor_close_on_commit_on] [bit] NOT NULL,
	[is_local_cursor_default] [bit] NOT NULL,
	[is_fulltext_enabled] [bit] NOT NULL,
	[is_trustworthy_on] [bit] NOT NULL,
	[is_db_chaining_on] [bit] NOT NULL,
	[is_parameterization_forced] [bit] NOT NULL,
	[is_master_key_encrypted_by_server] [bit] NOT NULL,
	[is_published] [bit] NOT NULL,
	[is_subscribed] [bit] NOT NULL,
	[is_merge_published] [bit] NOT NULL,
	[is_distributor] [bit] NOT NULL,
	[is_sync_with_backup] [bit] NOT NULL,
	[is_broker_enabled] [bit] NOT NULL,
	[is_date_correlation_on] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NULL
) ON [PRIMARY]
END
GO
