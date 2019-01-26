CREATE TABLE [CAT].[REG_0202_Database_Extended_Properties_B] (
    [REG_0202_ID]                       INT      IDENTITY (1, 1) NOT NULL,
    [Is_recursive_triggers_on]          BIT      CONSTRAINT [DF_REG_0202_rectrig] DEFAULT ((0)) NOT NULL,
    [Is_cursor_close_on_commit_on]      BIT      CONSTRAINT [DF_REG_0202_crsrclscmmt] DEFAULT ((0)) NOT NULL,
    [Is_local_cursor_Default]           BIT      CONSTRAINT [DF_REG_0202_lclcrsrdflt] DEFAULT ((0)) NOT NULL,
    [Is_fulltext_enabled]               BIT      CONSTRAINT [DF_REG_0202_fulltext] DEFAULT ((0)) NOT NULL,
    [Is_trustworthy_on]                 BIT      CONSTRAINT [DF_REG_0202_trustworty] DEFAULT ((0)) NOT NULL,
    [Is_db_chaining_on]                 BIT      CONSTRAINT [DF_REG_0202_dbchaining] DEFAULT ((0)) NOT NULL,
    [Is_parameterization_forced]        BIT      CONSTRAINT [DF_REG_0202_paraforced] DEFAULT ((0)) NOT NULL,
    [Is_master_Key_encrypted_by_server] BIT      CONSTRAINT [DF_REG_0202_Keyencrypted] DEFAULT ((0)) NOT NULL,
    [Is_Published]                      BIT      CONSTRAINT [DF_REG_0202_ispublished] DEFAULT ((0)) NOT NULL,
    [Is_subscribed]                     BIT      CONSTRAINT [DF_REG_0202_subscribed] DEFAULT ((0)) NOT NULL,
    [Is_merge_Published]                BIT      CONSTRAINT [DF_REG_0202_mergepub] DEFAULT ((0)) NOT NULL,
    [Is_distributor]                    BIT      CONSTRAINT [DF_REG_0202_distributor] DEFAULT ((0)) NOT NULL,
    [Is_sync_with_backup]               BIT      CONSTRAINT [DF_REG_0202_backupsync] DEFAULT ((0)) NOT NULL,
    [Is_broker_enabled]                 BIT      CONSTRAINT [DF_REG_0202_broker] DEFAULT ((0)) NOT NULL,
    [Is_Date_correlation_on]            BIT      CONSTRAINT [DF_REG_0202_Datecorrelate] DEFAULT ((0)) NOT NULL,
    [REG_Create_Date]                   DATETIME CONSTRAINT [DF_REG_0202_CDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_REG_0202] PRIMARY KEY CLUSTERED ([Is_recursive_triggers_on] ASC, [Is_cursor_close_on_commit_on] ASC, [Is_local_cursor_Default] ASC, [Is_fulltext_enabled] ASC, [Is_trustworthy_on] ASC, [Is_db_chaining_on] ASC, [Is_parameterization_forced] ASC, [Is_master_Key_encrypted_by_server] ASC, [Is_Published] ASC, [Is_subscribed] ASC, [Is_merge_Published] ASC, [Is_distributor] ASC, [Is_sync_with_backup] ASC, [Is_broker_enabled] ASC, [Is_Date_correlation_on] ASC),
    CONSTRAINT [UQ_REG_0202_ID] UNIQUE NONCLUSTERED ([REG_0202_ID] ASC)
);

