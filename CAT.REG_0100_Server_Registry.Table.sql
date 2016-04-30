USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0100_Monitored]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0100_Server_Registry] DROP CONSTRAINT [DF_REG_0100_Monitored]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0100_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0100_Server_Registry] DROP CONSTRAINT [DF_REG_0100_CDate]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0100_Server_Registry]') AND type in (N'U'))
DROP TABLE [CAT].[REG_0100_Server_Registry]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0100_Server_Registry]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[REG_0100_Server_Registry](
	[REG_0100_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[REG_Server_Name] [nvarchar](256) NOT NULL,
	[REG_Product] [nvarchar](256) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
	[REG_Monitored] [bit] NOT NULL,
 CONSTRAINT [PK_REG_0100] PRIMARY KEY CLUSTERED 
(
	[REG_Server_Name] ASC,
	[REG_Product] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0100_ID] UNIQUE NONCLUSTERED 
(
	[REG_0100_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0100_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0100_Server_Registry] ADD  CONSTRAINT [DF_REG_0100_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0100_Monitored]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0100_Server_Registry] ADD  CONSTRAINT [DF_REG_0100_Monitored]  DEFAULT ((0)) FOR [REG_Monitored]
END

GO
