USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TMP].[XML_Nodes](
	[Source_ID] [int] NULL,
	[Node_Name] [nvarchar](65) NULL,
	[Node_Level] [int] NULL,
	[Node_Class] [nvarchar](65) NULL,
	[Anchor] [bigint] NULL,
	[Bound] [bigint] NULL
) ON [PRIMARY]

GO
