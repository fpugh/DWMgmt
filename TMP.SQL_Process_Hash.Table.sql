USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__SQL_Proce__Strin__60DD3190]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[SQL_Process_Hash] DROP CONSTRAINT [DF__SQL_Proce__Strin__60DD3190]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_T3_ID]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[SQL_Process_Hash] DROP CONSTRAINT [DF_T3_ID]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[SQL_Process_Hash]') AND type in (N'U'))
DROP TABLE [TMP].[SQL_Process_Hash]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[SQL_Process_Hash]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[SQL_Process_Hash](
	[Source_ID] [int] NOT NULL,
	[Catalog_ID] [int] NOT NULL,
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
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_T3_ID]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[SQL_Process_Hash] ADD  CONSTRAINT [DF_T3_ID]  DEFAULT ((0)) FOR [LNK_T3_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__SQL_Proce__Strin__60DD3190]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[SQL_Process_Hash] ADD  DEFAULT ('') FOR [String]
END

GO
