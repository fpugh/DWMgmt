USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TXT_Shred_List]') AND type in (N'U'))
DROP TABLE [TMP].[TXT_Shred_List]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TXT_Shred_List]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[TXT_Shred_List](
	[Ordinal] [int] NULL,
	[Processed] [int] NOT NULL,
	[name] [sysname] NOT NULL
) ON [PRIMARY]
END
GO
