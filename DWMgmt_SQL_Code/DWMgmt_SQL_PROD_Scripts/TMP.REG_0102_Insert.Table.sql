USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TMP].[REG_0102_Insert](
	[REG_0102_ID] [int] NOT NULL,
	[Server_ID] [int] NOT NULL,
	[lazy_schema_validation] [bit] NOT NULL,
	[Is_publisher] [bit] NOT NULL,
	[Is_subscriber] [bit] NULL,
	[Is_distributor] [bit] NULL,
	[Is_nonsql_subscriber] [bit] NULL
) ON [PRIMARY]

GO
