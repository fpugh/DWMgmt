USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0100_Server_Registry]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0100_Server_Registry]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0100_Server_Registry]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0100_Server_Registry](
	[REG_0100_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[REG_Server_Name] [nvarchar](512) NOT NULL,
	[REG_Product] [nvarchar](512) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
	[REG_Monitored] [bit] NOT NULL
) ON [PRIMARY]
END
GO
