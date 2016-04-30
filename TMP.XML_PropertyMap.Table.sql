USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[XML_PropertyMap]') AND type in (N'U'))
DROP TABLE [TMP].[XML_PropertyMap]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[XML_PropertyMap]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[XML_PropertyMap](
	[Source_ID] [int] NOT NULL,
	[ValueAnchor] [int] NOT NULL,
	[ValueBound] [int] NOT NULL,
	[PropertyAnchor] [int] NOT NULL
) ON [PRIMARY]
END
GO
