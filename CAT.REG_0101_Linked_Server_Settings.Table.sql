USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] DROP CONSTRAINT [DF_REG_0101_CDate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K12]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] DROP CONSTRAINT [DF_REG_0101_K12]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K11]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] DROP CONSTRAINT [DF_REG_0101_K11]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K10]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] DROP CONSTRAINT [DF_REG_0101_K10]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K9]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] DROP CONSTRAINT [DF_REG_0101_K9]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K8]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] DROP CONSTRAINT [DF_REG_0101_K8]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K7]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] DROP CONSTRAINT [DF_REG_0101_K7]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K6]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] DROP CONSTRAINT [DF_REG_0101_K6]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K5]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] DROP CONSTRAINT [DF_REG_0101_K5]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K4]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] DROP CONSTRAINT [DF_REG_0101_K4]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K3]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] DROP CONSTRAINT [DF_REG_0101_K3]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K2]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] DROP CONSTRAINT [DF_REG_0101_K2]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0101_Linked_Server_Settings]') AND type in (N'U'))
DROP TABLE [CAT].[REG_0101_Linked_Server_Settings]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0101_Linked_Server_Settings]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[REG_0101_Linked_Server_Settings](
	[REG_0101_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[REG_Linked_Flag] [bit] NOT NULL,
	[REG_Remote_Login_Flag] [bit] NOT NULL,
	[REG_RPC_Out_Flag] [bit] NOT NULL,
	[REG_Data_Access_Flag] [bit] NOT NULL,
	[REG_Collation_Compatible] [bit] NOT NULL,
	[REG_Remote_Collation_Flag] [bit] NOT NULL,
	[REG_Collation_Name] [nvarchar](65) NOT NULL,
	[REG_Connection_TO] [int] NOT NULL,
	[REG_Query_TO] [int] NOT NULL,
	[REG_System_Flag] [bit] NOT NULL,
	[REG_RPT_TPE_Flag] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_REG_0101] PRIMARY KEY CLUSTERED 
(
	[REG_Linked_Flag] ASC,
	[REG_Remote_Login_Flag] ASC,
	[REG_RPC_Out_Flag] ASC,
	[REG_Data_Access_Flag] ASC,
	[REG_Collation_Compatible] ASC,
	[REG_Remote_Collation_Flag] ASC,
	[REG_Collation_Name] ASC,
	[REG_Connection_TO] ASC,
	[REG_Query_TO] ASC,
	[REG_System_Flag] ASC,
	[REG_RPT_TPE_Flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0101_ID] UNIQUE NONCLUSTERED 
(
	[REG_0101_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K2]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] ADD  CONSTRAINT [DF_REG_0101_K2]  DEFAULT ((0)) FOR [REG_Linked_Flag]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K3]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] ADD  CONSTRAINT [DF_REG_0101_K3]  DEFAULT ((0)) FOR [REG_Remote_Login_Flag]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K4]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] ADD  CONSTRAINT [DF_REG_0101_K4]  DEFAULT ((0)) FOR [REG_RPC_Out_Flag]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K5]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] ADD  CONSTRAINT [DF_REG_0101_K5]  DEFAULT ((0)) FOR [REG_Data_Access_Flag]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K6]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] ADD  CONSTRAINT [DF_REG_0101_K6]  DEFAULT ((0)) FOR [REG_Collation_Compatible]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K7]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] ADD  CONSTRAINT [DF_REG_0101_K7]  DEFAULT ((0)) FOR [REG_Remote_Collation_Flag]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K8]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] ADD  CONSTRAINT [DF_REG_0101_K8]  DEFAULT ('Database_Default') FOR [REG_Collation_Name]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K9]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] ADD  CONSTRAINT [DF_REG_0101_K9]  DEFAULT ((0)) FOR [REG_Connection_TO]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K10]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] ADD  CONSTRAINT [DF_REG_0101_K10]  DEFAULT ((0)) FOR [REG_Query_TO]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K11]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] ADD  CONSTRAINT [DF_REG_0101_K11]  DEFAULT ((0)) FOR [REG_System_Flag]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_K12]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] ADD  CONSTRAINT [DF_REG_0101_K12]  DEFAULT ((0)) FOR [REG_RPT_TPE_Flag]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0101_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0101_Linked_Server_Settings] ADD  CONSTRAINT [DF_REG_0101_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
END

GO
