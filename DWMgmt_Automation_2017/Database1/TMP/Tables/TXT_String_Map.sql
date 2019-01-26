CREATE TABLE [TMP].[TXT_String_Map] (
    [Source_ID]  INT     NOT NULL,
    [ASCII_Char] TINYINT NOT NULL,
    [Char_Pos]   INT     NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [tdx_nc_TXT_String_Map_K2_I3_I4]
    ON [TMP].[TXT_String_Map]([Source_ID] ASC)
    INCLUDE([ASCII_Char], [Char_Pos]);

