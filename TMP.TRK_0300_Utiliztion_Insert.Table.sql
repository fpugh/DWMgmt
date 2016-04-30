USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_Utilization_T3_ID]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[TRK_0300_Utiliztion_Insert] DROP CONSTRAINT [DF_Utilization_T3_ID]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_Utilization_T2_ID]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[TRK_0300_Utiliztion_Insert] DROP CONSTRAINT [DF_Utilization_T2_ID]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0300_Utiliztion_Insert]') AND type in (N'U'))
DROP TABLE [TMP].[TRK_0300_Utiliztion_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0300_Utiliztion_Insert]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[TRK_0300_Utiliztion_Insert](
	[TRK_fk_T2_ID] [int] NULL,
	[TRK_fk_T3_ID] [int] NULL,
	[Server_ID] [int] NULL,
	[Database_ID] [int] NULL,
	[Object_ID] [int] NULL,
	[TRK_Last_Action_Type] [nvarchar](25) NULL,
	[TRK_Last_Action_Date] [datetime] NULL,
	[TRK_Action_Weight] [int] NULL,
	[Total_Seeks] [int] NULL,
	[Total_Scans] [int] NULL,
	[Total_Lookups] [int] NULL,
	[Total_Updates] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_Utilization_T2_ID]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[TRK_0300_Utiliztion_Insert] ADD  CONSTRAINT [DF_Utilization_T2_ID]  DEFAULT ((0)) FOR [TRK_fk_T2_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_Utilization_T3_ID]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[TRK_0300_Utiliztion_Insert] ADD  CONSTRAINT [DF_Utilization_T3_ID]  DEFAULT ((0)) FOR [TRK_fk_T3_ID]
END

GO
