USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CAT].[REG_0201_Database_Extended_Properties_A](
	[REG_0201_ID] [int] IDENTITY(1,1) NOT NULL,
	[page_verify_option] [tinyint] NOT NULL,
	[Is_Auto_close_on] [bit] NOT NULL,
	[Is_Auto_shrink_on] [bit] NOT NULL,
	[Is_supplemental_logging_enabled] [bit] NOT NULL,
	[Is_read_committed_snapshot_on] [bit] NOT NULL,
	[Is_Auto_Create_stats_on] [bit] NOT NULL,
	[Is_Auto_update_stats_on] [bit] NOT NULL,
	[Is_Auto_update_stats_async_on] [bit] NOT NULL,
	[Is_ANSI_null_Default_on] [bit] NOT NULL,
	[Is_ANSI_nulls_on] [bit] NOT NULL,
	[Is_ANSI_padding_on] [bit] NOT NULL,
	[Is_ANSI_warnings_on] [bit] NOT NULL,
	[Is_arithabort_on] [bit] NOT NULL,
	[Is_concat_null_yields_null_on] [bit] NOT NULL,
	[Is_numeric_roundabort_on] [bit] NOT NULL,
	[Is_quoted_Identifier_on] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NULL,
 CONSTRAINT [PK_REG_0201] PRIMARY KEY CLUSTERED 
(
	[page_verify_option] ASC,
	[Is_Auto_close_on] ASC,
	[Is_Auto_shrink_on] ASC,
	[Is_supplemental_logging_enabled] ASC,
	[Is_read_committed_snapshot_on] ASC,
	[Is_Auto_Create_stats_on] ASC,
	[Is_Auto_update_stats_on] ASC,
	[Is_Auto_update_stats_async_on] ASC,
	[Is_ANSI_null_Default_on] ASC,
	[Is_ANSI_nulls_on] ASC,
	[Is_ANSI_padding_on] ASC,
	[Is_ANSI_warnings_on] ASC,
	[Is_arithabort_on] ASC,
	[Is_concat_null_yields_null_on] ASC,
	[Is_numeric_roundabort_on] ASC,
	[Is_quoted_Identifier_on] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0201_ID] UNIQUE NONCLUSTERED 
(
	[REG_0201_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_pageverify]  DEFAULT ((0)) FOR [page_verify_option]
GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_autoclose]  DEFAULT ((0)) FOR [Is_Auto_close_on]
GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_autoshrink]  DEFAULT ((0)) FOR [Is_Auto_shrink_on]
GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_suplog]  DEFAULT ((0)) FOR [Is_supplemental_logging_enabled]
GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_rcsnap]  DEFAULT ((0)) FOR [Is_read_committed_snapshot_on]
GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_cstats]  DEFAULT ((0)) FOR [Is_Auto_Create_stats_on]
GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_atupdtstats]  DEFAULT ((0)) FOR [Is_Auto_update_stats_on]
GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_asynstats]  DEFAULT ((0)) FOR [Is_Auto_update_stats_async_on]
GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_ansidflt]  DEFAULT ((0)) FOR [Is_ANSI_null_Default_on]
GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_ansinull]  DEFAULT ((0)) FOR [Is_ANSI_nulls_on]
GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_ansipad]  DEFAULT ((0)) FOR [Is_ANSI_padding_on]
GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_ansiwarn]  DEFAULT ((0)) FOR [Is_ANSI_warnings_on]
GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_arithabt]  DEFAULT ((0)) FOR [Is_arithabort_on]
GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_cncnullnull]  DEFAULT ((0)) FOR [Is_concat_null_yields_null_on]
GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_numrndabt]  DEFAULT ((0)) FOR [Is_numeric_roundabort_on]
GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_qtdid]  DEFAULT ((0)) FOR [Is_quoted_Identifier_on]
GO
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
GO
