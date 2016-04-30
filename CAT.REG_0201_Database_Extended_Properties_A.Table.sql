USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_CDate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_qtdid]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_qtdid]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_numrndabt]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_numrndabt]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_cncnullnull]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_cncnullnull]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_arithabt]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_arithabt]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_ansiwarn]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_ansiwarn]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_ansipad]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_ansipad]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_ansinull]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_ansinull]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_ansidflt]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_ansidflt]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_asynstats]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_asynstats]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_atupdtstats]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_atupdtstats]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_cstats]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_cstats]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_rcsnap]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_rcsnap]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_suplog]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_suplog]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_autoshrink]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_autoshrink]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_autoclose]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_autoclose]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_pageverify]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] DROP CONSTRAINT [DF_REG_0201_pageverify]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0201_Database_Extended_Properties_A]') AND type in (N'U'))
DROP TABLE [CAT].[REG_0201_Database_Extended_Properties_A]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0201_Database_Extended_Properties_A]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[REG_0201_Database_Extended_Properties_A](
	[REG_0201_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_pageverify]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_pageverify]  DEFAULT ((0)) FOR [page_verify_option]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_autoclose]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_autoclose]  DEFAULT ((0)) FOR [Is_Auto_close_on]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_autoshrink]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_autoshrink]  DEFAULT ((0)) FOR [Is_Auto_shrink_on]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_suplog]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_suplog]  DEFAULT ((0)) FOR [Is_supplemental_logging_enabled]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_rcsnap]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_rcsnap]  DEFAULT ((0)) FOR [Is_read_committed_snapshot_on]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_cstats]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_cstats]  DEFAULT ((0)) FOR [Is_Auto_Create_stats_on]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_atupdtstats]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_atupdtstats]  DEFAULT ((0)) FOR [Is_Auto_update_stats_on]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_asynstats]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_asynstats]  DEFAULT ((0)) FOR [Is_Auto_update_stats_async_on]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_ansidflt]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_ansidflt]  DEFAULT ((0)) FOR [Is_ANSI_null_Default_on]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_ansinull]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_ansinull]  DEFAULT ((0)) FOR [Is_ANSI_nulls_on]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_ansipad]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_ansipad]  DEFAULT ((0)) FOR [Is_ANSI_padding_on]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_ansiwarn]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_ansiwarn]  DEFAULT ((0)) FOR [Is_ANSI_warnings_on]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_arithabt]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_arithabt]  DEFAULT ((0)) FOR [Is_arithabort_on]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_cncnullnull]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_cncnullnull]  DEFAULT ((0)) FOR [Is_concat_null_yields_null_on]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_numrndabt]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_numrndabt]  DEFAULT ((0)) FOR [Is_numeric_roundabort_on]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_qtdid]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_qtdid]  DEFAULT ((0)) FOR [Is_quoted_Identifier_on]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0201_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0201_Database_Extended_Properties_A] ADD  CONSTRAINT [DF_REG_0201_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
END

GO
