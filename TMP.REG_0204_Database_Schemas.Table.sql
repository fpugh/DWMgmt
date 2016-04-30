USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0204_Database_Schemas]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0204_Database_Schemas]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0204_Database_Schemas]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0204_Database_Schemas](
	[REG_0204_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[REG_Schema_Name] [nvarchar](510) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
