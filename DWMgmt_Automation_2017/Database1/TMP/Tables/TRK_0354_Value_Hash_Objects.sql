CREATE TABLE [TMP].[TRK_0354_Value_Hash_Objects] (
    [TBL_VHO_ID]        INT            IDENTITY (1, 1) NOT NULL,
    [LNK_T4_ID]         INT            NOT NULL,
    [Server_Name]       NVARCHAR (256) NULL,
    [Database_Name]     NVARCHAR (256) NULL,
    [Schema_Bound_Name] NVARCHAR (512) NULL,
    [Column_Name]       NVARCHAR (256) NULL,
    [Column_Type]       NVARCHAR (256) NULL,
    [Collate_Flag]      NCHAR (1)      NULL
);

