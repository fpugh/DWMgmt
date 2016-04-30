USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0501_Parameter_Properties]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0501_Parameter_Properties]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0501_Parameter_Properties]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0501_Parameter_Properties](
	[REG_0501_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[REG_Size] [int] NOT NULL,
	[REG_Scale] [int] NOT NULL,
	[Is_Input] [bit] NOT NULL,
	[is_output] [bit] NOT NULL,
	[is_cursor_ref] [bit] NOT NULL,
	[has_default_value] [bit] NOT NULL,
	[is_xml_document] [bit] NOT NULL,
	[is_readonly] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
