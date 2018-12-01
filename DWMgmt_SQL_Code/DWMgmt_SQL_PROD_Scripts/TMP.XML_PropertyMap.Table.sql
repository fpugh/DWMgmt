USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TMP].[XML_PropertyMap](
	[Source_ID] [int] NOT NULL,
	[ValueAnchor] [int] NOT NULL,
	[ValueBound] [int] NOT NULL,
	[PropertyAnchor] [int] NOT NULL
) ON [PRIMARY]

GO
