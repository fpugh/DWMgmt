CREATE TABLE [TMP].[REG_0201_Insert] (
    [REG_0201_ID]                     INT     NOT NULL,
    [Server_ID]                       INT     NOT NULL,
    [Database_ID]                     INT     NOT NULL,
    [page_verify_option]              TINYINT NULL,
    [Is_auto_close_on]                BIT     NOT NULL,
    [Is_auto_shrink_on]               BIT     NULL,
    [Is_supplemental_logging_enabled] BIT     NULL,
    [Is_read_committed_snapshot_on]   BIT     NULL,
    [Is_auto_Create_stats_on]         BIT     NULL,
    [Is_auto_update_stats_on]         BIT     NULL,
    [Is_auto_update_stats_async_on]   BIT     NULL,
    [Is_ansi_null_Default_on]         BIT     NULL,
    [Is_ansi_nulls_on]                BIT     NULL,
    [Is_ansi_padding_on]              BIT     NULL,
    [Is_ansi_warnings_on]             BIT     NULL,
    [Is_arithabort_on]                BIT     NULL,
    [Is_concat_null_yields_null_on]   BIT     NULL,
    [Is_numeric_roundabort_on]        BIT     NULL,
    [Is_quoted_IDentifier_on]         BIT     NULL
);


GO
CREATE CLUSTERED INDEX [tdx_ci_reg_0201_K2_K3]
    ON [TMP].[REG_0201_Insert]([Server_ID] ASC, [Database_ID] ASC);

