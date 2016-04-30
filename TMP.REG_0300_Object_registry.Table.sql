USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0300_Object_registry]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0300_Object_registry]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0300_Object_registry]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0300_Object_registry](
	[REG_0300_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[REG_Object_Name] [nvarchar](510) NOT NULL,
	[REG_Object_Type] [nvarchar](50) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
