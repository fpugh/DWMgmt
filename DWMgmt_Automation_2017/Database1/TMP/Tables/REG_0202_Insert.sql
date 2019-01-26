CREATE TABLE [TMP].[REG_0202_Insert] (
    [REG_0202_ID]                       INT NOT NULL,
    [Server_ID]                         INT CONSTRAINT [DF_0202_Server_ID] DEFAULT ((0)) NOT NULL,
    [Database_ID]                       INT NOT NULL,
    [Is_recursive_triggers_on]          BIT NULL,
    [Is_cursor_close_on_commit_on]      BIT NULL,
    [Is_local_cursor_Default]           BIT NULL,
    [Is_fulltext_enabled]               BIT NULL,
    [Is_trustworthy_on]                 BIT NULL,
    [Is_db_chaining_on]                 BIT NULL,
    [Is_parameterization_forced]        BIT NULL,
    [Is_master_Key_encrypted_by_server] BIT NOT NULL,
    [Is_Published]                      BIT NOT NULL,
    [Is_subscribed]                     BIT NOT NULL,
    [Is_merge_Published]                BIT NOT NULL,
    [Is_distributor]                    BIT NOT NULL,
    [Is_sync_with_backup]               BIT NOT NULL,
    [Is_broker_enabled]                 BIT NOT NULL,
    [Is_Date_correlation_on]            BIT NOT NULL
);


GO
CREATE CLUSTERED INDEX [tdx_ci_reg_0202_K2_K3]
    ON [TMP].[REG_0202_Insert]([Server_ID] ASC, [Database_ID] ASC);

