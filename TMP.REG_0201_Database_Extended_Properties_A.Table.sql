USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0201_Database_Extended_Properties_A]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0201_Database_Extended_Properties_A]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0201_Database_Extended_Properties_A]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0201_Database_Extended_Properties_A](
	[REG_0201_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[page_verify_option] [tinyint] NOT NULL,
	[is_auto_close_on] [bit] NOT NULL,
	[is_auto_shrink_on] [bit] NOT NULL,
	[is_supplemental_logging_enabled] [bit] NOT NULL,
	[is_read_committed_snapshot_on] [bit] NOT NULL,
	[is_auto_create_stats_on] [bit] NOT NULL,
	[is_auto_update_stats_on] [bit] NOT NULL,
	[is_auto_update_stats_async_on] [bit] NOT NULL,
	[is_ansi_null_default_on] [bit] NOT NULL,
	[is_ansi_nulls_on] [bit] NOT NULL,
	[is_ansi_padding_on] [bit] NOT NULL,
	[is_ansi_warnings_on] [bit] NOT NULL,
	[is_arithabort_on] [bit] NOT NULL,
	[is_concat_null_yields_null_on] [bit] NOT NULL,
	[is_numeric_roundabort_on] [bit] NOT NULL,
	[is_quoted_identifier_on] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NULL
) ON [PRIMARY]
END
GO
