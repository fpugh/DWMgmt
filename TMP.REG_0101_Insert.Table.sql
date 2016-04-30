USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0101_Insert]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0101_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0101_Insert]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0101_Insert](
	[REG_0101_ID] [int] NOT NULL,
	[Server_ID] [int] NOT NULL,
	[Is_linked] [bit] NOT NULL,
	[Is_remote_login_enabled] [bit] NOT NULL,
	[Is_rpc_out_enabled] [bit] NOT NULL,
	[Is_data_access_enabled] [bit] NOT NULL,
	[Is_Collation_compatible] [bit] NOT NULL,
	[uses_remote_Collation] [bit] NOT NULL,
	[collation_Name] [sysname] NULL,
	[connect_timeout] [int] NULL,
	[query_timeout] [int] NULL,
	[Is_system] [bit] NOT NULL,
	[Is_remote_proc_transaction_promotion_enabled] [bit] NULL
) ON [PRIMARY]
END
GO
