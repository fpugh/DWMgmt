USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[XML_Parsed_Segments]') AND name = N'tdx_nc_XMLStringMap_K1_K4_I5')
DROP INDEX [tdx_nc_XMLStringMap_K1_K4_I5] ON [TMP].[XML_Parsed_Segments]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[XML_Parsed_Segments]') AND type in (N'U'))
DROP TABLE [TMP].[XML_Parsed_Segments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[XML_Parsed_Segments]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[XML_Parsed_Segments](
	[Source_ID] [int] NOT NULL,
	[Category] [nvarchar](256) NULL,
	[Word] [nvarchar](256) NULL,
	[Anchor] [int] NOT NULL,
	[Bound] [int] NOT NULL,
	[Segment] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[XML_Parsed_Segments]') AND name = N'tdx_nc_XMLStringMap_K1_K4_I5')
CREATE NONCLUSTERED INDEX [tdx_nc_XMLStringMap_K1_K4_I5] ON [TMP].[XML_Parsed_Segments]
(
	[Source_ID] ASC,
	[Anchor] ASC
)
INCLUDE ( 	[Bound]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
