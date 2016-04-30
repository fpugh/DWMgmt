USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0101_Linked_Server_Settings]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0101_Linked_Server_Settings]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0101_Linked_Server_Settings]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0101_Linked_Server_Settings](
	[REG_0101_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[REG_Linked_Flag] [bit] NOT NULL,
	[REG_Remote_Login_Flag] [bit] NOT NULL,
	[REG_RPC_Out_Flag] [bit] NOT NULL,
	[REG_Data_Access_Flag] [bit] NOT NULL,
	[REG_Collation_Compatible] [bit] NOT NULL,
	[REG_Remote_Collation_Flag] [bit] NOT NULL,
	[REG_Collation_Name] [nvarchar](512) NOT NULL,
	[REG_Connection_TO] [int] NOT NULL,
	[REG_Query_TO] [int] NOT NULL,
	[REG_System_Flag] [bit] NOT NULL,
	[REG_RPT_TPE_Flag] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
