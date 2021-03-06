USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TMP].[XML_String_Map](
	[Source_ID] [int] NOT NULL,
	[Char_Pos] [int] NOT NULL,
	[ASCII_Char] [tinyint] NULL,
 CONSTRAINT [PK_XMLStringMap] PRIMARY KEY CLUSTERED 
(
	[Source_ID] ASC,
	[Char_Pos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [tdx_nc_XMLStringMap_K4_I2_I3] ON [TMP].[XML_String_Map]
(
	[ASCII_Char] ASC
)
INCLUDE ( 	[Source_ID],
	[Char_Pos]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
