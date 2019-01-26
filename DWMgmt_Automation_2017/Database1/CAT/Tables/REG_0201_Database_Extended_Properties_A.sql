CREATE TABLE [CAT].[REG_0201_Database_Extended_Properties_A] (
    [REG_0201_ID]                     INT      IDENTITY (1, 1) NOT NULL,
    [page_verify_option]              TINYINT  CONSTRAINT [DF_REG_0201_pageverify] DEFAULT ((0)) NOT NULL,
    [Is_Auto_close_on]                BIT      CONSTRAINT [DF_REG_0201_autoclose] DEFAULT ((0)) NOT NULL,
    [Is_Auto_shrink_on]               BIT      CONSTRAINT [DF_REG_0201_autoshrink] DEFAULT ((0)) NOT NULL,
    [Is_supplemental_logging_enabled] BIT      CONSTRAINT [DF_REG_0201_suplog] DEFAULT ((0)) NOT NULL,
    [Is_read_committed_snapshot_on]   BIT      CONSTRAINT [DF_REG_0201_rcsnap] DEFAULT ((0)) NOT NULL,
    [Is_Auto_Create_stats_on]         BIT      CONSTRAINT [DF_REG_0201_cstats] DEFAULT ((0)) NOT NULL,
    [Is_Auto_update_stats_on]         BIT      CONSTRAINT [DF_REG_0201_atupdtstats] DEFAULT ((0)) NOT NULL,
    [Is_Auto_update_stats_async_on]   BIT      CONSTRAINT [DF_REG_0201_asynstats] DEFAULT ((0)) NOT NULL,
    [Is_ANSI_null_Default_on]         BIT      CONSTRAINT [DF_REG_0201_ansidflt] DEFAULT ((0)) NOT NULL,
    [Is_ANSI_nulls_on]                BIT      CONSTRAINT [DF_REG_0201_ansinull] DEFAULT ((0)) NOT NULL,
    [Is_ANSI_padding_on]              BIT      CONSTRAINT [DF_REG_0201_ansipad] DEFAULT ((0)) NOT NULL,
    [Is_ANSI_warnings_on]             BIT      CONSTRAINT [DF_REG_0201_ansiwarn] DEFAULT ((0)) NOT NULL,
    [Is_arithabort_on]                BIT      CONSTRAINT [DF_REG_0201_arithabt] DEFAULT ((0)) NOT NULL,
    [Is_concat_null_yields_null_on]   BIT      CONSTRAINT [DF_REG_0201_cncnullnull] DEFAULT ((0)) NOT NULL,
    [Is_numeric_roundabort_on]        BIT      CONSTRAINT [DF_REG_0201_numrndabt] DEFAULT ((0)) NOT NULL,
    [Is_quoted_Identifier_on]         BIT      CONSTRAINT [DF_REG_0201_qtdid] DEFAULT ((0)) NOT NULL,
    [REG_Create_Date]                 DATETIME CONSTRAINT [DF_REG_0201_CDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_REG_0201] PRIMARY KEY CLUSTERED ([page_verify_option] ASC, [Is_Auto_close_on] ASC, [Is_Auto_shrink_on] ASC, [Is_supplemental_logging_enabled] ASC, [Is_read_committed_snapshot_on] ASC, [Is_Auto_Create_stats_on] ASC, [Is_Auto_update_stats_on] ASC, [Is_Auto_update_stats_async_on] ASC, [Is_ANSI_null_Default_on] ASC, [Is_ANSI_nulls_on] ASC, [Is_ANSI_padding_on] ASC, [Is_ANSI_warnings_on] ASC, [Is_arithabort_on] ASC, [Is_concat_null_yields_null_on] ASC, [Is_numeric_roundabort_on] ASC, [Is_quoted_Identifier_on] ASC),
    CONSTRAINT [UQ_REG_0201_ID] UNIQUE NONCLUSTERED ([REG_0201_ID] ASC)
);

