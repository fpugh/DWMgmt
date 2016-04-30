USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_0203_Server_ID]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_0203_Insert] DROP CONSTRAINT [DF_0203_Server_ID]
END

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[REG_0203_Insert]') AND name = N'tdx_ci_REG_0203_K2_K3')
DROP INDEX [tdx_ci_REG_0203_K2_K3] ON [TMP].[REG_0203_Insert] WITH ( ONLINE = OFF )
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0203_Insert]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0203_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0203_Insert]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0203_Insert](
	[REG_0203_ID] [int] NULL,
	[Server_ID] [int] NOT NULL,
	[Database_ID] [int] NULL,
	[Size] [int] NULL,
	[Max_Size] [bigint] NULL,
	[Growth] [bigint] NULL,
	[Physical_Name] [nvarchar](256) NULL,
	[File_ID] [int] NULL,
	[Type] [tinyint] NULL,
	[Database_File_Name] [nvarchar](256) NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[REG_0203_Insert]') AND name = N'tdx_ci_REG_0203_K2_K3')
CREATE CLUSTERED INDEX [tdx_ci_REG_0203_K2_K3] ON [TMP].[REG_0203_Insert]
(
	[Server_ID] ASC,
	[Database_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_0203_Server_ID]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_0203_Insert] ADD  CONSTRAINT [DF_0203_Server_ID]  DEFAULT ((0)) FOR [Server_ID]
END

GO
