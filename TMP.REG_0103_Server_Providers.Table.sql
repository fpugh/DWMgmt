USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0103_Server_Providers]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0103_Server_Providers]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0103_Server_Providers]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0103_Server_Providers](
	[REG_0103_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[REG_Provider] [nvarchar](512) NOT NULL,
	[REG_Data_Source] [nvarchar](512) NOT NULL,
	[REG_Provider_String] [nvarchar](512) NOT NULL,
	[REG_Catalog] [nvarchar](130) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
