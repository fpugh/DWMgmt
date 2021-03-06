USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [TMP].[XML_Process_Hash](
	[Rank_Stamp] [char](2) NULL,
	[Batch_ID] [nchar](7) NULL,
	[Collection_ID] [int] NULL,
	[Source_ID] [int] NULL,
	[REG_1100_ID] [int] NULL,
	[Version_Stamp] [char](40) NOT NULL,
	[Post_Date] [datetime] NULL,
	[String_Length] [bigint] NULL,
	[String] [nvarchar](max) NULL,
 CONSTRAINT [PK_XMLProcessHash] PRIMARY KEY CLUSTERED 
(
	[Version_Stamp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [TMP].[XML_Process_Hash] ADD  CONSTRAINT [DF_REG_1100_0]  DEFAULT ((0)) FOR [REG_1100_ID]
GO
ALTER TABLE [TMP].[XML_Process_Hash] ADD  CONSTRAINT [DF_XML_String]  DEFAULT ('') FOR [String]
GO
