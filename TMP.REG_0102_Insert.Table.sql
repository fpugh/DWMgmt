USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0102_Insert]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0102_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0102_Insert]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0102_Insert](
	[REG_0102_ID] [int] NOT NULL,
	[Server_ID] [int] NOT NULL,
	[lazy_schema_validation] [bit] NOT NULL,
	[Is_publisher] [bit] NOT NULL,
	[Is_subscriber] [bit] NULL,
	[Is_distributor] [bit] NULL,
	[Is_nonsql_subscriber] [bit] NULL
) ON [PRIMARY]
END
GO
