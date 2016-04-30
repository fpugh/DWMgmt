USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[XML_Property_Bounds]') AND name = N'NCI_PropertyBounds')
DROP INDEX [NCI_PropertyBounds] ON [TMP].[XML_Property_Bounds]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[XML_Property_Bounds]') AND type in (N'U'))
DROP TABLE [TMP].[XML_Property_Bounds]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[XML_Property_Bounds]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[XML_Property_Bounds](
	[Source_ID] [int] NOT NULL,
	[Node_Name] [nvarchar](256) NOT NULL,
	[Anchor] [bigint] NOT NULL,
	[Map_Bound] [bigint] NOT NULL,
 CONSTRAINT [PK_XML_Property_Bounds] PRIMARY KEY CLUSTERED 
(
	[Source_ID] ASC,
	[Anchor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING ON

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[XML_Property_Bounds]') AND name = N'NCI_PropertyBounds')
CREATE NONCLUSTERED INDEX [NCI_PropertyBounds] ON [TMP].[XML_Property_Bounds]
(
	[Anchor] ASC
)
INCLUDE ( 	[Source_ID],
	[Node_Name]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
