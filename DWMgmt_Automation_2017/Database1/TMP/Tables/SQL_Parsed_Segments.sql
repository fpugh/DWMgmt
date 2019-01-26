CREATE TABLE [TMP].[SQL_Parsed_Segments] (
    [Source_ID] INT            NOT NULL,
    [Category]  NVARCHAR (256) NULL,
    [Word]      NVARCHAR (256) NULL,
    [Anchor]    INT            NOT NULL,
    [Bound]     INT            NOT NULL,
    [Segment]   NVARCHAR (MAX) NULL,
    CONSTRAINT [pk_SQLParsedSegments] PRIMARY KEY CLUSTERED ([Source_ID] ASC, [Anchor] ASC, [Bound] ASC)
);


GO
CREATE NONCLUSTERED INDEX [tdx_nc_ParsedSegments_K2_I1_I3_I4_I6]
    ON [TMP].[SQL_Parsed_Segments]([Category] ASC)
    INCLUDE([Source_ID], [Word], [Anchor], [Segment]);


GO
CREATE NONCLUSTERED INDEX [tdx_nc_ParsedSegments_K3_I4_I6]
    ON [TMP].[SQL_Parsed_Segments]([Word] ASC)
    INCLUDE([Anchor], [Segment]);

