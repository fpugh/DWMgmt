USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0205_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0205_Database_Maintenance_Properties] DROP CONSTRAINT [DF_REG_0205_CDate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0205_Type]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0205_Database_Maintenance_Properties] DROP CONSTRAINT [DF_REG_0205_Type]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0205_Database_Maintenance_Properties]') AND type in (N'U'))
DROP TABLE [CAT].[REG_0205_Database_Maintenance_Properties]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0205_Database_Maintenance_Properties]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[REG_0205_Database_Maintenance_Properties](
	[REG_0205_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[REG_Task_Type] [nvarchar](256) NOT NULL,
	[REG_Task_Name] [nvarchar](256) NOT NULL,
	[REG_Task_Proc] [nvarchar](256) NOT NULL,
	[REG_Task_Desc] [nvarchar](256) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_REG_0205] PRIMARY KEY CLUSTERED 
(
	[REG_Task_Type] ASC,
	[REG_Task_Name] ASC,
	[REG_Task_Proc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0205_ID] UNIQUE NONCLUSTERED 
(
	[REG_0205_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0205_Type]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0205_Database_Maintenance_Properties] ADD  CONSTRAINT [DF_REG_0205_Type]  DEFAULT ('Maintenance') FOR [REG_Task_Type]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0205_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0205_Database_Maintenance_Properties] ADD  CONSTRAINT [DF_REG_0205_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
END

GO
