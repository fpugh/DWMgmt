CREATE TABLE [TMP].[TXT_Parsed_Segments] (
    [Source_ID] INT            NOT NULL,
    [Category]  NVARCHAR (256) NULL,
    [Word]      NVARCHAR (256) NULL,
    [Anchor]    INT            NOT NULL,
    [Bound]     INT            NOT NULL,
    [Segment]   NVARCHAR (MAX) NULL,
    CONSTRAINT [pk_TXTParsedSegments] PRIMARY KEY CLUSTERED ([Source_ID] ASC, [Anchor] ASC, [Bound] ASC)
);

