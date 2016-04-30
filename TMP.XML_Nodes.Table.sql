USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[XML_Nodes]') AND type in (N'U'))
DROP TABLE [TMP].[XML_Nodes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[XML_Nodes]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[XML_Nodes](
	[Source_ID] [int] NULL,
	[Node_Name] [nvarchar](65) NULL,
	[Node_Level] [int] NULL,
	[Node_Class] [nvarchar](65) NULL,
	[Anchor] [bigint] NULL,
	[Bound] [bigint] NULL
) ON [PRIMARY]
END
GO
