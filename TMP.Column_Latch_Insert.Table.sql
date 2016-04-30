USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[Column_Latch_Insert]') AND name = N'tdx_nc_CLI_K3_I2_I4_I5')
DROP INDEX [tdx_nc_CLI_K3_I2_I4_I5] ON [TMP].[Column_Latch_Insert]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[Column_Latch_Insert]') AND name = N'idx_nc_CLI_K3_I2_I4_I5')
DROP INDEX [idx_nc_CLI_K3_I2_I4_I5] ON [TMP].[Column_Latch_Insert]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[Column_Latch_Insert]') AND type in (N'U'))
DROP TABLE [TMP].[Column_Latch_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[Column_Latch_Insert]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[Column_Latch_Insert](
	[LNK_T2_ID] [int] NULL,
	[LNK_T3_ID] [int] NULL,
	[LNK_T4_ID] [int] NULL,
	[REG_0300_ID] [int] NULL,
	[REG_0400_ID] [int] NULL,
	[T4_Rank] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[Column_Latch_Insert]') AND name = N'idx_nc_CLI_K3_I2_I4_I5')
CREATE NONCLUSTERED INDEX [idx_nc_CLI_K3_I2_I4_I5] ON [TMP].[Column_Latch_Insert]
(
	[LNK_T4_ID] ASC
)
INCLUDE ( 	[LNK_T3_ID],
	[REG_0300_ID],
	[REG_0400_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[Column_Latch_Insert]') AND name = N'tdx_nc_CLI_K3_I2_I4_I5')
CREATE NONCLUSTERED INDEX [tdx_nc_CLI_K3_I2_I4_I5] ON [TMP].[Column_Latch_Insert]
(
	[LNK_T4_ID] ASC
)
INCLUDE ( 	[LNK_T3_ID],
	[REG_0300_ID],
	[REG_0400_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
