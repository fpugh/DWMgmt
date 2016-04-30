USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0102_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] DROP CONSTRAINT [DF_REG_0102_CDate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0102_K6]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] DROP CONSTRAINT [DF_REG_0102_K6]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0102_K5]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] DROP CONSTRAINT [DF_REG_0102_K5]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0102_K4]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] DROP CONSTRAINT [DF_REG_0102_K4]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0102_K3]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] DROP CONSTRAINT [DF_REG_0102_K3]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0102_K2]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] DROP CONSTRAINT [DF_REG_0102_K2]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0102_Publication_Replication_Server_Settings]') AND type in (N'U'))
DROP TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0102_Publication_Replication_Server_Settings]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings](
	[REG_0102_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[REG_Lazy_Schema_Flag] [bit] NOT NULL,
	[REG_Publisher_Flag] [bit] NOT NULL,
	[REG_Subscriber_Flag] [bit] NOT NULL,
	[REG_Distributor_Flag] [bit] NOT NULL,
	[REG_NonSQL_Subcriber_Flag] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_REG_0102] PRIMARY KEY CLUSTERED 
(
	[REG_Lazy_Schema_Flag] ASC,
	[REG_Publisher_Flag] ASC,
	[REG_Subscriber_Flag] ASC,
	[REG_Distributor_Flag] ASC,
	[REG_NonSQL_Subcriber_Flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0102_ID] UNIQUE NONCLUSTERED 
(
	[REG_0102_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0102_K2]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] ADD  CONSTRAINT [DF_REG_0102_K2]  DEFAULT ((0)) FOR [REG_Lazy_Schema_Flag]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0102_K3]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] ADD  CONSTRAINT [DF_REG_0102_K3]  DEFAULT ((0)) FOR [REG_Publisher_Flag]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0102_K4]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] ADD  CONSTRAINT [DF_REG_0102_K4]  DEFAULT ((0)) FOR [REG_Subscriber_Flag]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0102_K5]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] ADD  CONSTRAINT [DF_REG_0102_K5]  DEFAULT ((0)) FOR [REG_Distributor_Flag]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0102_K6]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] ADD  CONSTRAINT [DF_REG_0102_K6]  DEFAULT ((0)) FOR [REG_NonSQL_Subcriber_Flag]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0102_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] ADD  CONSTRAINT [DF_REG_0102_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
END

GO
