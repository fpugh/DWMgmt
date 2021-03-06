USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CAT].[REG_0202_Database_Extended_Properties_B](
	[REG_0202_ID] [int] IDENTITY(1,1) NOT NULL,
	[Is_recursive_triggers_on] [bit] NOT NULL,
	[Is_cursor_close_on_commit_on] [bit] NOT NULL,
	[Is_local_cursor_Default] [bit] NOT NULL,
	[Is_fulltext_enabled] [bit] NOT NULL,
	[Is_trustworthy_on] [bit] NOT NULL,
	[Is_db_chaining_on] [bit] NOT NULL,
	[Is_parameterization_forced] [bit] NOT NULL,
	[Is_master_Key_encrypted_by_server] [bit] NOT NULL,
	[Is_Published] [bit] NOT NULL,
	[Is_subscribed] [bit] NOT NULL,
	[Is_merge_Published] [bit] NOT NULL,
	[Is_distributor] [bit] NOT NULL,
	[Is_sync_with_backup] [bit] NOT NULL,
	[Is_broker_enabled] [bit] NOT NULL,
	[Is_Date_correlation_on] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NULL,
 CONSTRAINT [PK_REG_0202] PRIMARY KEY CLUSTERED 
(
	[Is_recursive_triggers_on] ASC,
	[Is_cursor_close_on_commit_on] ASC,
	[Is_local_cursor_Default] ASC,
	[Is_fulltext_enabled] ASC,
	[Is_trustworthy_on] ASC,
	[Is_db_chaining_on] ASC,
	[Is_parameterization_forced] ASC,
	[Is_master_Key_encrypted_by_server] ASC,
	[Is_Published] ASC,
	[Is_subscribed] ASC,
	[Is_merge_Published] ASC,
	[Is_distributor] ASC,
	[Is_sync_with_backup] ASC,
	[Is_broker_enabled] ASC,
	[Is_Date_correlation_on] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0202_ID] UNIQUE NONCLUSTERED 
(
	[REG_0202_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [CAT].[REG_0202_Database_Extended_Properties_B] ADD  CONSTRAINT [DF_REG_0202_rectrig]  DEFAULT ((0)) FOR [Is_recursive_triggers_on]
GO
ALTER TABLE [CAT].[REG_0202_Database_Extended_Properties_B] ADD  CONSTRAINT [DF_REG_0202_crsrclscmmt]  DEFAULT ((0)) FOR [Is_cursor_close_on_commit_on]
GO
ALTER TABLE [CAT].[REG_0202_Database_Extended_Properties_B] ADD  CONSTRAINT [DF_REG_0202_lclcrsrdflt]  DEFAULT ((0)) FOR [Is_local_cursor_Default]
GO
ALTER TABLE [CAT].[REG_0202_Database_Extended_Properties_B] ADD  CONSTRAINT [DF_REG_0202_fulltext]  DEFAULT ((0)) FOR [Is_fulltext_enabled]
GO
ALTER TABLE [CAT].[REG_0202_Database_Extended_Properties_B] ADD  CONSTRAINT [DF_REG_0202_trustworty]  DEFAULT ((0)) FOR [Is_trustworthy_on]
GO
ALTER TABLE [CAT].[REG_0202_Database_Extended_Properties_B] ADD  CONSTRAINT [DF_REG_0202_dbchaining]  DEFAULT ((0)) FOR [Is_db_chaining_on]
GO
ALTER TABLE [CAT].[REG_0202_Database_Extended_Properties_B] ADD  CONSTRAINT [DF_REG_0202_paraforced]  DEFAULT ((0)) FOR [Is_parameterization_forced]
GO
ALTER TABLE [CAT].[REG_0202_Database_Extended_Properties_B] ADD  CONSTRAINT [DF_REG_0202_Keyencrypted]  DEFAULT ((0)) FOR [Is_master_Key_encrypted_by_server]
GO
ALTER TABLE [CAT].[REG_0202_Database_Extended_Properties_B] ADD  CONSTRAINT [DF_REG_0202_ispublished]  DEFAULT ((0)) FOR [Is_Published]
GO
ALTER TABLE [CAT].[REG_0202_Database_Extended_Properties_B] ADD  CONSTRAINT [DF_REG_0202_subscribed]  DEFAULT ((0)) FOR [Is_subscribed]
GO
ALTER TABLE [CAT].[REG_0202_Database_Extended_Properties_B] ADD  CONSTRAINT [DF_REG_0202_mergepub]  DEFAULT ((0)) FOR [Is_merge_Published]
GO
ALTER TABLE [CAT].[REG_0202_Database_Extended_Properties_B] ADD  CONSTRAINT [DF_REG_0202_distributor]  DEFAULT ((0)) FOR [Is_distributor]
GO
ALTER TABLE [CAT].[REG_0202_Database_Extended_Properties_B] ADD  CONSTRAINT [DF_REG_0202_backupsync]  DEFAULT ((0)) FOR [Is_sync_with_backup]
GO
ALTER TABLE [CAT].[REG_0202_Database_Extended_Properties_B] ADD  CONSTRAINT [DF_REG_0202_broker]  DEFAULT ((0)) FOR [Is_broker_enabled]
GO
ALTER TABLE [CAT].[REG_0202_Database_Extended_Properties_B] ADD  CONSTRAINT [DF_REG_0202_Datecorrelate]  DEFAULT ((0)) FOR [Is_Date_correlation_on]
GO
ALTER TABLE [CAT].[REG_0202_Database_Extended_Properties_B] ADD  CONSTRAINT [DF_REG_0202_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
GO
