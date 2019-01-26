CREATE TABLE [TMP].[TRK_0354_Value_Hash] (
    [LNK_T4_ID]    INT             NOT NULL,
    [Column_Value] NVARCHAR (4000) NULL,
    [Value_Count]  BIGINT          NULL,
    [Post_Date]    DATETIME        CONSTRAINT [DF_VH_PostDate] DEFAULT (getdate()) NOT NULL
);

