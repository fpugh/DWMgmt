USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0401_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0401_Column_Properties] DROP CONSTRAINT [DF_REG_0401_CDate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0401_dfltcollate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0401_Column_Properties] DROP CONSTRAINT [DF_REG_0401_dfltcollate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0401_Nullable]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0401_Column_Properties] DROP CONSTRAINT [DF_REG_0401_Nullable]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0401_Identity]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0401_Column_Properties] DROP CONSTRAINT [DF_REG_0401_Identity]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0401_Scale]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0401_Column_Properties] DROP CONSTRAINT [DF_REG_0401_Scale]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0401_Size]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0401_Column_Properties] DROP CONSTRAINT [DF_REG_0401_Size]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0401_Column_Properties]') AND type in (N'U'))
DROP TABLE [CAT].[REG_0401_Column_Properties]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0401_Column_Properties]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[REG_0401_Column_Properties](
	[REG_0401_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[REG_Size] [int] NOT NULL,
	[REG_Scale] [int] NOT NULL,
	[Is_Identity] [bit] NOT NULL,
	[Is_Nullable] [bit] NOT NULL,
	[Is_Default_Collation] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_REG_0401] PRIMARY KEY CLUSTERED 
(
	[REG_Size] ASC,
	[REG_Scale] ASC,
	[Is_Identity] ASC,
	[Is_Nullable] ASC,
	[Is_Default_Collation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0401_ID] UNIQUE NONCLUSTERED 
(
	[REG_0401_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0401_Size]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0401_Column_Properties] ADD  CONSTRAINT [DF_REG_0401_Size]  DEFAULT ((0)) FOR [REG_Size]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0401_Scale]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0401_Column_Properties] ADD  CONSTRAINT [DF_REG_0401_Scale]  DEFAULT ((-1)) FOR [REG_Scale]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0401_Identity]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0401_Column_Properties] ADD  CONSTRAINT [DF_REG_0401_Identity]  DEFAULT ((0)) FOR [Is_Identity]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0401_Nullable]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0401_Column_Properties] ADD  CONSTRAINT [DF_REG_0401_Nullable]  DEFAULT ((0)) FOR [Is_Nullable]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0401_dfltcollate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0401_Column_Properties] ADD  CONSTRAINT [DF_REG_0401_dfltcollate]  DEFAULT ((0)) FOR [Is_Default_Collation]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0401_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0401_Column_Properties] ADD  CONSTRAINT [DF_REG_0401_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
END

GO
