CREATE TABLE [TMP].[XML_Parsed_Segments] (
    [Source_ID] INT            NOT NULL,
    [Category]  NVARCHAR (256) NULL,
    [Word]      NVARCHAR (256) NULL,
    [Anchor]    INT            NOT NULL,
    [Bound]     INT            NOT NULL,
    [Segment]   NVARCHAR (MAX) NULL
);


GO
CREATE NONCLUSTERED INDEX [tdx_nc_XMLStringMap_K1_K4_I5]
    ON [TMP].[XML_Parsed_Segments]([Source_ID] ASC, [Anchor] ASC)
    INCLUDE([Bound]);

