USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0103_Insert]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0103_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0103_Insert]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0103_Insert](
	[REG_0103_ID] [int] NOT NULL,
	[Server_ID] [int] NOT NULL,
	[Provider] [sysname] NOT NULL,
	[Data_Source] [nvarchar](256) NULL,
	[Provider_String] [nvarchar](2000) NULL,
	[Catalog] [sysname] NULL
) ON [PRIMARY]
END
GO
