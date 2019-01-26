CREATE TABLE [TMP].[Column_Latch_Insert] (
    [LNK_T2_ID]   INT NULL,
    [LNK_T3_ID]   INT NULL,
    [LNK_T4_ID]   INT NULL,
    [REG_0300_ID] INT NULL,
    [REG_0400_ID] INT NULL,
    [T4_Rank]     INT NULL
);


GO
CREATE NONCLUSTERED INDEX [tdx_nc_CLI_K3_I2_I4_I5]
    ON [TMP].[Column_Latch_Insert]([LNK_T4_ID] ASC)
    INCLUDE([LNK_T3_ID], [REG_0300_ID], [REG_0400_ID]);

