USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [TMP].[SQL_Process_Hash](
	[Source_ID] [int] NOT NULL,
	[Catalog_ID] [int] NOT NULL,
	[Batch_ID] [nchar](7) NOT NULL,
	[Collection_ID] [int] NOT NULL,
	[Version_Stamp] [char](40) NOT NULL,
	[LNK_T3_ID] [int] NOT NULL,
	[Post_Date] [datetime] NULL,
	[String_Length] [bigint] NULL,
	[String] [nvarchar](max) NULL,
 CONSTRAINT [pk_SQL_Process_Hash] PRIMARY KEY CLUSTERED 
(
	[Version_Stamp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [TMP].[SQL_Process_Hash] ADD  CONSTRAINT [DF_Batch_ID]  DEFAULT ((0)) FOR [Batch_ID]
GO
ALTER TABLE [TMP].[SQL_Process_Hash] ADD  CONSTRAINT [DF_Collection_ID]  DEFAULT ((0)) FOR [Collection_ID]
GO
ALTER TABLE [TMP].[SQL_Process_Hash] ADD  CONSTRAINT [DF_T3_ID]  DEFAULT ((0)) FOR [LNK_T3_ID]
GO
ALTER TABLE [TMP].[SQL_Process_Hash] ADD  DEFAULT ('') FOR [String]
GO
