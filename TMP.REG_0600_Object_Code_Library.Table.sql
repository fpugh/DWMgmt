USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0600_Object_Code_Library]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0600_Object_Code_Library]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0600_Object_Code_Library]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0600_Object_Code_Library](
	[REG_0600_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[REG_Code_Base] [nvarchar](50) NOT NULL,
	[REG_Code_Class] [nvarchar](130) NOT NULL,
	[reg_Code_Hash] [varbinary](20) NOT NULL,
	[REG_Code_Content] [varchar](8000) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
