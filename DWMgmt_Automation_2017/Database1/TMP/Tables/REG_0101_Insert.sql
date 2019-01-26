CREATE TABLE [TMP].[REG_0101_Insert] (
    [REG_0101_ID]                                  INT       NOT NULL,
    [Server_ID]                                    INT       NOT NULL,
    [Is_linked]                                    BIT       NOT NULL,
    [Is_remote_login_enabled]                      BIT       NOT NULL,
    [Is_rpc_out_enabled]                           BIT       NOT NULL,
    [Is_data_access_enabled]                       BIT       NOT NULL,
    [Is_Collation_compatible]                      BIT       NOT NULL,
    [uses_remote_Collation]                        BIT       NOT NULL,
    [collation_Name]                               [sysname] NULL,
    [connect_timeout]                              INT       NULL,
    [query_timeout]                                INT       NULL,
    [Is_system]                                    BIT       NOT NULL,
    [Is_remote_proc_transaction_promotion_enabled] BIT       NULL
);

