USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0401_Column_Properties]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0401_Column_Properties]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0401_Column_Properties]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0401_Column_Properties](
	[REG_0401_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[REG_Size] [int] NOT NULL,
	[REG_Scale] [int] NOT NULL,
	[is_identity] [bit] NOT NULL,
	[is_nullable] [bit] NOT NULL,
	[Is_Default_Collation] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
