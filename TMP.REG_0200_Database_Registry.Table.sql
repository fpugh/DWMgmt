USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0200_Database_Registry]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0200_Database_Registry]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0200_Database_Registry]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0200_Database_Registry](
	[REG_0200_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[REG_Database_Name] [nvarchar](256) NOT NULL,
	[REG_Compatibility] [tinyint] NOT NULL,
	[REG_Collation] [nvarchar](256) NOT NULL,
	[REG_Recovery_Model] [nvarchar](130) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
	[REG_Monitored] [bit] NOT NULL
) ON [PRIMARY]
END
GO
