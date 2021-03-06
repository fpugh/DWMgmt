USE [DWMgmt]
GO


CREATE TABLE [TMP].[TXT_Parsed_Segments](
	[Source_ID] [int] NOT NULL,
	[Category] [nvarchar](256) NULL,
	[Word] [nvarchar](256) NULL,
	[Anchor] [int] NOT NULL,
	[Bound] [int] NOT NULL,
	[Segment] [nvarchar](max) NULL,
 CONSTRAINT [pk_TXTParsedSegments] PRIMARY KEY CLUSTERED 
(
	[Source_ID] ASC,
	[Anchor] ASC,
	[Bound] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
