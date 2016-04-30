USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0205_Database_Maintenance_Properties]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0205_Database_Maintenance_Properties]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0205_Database_Maintenance_Properties]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0205_Database_Maintenance_Properties](
	[REG_0205_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[REG_Task_Type] [nvarchar](130) NOT NULL,
	[REG_Task_Name] [nvarchar](130) NOT NULL,
	[REG_Task_Desc] [nvarchar](512) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
