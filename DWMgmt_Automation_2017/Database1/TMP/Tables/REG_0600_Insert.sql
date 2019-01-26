CREATE TABLE [TMP].[REG_0600_Insert] (
    [LNK_T3_ID]               INT            NULL,
    [REG_0300_ID]             INT            NULL,
    [REG_0600_ID]             INT            NULL,
    [Server_ID]               INT            NULL,
    [Database_ID]             INT            NULL,
    [Database_Name]           NVARCHAR (256) NULL,
    [Schema_ID]               INT            CONSTRAINT [DF_0600_Server_ID] DEFAULT ((0)) NULL,
    [Schema_Name]             NVARCHAR (256) NULL,
    [Object_ID]               INT            NULL,
    [Object_Name]             NVARCHAR (256) NULL,
    [Object_Type]             NVARCHAR (256) NULL,
    [Type_Desc]               NVARCHAR (256) NULL,
    [uses_ansi_nulls]         BIT            NULL,
    [uses_quoted_Identifier]  BIT            NULL,
    [uses_database_collation] BIT            NULL,
    [is_schema_bound]         BIT            NULL,
    [is_recompiled]           BIT            NULL,
    [null_on_null_input]      BIT            NULL,
    [execute_as_principal_ID] BIT            NULL,
    [Create_Date]             DATETIME       NULL,
    [Code_Content]            NVARCHAR (MAX) NULL
);


GO
CREATE NONCLUSTERED INDEX [tdx_nci_reg_0600_K7_K9_I4_I5_I6]
    ON [TMP].[REG_0600_Insert]([Object_ID] ASC, [Object_Type] ASC)
    INCLUDE([Server_ID], [Database_ID], [Schema_ID]);


GO
CREATE CLUSTERED INDEX [tdx_ci_reg_0600_K2_K3_K4_K5]
    ON [TMP].[REG_0600_Insert]([Server_ID] ASC, [Database_ID] ASC, [Schema_ID] ASC, [Object_ID] ASC);

