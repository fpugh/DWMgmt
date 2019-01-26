CREATE TABLE [TMP].[REG_0300_0401_Insert] (
    [LNK_T2_ID]            INT            NULL,
    [LNK_T3_ID]            INT            NULL,
    [LNK_T4_ID]            INT            NULL,
    [REG_0300_ID]          INT            NULL,
    [REG_0400_ID]          INT            NULL,
    [REG_0401_ID]          INT            NULL,
    [Server_ID]            INT            CONSTRAINT [DF_0300_0401_Server_ID] DEFAULT ((0)) NOT NULL,
    [Database_ID]          INT            NULL,
    [Schema_ID]            INT            NULL,
    [Object_ID]            INT            NULL,
    [Object_Type]          NVARCHAR (25)  NULL,
    [Column_Name]          NVARCHAR (256) NULL,
    [Column_Type]          VARCHAR (25)   NULL,
    [Column_Rank]          INT            NULL,
    [Is_Identity]          BIT            NULL,
    [Is_Nullable]          BIT            NULL,
    [Is_Default_Collation] BIT            NULL,
    [Is_Primary_Key]       BIT            NULL,
    [Column_Size]          INT            NULL,
    [Column_Scale]         INT            NULL
);


GO
CREATE NONCLUSTERED INDEX [tdx_nci_reg_0300_0401_K4_K5_I6]
    ON [TMP].[REG_0300_0401_Insert]([REG_0300_ID] ASC, [REG_0400_ID] ASC)
    INCLUDE([REG_0401_ID]);


GO
CREATE NONCLUSTERED INDEX [tdx_nc_reg_0300_0401_K12_K13_I15_I16_I18]
    ON [TMP].[REG_0300_0401_Insert]([Column_Name] ASC, [Column_Type] ASC)
    INCLUDE([Is_Identity], [Is_Nullable], [Is_Primary_Key]);


GO
CREATE CLUSTERED INDEX [tdx_ci_reg_0300_0401_K7_K8_K9_K10_K14]
    ON [TMP].[REG_0300_0401_Insert]([Server_ID] ASC, [Database_ID] ASC, [Schema_ID] ASC, [Object_ID] ASC, [Column_Rank] ASC);

