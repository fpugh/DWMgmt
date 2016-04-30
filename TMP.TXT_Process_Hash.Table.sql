USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__TXT_Proce__Strin__5D96B091]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[TXT_Process_Hash] DROP CONSTRAINT [DF__TXT_Proce__Strin__5D96B091]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TXT_Process_Hash]') AND type in (N'U'))
DROP TABLE [TMP].[TXT_Process_Hash]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TXT_Process_Hash]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[TXT_Process_Hash](
	[Collection_ID] [int] NOT NULL,
	[Source_ID] [int] NOT NULL,
	[Version_Stamp] [char](40) NOT NULL,
	[Post_Date] [datetime] NULL,
	[File_Type] [nvarchar](16) NULL,
	[String_Length] [bigint] NULL,
	[String] [nvarchar](max) NULL,
 CONSTRAINT [pk_TXT_Process_Hash] PRIMARY KEY CLUSTERED 
(
	[Version_Stamp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__TXT_Proce__Strin__5D96B091]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[TXT_Process_Hash] ADD  DEFAULT ('') FOR [String]
END

GO
