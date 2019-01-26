CREATE TABLE [TMP].[REG_0100_0200_Insert] (
    [LNK_T2_ID]           INT            NOT NULL,
    [REG_0100_ID]         INT            NOT NULL,
    [REG_0200_ID]         INT            NOT NULL,
    [Server_ID]           INT            NOT NULL,
    [Server_Name]         NVARCHAR (256) NOT NULL,
    [product]             NVARCHAR (256) NOT NULL,
    [Database_ID]         INT            NULL,
    [Database_Name]       NVARCHAR (256) NULL,
    [compatibility_level] TINYINT        NULL,
    [collation_Name]      NVARCHAR (65)  NULL,
    [recovery_model_Desc] NVARCHAR (65)  NULL,
    [Create_Date]         DATETIME       NOT NULL
);


GO
CREATE CLUSTERED INDEX [tdx_ci_reg_0100_0200_K3_K5]
    ON [TMP].[REG_0100_0200_Insert]([Server_Name] ASC, [Database_Name] ASC);

