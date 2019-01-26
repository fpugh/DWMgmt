CREATE TABLE [TMP].[REG_0204_0300_Insert] (
    [LNK_T2_ID]       INT            NULL,
    [LNK_T3_ID]       INT            NULL,
    [REG_0204_ID]     INT            NULL,
    [REG_0300_ID]     INT            NULL,
    [Server_ID]       INT            NULL,
    [Database_ID]     INT            NULL,
    [Schema_ID]       INT            NULL,
    [Schema_Name]     NVARCHAR (256) NULL,
    [Object_ID]       INT            NULL,
    [Sub_Object_Rank] INT            NOT NULL,
    [Object_Name]     NVARCHAR (256) NULL,
    [Object_Type]     NVARCHAR (25)  NULL,
    [Create_Date]     DATETIME       NULL
);


GO
CREATE NONCLUSTERED INDEX [tdx_nc_reg_0204_0300_K9_K11_I13]
    ON [TMP].[REG_0204_0300_Insert]([Schema_Name] ASC, [Object_Name] ASC);


GO
CREATE CLUSTERED INDEX [tdx_ci_reg_0204_0300_K4]
    ON [TMP].[REG_0204_0300_Insert]([Server_ID] ASC, [Database_ID] ASC, [Schema_ID] ASC, [Object_ID] ASC);

