USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TMP].[REG_0103_Insert](
	[REG_0103_ID] [int] NOT NULL,
	[Server_ID] [int] NOT NULL,
	[Provider] [sysname] NOT NULL,
	[Data_Source] [nvarchar](256) NULL,
	[Provider_String] [nvarchar](2000) NULL,
	[Catalog] [sysname] NULL
) ON [PRIMARY]

GO
