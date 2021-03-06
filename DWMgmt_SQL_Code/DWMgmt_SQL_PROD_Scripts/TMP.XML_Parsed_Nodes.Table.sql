USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TMP].[XML_Parsed_Nodes](
	[Source_ID] [int] NOT NULL,
	[Node_Name] [nvarchar](256) NOT NULL,
	[Node_Level] [int] NOT NULL,
	[Node_Class] [nvarchar](25) NOT NULL,
	[Anchor] [bigint] NOT NULL,
	[Bound] [bigint] NOT NULL,
 CONSTRAINT [PK_XMLNodes] PRIMARY KEY CLUSTERED 
(
	[Source_ID] ASC,
	[Anchor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
