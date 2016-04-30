USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_0600_Server_ID]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_0600_Insert] DROP CONSTRAINT [DF_0600_Server_ID]
END

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[REG_0600_Insert]') AND name = N'tdx_nci_REG_0600_K7_K9_I4_I5_I6')
DROP INDEX [tdx_nci_REG_0600_K7_K9_I4_I5_I6] ON [TMP].[REG_0600_Insert]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[REG_0600_Insert]') AND name = N'tdx_ci_REG_0600_K2_K3_K4_K5')
DROP INDEX [tdx_ci_REG_0600_K2_K3_K4_K5] ON [TMP].[REG_0600_Insert] WITH ( ONLINE = OFF )
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0600_Insert]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0600_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0600_Insert]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0600_Insert](
	[LNK_T3_ID] [int] NULL,
	[REG_0300_ID] [int] NULL,
	[REG_0600_ID] [int] NULL,
	[Server_ID] [int] NULL,
	[Database_ID] [int] NULL,
	[Database_Name] [nvarchar](256) NULL,
	[Schema_ID] [int] NULL,
	[Schema_Name] [nvarchar](256) NULL,
	[Object_ID] [int] NULL,
	[Object_Name] [nvarchar](256) NULL,
	[Object_Type] [nvarchar](256) NULL,
	[Type_Desc] [nvarchar](256) NULL,
	[uses_ansi_nulls] [bit] NULL,
	[uses_quoted_Identifier] [bit] NULL,
	[uses_database_collation] [bit] NULL,
	[is_schema_bound] [bit] NULL,
	[is_recompiled] [bit] NULL,
	[null_on_null_input] [bit] NULL,
	[execute_as_principal_ID] [bit] NULL,
	[Create_Date] [datetime] NULL,
	[Code_Content] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[REG_0600_Insert]') AND name = N'tdx_ci_REG_0600_K2_K3_K4_K5')
CREATE CLUSTERED INDEX [tdx_ci_REG_0600_K2_K3_K4_K5] ON [TMP].[REG_0600_Insert]
(
	[Server_ID] ASC,
	[Database_ID] ASC,
	[Schema_ID] ASC,
	[Object_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[REG_0600_Insert]') AND name = N'tdx_nci_REG_0600_K7_K9_I4_I5_I6')
CREATE NONCLUSTERED INDEX [tdx_nci_REG_0600_K7_K9_I4_I5_I6] ON [TMP].[REG_0600_Insert]
(
	[Object_ID] ASC,
	[Object_Type] ASC
)
INCLUDE ( 	[Server_ID],
	[Database_ID],
	[Schema_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_0600_Server_ID]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_0600_Insert] ADD  CONSTRAINT [DF_0600_Server_ID]  DEFAULT ((0)) FOR [Schema_ID]
END

GO
