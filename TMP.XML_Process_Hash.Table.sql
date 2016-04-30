USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_XML_String]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[XML_Process_Hash] DROP CONSTRAINT [DF_XML_String]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_REG_1100_0]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[XML_Process_Hash] DROP CONSTRAINT [DF_REG_1100_0]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[XML_Process_Hash]') AND type in (N'U'))
DROP TABLE [TMP].[XML_Process_Hash]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[XML_Process_Hash]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[XML_Process_Hash](
	[Rank_Stamp] [char](2) NULL,
	[Collection_ID] [int] NULL,
	[Source_ID] [int] NULL,
	[REG_1100_ID] [int] NULL,
	[Version_Stamp] [char](40) NOT NULL,
	[Post_Date] [datetime] NULL,
	[String_Length] [bigint] NULL,
	[String] [nvarchar](max) NULL,
 CONSTRAINT [pk_XMLProcessHash] PRIMARY KEY CLUSTERED 
(
	[Version_Stamp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_REG_1100_0]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[XML_Process_Hash] ADD  CONSTRAINT [DF_REG_1100_0]  DEFAULT ((0)) FOR [REG_1100_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_XML_String]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[XML_Process_Hash] ADD  CONSTRAINT [DF_XML_String]  DEFAULT ('') FOR [String]
END

GO
