USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TMP].[REG_0201_Insert](
	[REG_0201_ID] [int] NOT NULL,
	[Server_ID] [int] NOT NULL,
	[Database_ID] [int] NOT NULL,
	[page_verify_option] [tinyint] NULL,
	[Is_auto_close_on] [bit] NOT NULL,
	[Is_auto_shrink_on] [bit] NULL,
	[Is_supplemental_logging_enabled] [bit] NULL,
	[Is_read_committed_snapshot_on] [bit] NULL,
	[Is_auto_Create_stats_on] [bit] NULL,
	[Is_auto_update_stats_on] [bit] NULL,
	[Is_auto_update_stats_async_on] [bit] NULL,
	[Is_ansi_null_Default_on] [bit] NULL,
	[Is_ansi_nulls_on] [bit] NULL,
	[Is_ansi_padding_on] [bit] NULL,
	[Is_ansi_warnings_on] [bit] NULL,
	[Is_arithabort_on] [bit] NULL,
	[Is_concat_null_yields_null_on] [bit] NULL,
	[Is_numeric_roundabort_on] [bit] NULL,
	[Is_quoted_IDentifier_on] [bit] NULL
) ON [PRIMARY]

GO
CREATE CLUSTERED INDEX [tdx_ci_reg_0201_K2_K3] ON [TMP].[REG_0201_Insert]
(
	[Server_ID] ASC,
	[Database_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
