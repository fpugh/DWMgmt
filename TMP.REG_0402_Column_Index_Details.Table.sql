USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0402_Column_Index_Details]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0402_Column_Index_Details]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0402_Column_Index_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0402_Column_Index_Details](
	[REG_0402_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[index_column_id] [int] NOT NULL,
	[Partition_Ordinal] [int] NOT NULL,
	[is_descending_key] [bit] NOT NULL,
	[is_included_column] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
