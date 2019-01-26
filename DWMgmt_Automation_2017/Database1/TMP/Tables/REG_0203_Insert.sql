CREATE TABLE [TMP].[REG_0203_Insert] (
    [REG_0203_ID]        INT            NULL,
    [Server_ID]          INT            CONSTRAINT [DF_0203_Server_ID] DEFAULT ((0)) NOT NULL,
    [Database_ID]        INT            NULL,
    [Size]               INT            NULL,
    [Max_Size]           BIGINT         NULL,
    [Growth]             BIGINT         NULL,
    [Physical_Name]      NVARCHAR (256) NULL,
    [File_ID]            INT            NULL,
    [Type]               TINYINT        NULL,
    [Database_File_Name] NVARCHAR (256) NULL
);


GO
CREATE CLUSTERED INDEX [tdx_ci_reg_0203_K2_K3]
    ON [TMP].[REG_0203_Insert]([Server_ID] ASC, [Database_ID] ASC);

