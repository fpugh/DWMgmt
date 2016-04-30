USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[TXT_String_Map]') AND name = N'tdx_nc_TXTStringMap_K3_I2')
DROP INDEX [tdx_nc_TXTStringMap_K3_I2] ON [TMP].[TXT_String_Map]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TXT_String_Map]') AND type in (N'U'))
DROP TABLE [TMP].[TXT_String_Map]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TXT_String_Map]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[TXT_String_Map](
	[Source_ID] [int] NOT NULL,
	[ASCII_Char] [tinyint] NOT NULL,
	[Char_Pos] [int] NOT NULL,
 CONSTRAINT [pk_TXTStringMap] PRIMARY KEY CLUSTERED 
(
	[Source_ID] ASC,
	[Char_Pos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[TXT_String_Map]') AND name = N'tdx_nc_TXTStringMap_K3_I2')
CREATE NONCLUSTERED INDEX [tdx_nc_TXTStringMap_K3_I2] ON [TMP].[TXT_String_Map]
(
	[Char_Pos] ASC
)
INCLUDE ( 	[ASCII_Char]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
