CREATE TABLE [TMP].[SQL_String_Map] (
    [Source_ID]  INT     NOT NULL,
    [Char_Pos]   INT     NOT NULL,
    [ASCII_Char] TINYINT NULL,
    CONSTRAINT [pk_SQLStringMap] PRIMARY KEY CLUSTERED ([Source_ID] ASC, [Char_Pos] ASC)
);


GO
CREATE NONCLUSTERED INDEX [tdx_nc_SQLStringMap_K3_I4]
    ON [TMP].[SQL_String_Map]([Char_Pos] ASC)
    INCLUDE([ASCII_Char]);

