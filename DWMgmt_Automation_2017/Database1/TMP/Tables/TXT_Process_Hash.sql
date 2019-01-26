CREATE TABLE [TMP].[TXT_Process_Hash] (
    [Collection_ID] INT            NOT NULL,
    [Source_ID]     INT            NOT NULL,
    [Version_Stamp] CHAR (40)      NOT NULL,
    [Post_Date]     DATETIME       NULL,
    [File_Type]     NVARCHAR (16)  NULL,
    [String_Length] BIGINT         NULL,
    [String]        NVARCHAR (MAX) DEFAULT ('') NULL,
    [Batch_ID]      NCHAR (10)     NULL
);

