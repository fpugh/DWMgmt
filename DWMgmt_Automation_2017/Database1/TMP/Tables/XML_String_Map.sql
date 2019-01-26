CREATE TABLE [TMP].[XML_String_Map] (
    [Source_ID]  INT     NOT NULL,
    [Char_Pos]   INT     NOT NULL,
    [ASCII_Char] TINYINT NULL,
    CONSTRAINT [PK_XMLStringMap] PRIMARY KEY CLUSTERED ([Source_ID] ASC, [Char_Pos] ASC)
);


GO
CREATE NONCLUSTERED INDEX [tdx_nc_XMLStringMap_K4_I2_I3]
    ON [TMP].[XML_String_Map]([ASCII_Char] ASC)
    INCLUDE([Source_ID], [Char_Pos]);

