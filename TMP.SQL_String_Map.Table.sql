USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[SQL_String_Map]') AND name = N'tdx_nc_SQLStringMap_K3_I4')
DROP INDEX [tdx_nc_SQLStringMap_K3_I4] ON [TMP].[SQL_String_Map]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[SQL_String_Map]') AND type in (N'U'))
DROP TABLE [TMP].[SQL_String_Map]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[SQL_String_Map]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[SQL_String_Map](
	[Source_ID] [int] NOT NULL,
	[Char_Pos] [int] NOT NULL,
	[ASCII_Char] [tinyint] NULL,
 CONSTRAINT [pk_SQLStringMap] PRIMARY KEY CLUSTERED 
(
	[Source_ID] ASC,
	[Char_Pos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[SQL_String_Map]') AND name = N'tdx_nc_SQLStringMap_K3_I4')
CREATE NONCLUSTERED INDEX [tdx_nc_SQLStringMap_K3_I4] ON [TMP].[SQL_String_Map]
(
	[Char_Pos] ASC
)
INCLUDE ( 	[ASCII_Char]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
