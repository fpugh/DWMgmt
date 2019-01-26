CREATE TABLE [TMP].[XML_Process_Hash] (
    [Rank_Stamp]    CHAR (2)       NULL,
    [Batch_ID]      NCHAR (7)      NULL,
    [Collection_ID] INT            NULL,
    [Source_ID]     INT            NULL,
    [REG_1100_ID]   INT            CONSTRAINT [DF_REG_1100_0] DEFAULT ((0)) NULL,
    [Version_Stamp] CHAR (40)      NOT NULL,
    [Post_Date]     DATETIME       NULL,
    [String_Length] BIGINT         NULL,
    [String]        NVARCHAR (MAX) CONSTRAINT [DF_XML_String] DEFAULT ('') NULL,
    CONSTRAINT [PK_XMLProcessHash] PRIMARY KEY CLUSTERED ([Version_Stamp] ASC)
);

