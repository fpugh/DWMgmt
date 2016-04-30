USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__TRK_0354___Post___33015847]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[TRK_0354_Value_Hash] DROP CONSTRAINT [DF__TRK_0354___Post___33015847]
END

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0354_Value_Hash]') AND name = N'tdx_nc_0354_Hash_K2_I3_I5_I4')
DROP INDEX [tdx_nc_0354_Hash_K2_I3_I5_I4] ON [TMP].[TRK_0354_Value_Hash]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0354_Value_Hash]') AND name = N'idx_nc_TRK_0354_K1_I2')
DROP INDEX [idx_nc_TRK_0354_K1_I2] ON [TMP].[TRK_0354_Value_Hash]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0354_Value_Hash]') AND type in (N'U'))
DROP TABLE [TMP].[TRK_0354_Value_Hash]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0354_Value_Hash]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[TRK_0354_Value_Hash](
	[TBL_ID] [int] IDENTITY(1,1) NOT NULL,
	[LNK_T4_ID] [int] NOT NULL,
	[Column_Value] [nvarchar](4000) NULL,
	[Value_Count] [bigint] NULL,
	[Post_Date] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING ON

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0354_Value_Hash]') AND name = N'idx_nc_TRK_0354_K1_I2')
CREATE NONCLUSTERED INDEX [idx_nc_TRK_0354_K1_I2] ON [TMP].[TRK_0354_Value_Hash]
(
	[LNK_T4_ID] ASC
)
INCLUDE ( 	[Column_Value]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0354_Value_Hash]') AND name = N'tdx_nc_0354_Hash_K2_I3_I5_I4')
CREATE NONCLUSTERED INDEX [tdx_nc_0354_Hash_K2_I3_I5_I4] ON [TMP].[TRK_0354_Value_Hash]
(
	[LNK_T4_ID] ASC
)
INCLUDE ( 	[Column_Value],
	[Value_Count],
	[Post_Date]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__TRK_0354___Post___33015847]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[TRK_0354_Value_Hash] ADD  DEFAULT (getdate()) FOR [Post_Date]
END

GO
