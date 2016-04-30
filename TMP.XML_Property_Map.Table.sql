USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[XML_Property_Map]') AND type in (N'U'))
DROP TABLE [TMP].[XML_Property_Map]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[XML_Property_Map]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[XML_Property_Map](
	[Source_ID] [int] NOT NULL,
	[Value_Anchor] [int] NOT NULL,
	[Value_Bound] [int] NOT NULL,
	[Property_Anchor] [int] NOT NULL,
	[Node_Name] [nvarchar](256) NOT NULL,
	[Property_Rank] [int] NOT NULL,
	[Property] [nvarchar](256) NOT NULL,
	[Sub_Segment] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_XMLPropMap] PRIMARY KEY CLUSTERED 
(
	[Source_ID] ASC,
	[Value_Anchor] ASC,
	[Value_Bound] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
