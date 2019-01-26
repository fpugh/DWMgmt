CREATE TABLE [TMP].[SQL_Process_Hash] (
    [Source_ID]     INT            NOT NULL,
    [Catalog_ID]    INT            NOT NULL,
    [Batch_ID]      NCHAR (7)      CONSTRAINT [DF_Batch_ID] DEFAULT ((0)) NOT NULL,
    [Collection_ID] INT            CONSTRAINT [DF_Collection_ID] DEFAULT ((0)) NOT NULL,
    [Version_Stamp] CHAR (40)      NOT NULL,
    [LNK_T3_ID]     INT            CONSTRAINT [DF_T3_ID] DEFAULT ((0)) NOT NULL,
    [Post_Date]     DATETIME       NULL,
    [String_Length] BIGINT         NULL,
    [String]        NVARCHAR (MAX) DEFAULT ('') NULL,
    CONSTRAINT [pk_SQL_Process_Hash] PRIMARY KEY CLUSTERED ([Version_Stamp] ASC)
);

