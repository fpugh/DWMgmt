USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0200_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0200_Database_Registry] DROP CONSTRAINT [DF_REG_0200_CDate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0200_Recovery]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0200_Database_Registry] DROP CONSTRAINT [DF_REG_0200_Recovery]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0200_Collate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0200_Database_Registry] DROP CONSTRAINT [DF_REG_0200_Collate]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0200_Database_Registry]') AND type in (N'U'))
DROP TABLE [CAT].[REG_0200_Database_Registry]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0200_Database_Registry]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[REG_0200_Database_Registry](
	[REG_0200_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[REG_Database_Name] [nvarchar](256) NOT NULL,
	[REG_Compatibility] [tinyint] NOT NULL,
	[REG_Collation] [nvarchar](65) NOT NULL,
	[REG_Recovery_Model] [nvarchar](65) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_REG_0200] PRIMARY KEY CLUSTERED 
(
	[REG_Database_Name] ASC,
	[REG_Compatibility] ASC,
	[REG_Collation] ASC,
	[REG_Recovery_Model] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0200_KeyID] UNIQUE NONCLUSTERED 
(
	[REG_0200_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0200_Collate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0200_Database_Registry] ADD  CONSTRAINT [DF_REG_0200_Collate]  DEFAULT ('database default') FOR [REG_Collation]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0200_Recovery]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0200_Database_Registry] ADD  CONSTRAINT [DF_REG_0200_Recovery]  DEFAULT ('simple') FOR [REG_Recovery_Model]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0200_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0200_Database_Registry] ADD  CONSTRAINT [DF_REG_0200_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
END

GO
