USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [TMP].[BatchSort](
	[Batch_ID] [char](7) NULL,
	[File_Size] [bigint] NULL,
	[Version_Stamp] [char](40) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
