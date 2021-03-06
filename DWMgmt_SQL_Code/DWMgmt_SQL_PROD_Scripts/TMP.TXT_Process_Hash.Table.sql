USE [DWMgmt]
GO

CREATE TABLE [TMP].[TXT_Process_Hash](
	[Collection_ID] [int] NOT NULL,
	[Source_ID] [int] NOT NULL,
	[Version_Stamp] [char](40) NOT NULL,
	[Post_Date] [datetime] NULL,
	[File_Type] [nvarchar](16) NULL,
	[String_Length] [bigint] NULL,
	[String] [nvarchar](max) NULL,
	[Batch_ID] [nchar](10) NULL,
 CONSTRAINT [pk_TXT_Process_Hash] PRIMARY KEY CLUSTERED 
(
	[Version_Stamp] ASC,
	[Source_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [TMP].[TXT_Process_Hash] ADD  DEFAULT ('') FOR [String]
GO


