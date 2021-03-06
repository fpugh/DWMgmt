USE [OGMarket]
GO



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

GO
