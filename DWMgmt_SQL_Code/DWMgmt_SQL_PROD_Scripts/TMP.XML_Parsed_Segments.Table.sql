USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TMP].[XML_Parsed_Segments](
	[Source_ID] [int] NOT NULL,
	[Category] [nvarchar](256) NULL,
	[Word] [nvarchar](256) NULL,
	[Anchor] [int] NOT NULL,
	[Bound] [int] NOT NULL,
	[Segment] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [tdx_nc_XMLStringMap_K1_K4_I5] ON [TMP].[XML_Parsed_Segments]
(
	[Source_ID] ASC,
	[Anchor] ASC
)
INCLUDE ( 	[Bound]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
