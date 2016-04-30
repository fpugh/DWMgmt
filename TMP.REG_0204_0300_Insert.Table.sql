USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_0204_0300_Rank]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_0204_0300_Insert] DROP CONSTRAINT [DF_0204_0300_Rank]
END

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[REG_0204_0300_Insert]') AND name = N'tdx_nc_REG_0204_0300_K9_K11_I13')
DROP INDEX [tdx_nc_REG_0204_0300_K9_K11_I13] ON [TMP].[REG_0204_0300_Insert]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[REG_0204_0300_Insert]') AND name = N'tdx_ci_REG_0204_0300_K4')
DROP INDEX [tdx_ci_REG_0204_0300_K4] ON [TMP].[REG_0204_0300_Insert] WITH ( ONLINE = OFF )
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0204_0300_Insert]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0204_0300_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0204_0300_Insert]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0204_0300_Insert](
	[LNK_T2_ID] [int] NULL,
	[LNK_T3_ID] [int] NULL,
	[REG_0204_ID] [int] NULL,
	[REG_0300_ID] [int] NULL,
	[Server_ID] [int] NULL,
	[Database_ID] [int] NULL,
	[Schema_ID] [int] NULL,
	[Schema_Name] [nvarchar](256) NULL,
	[Object_ID] [int] NULL,
	[Sub_Object_Rank] [int] NOT NULL,
	[Object_Name] [nvarchar](256) NULL,
	[Object_Type] [nvarchar](25) NULL,
	[Create_Date] [datetime] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[REG_0204_0300_Insert]') AND name = N'tdx_ci_REG_0204_0300_K4')
CREATE CLUSTERED INDEX [tdx_ci_REG_0204_0300_K4] ON [TMP].[REG_0204_0300_Insert]
(
	[Server_ID] ASC,
	[Database_ID] ASC,
	[Schema_ID] ASC,
	[Object_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[REG_0204_0300_Insert]') AND name = N'tdx_nc_REG_0204_0300_K9_K11_I13')
CREATE NONCLUSTERED INDEX [tdx_nc_REG_0204_0300_K9_K11_I13] ON [TMP].[REG_0204_0300_Insert]
(
	[Schema_Name] ASC,
	[Object_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_0204_0300_Rank]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[REG_0204_0300_Insert] ADD  CONSTRAINT [DF_0204_0300_Rank]  DEFAULT ((0)) FOR [Sub_Object_Rank]
END

GO
