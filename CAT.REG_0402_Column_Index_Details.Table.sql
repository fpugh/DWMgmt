USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0402_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0402_Column_Index_Details] DROP CONSTRAINT [DF_REG_0402_CDate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0402_Included]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0402_Column_Index_Details] DROP CONSTRAINT [DF_REG_0402_Included]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0402_Descending]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0402_Column_Index_Details] DROP CONSTRAINT [DF_REG_0402_Descending]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0402_partitionid]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0402_Column_Index_Details] DROP CONSTRAINT [DF_REG_0402_partitionid]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0402_Columnid]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0402_Column_Index_Details] DROP CONSTRAINT [DF_REG_0402_Columnid]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0402_Column_Index_Details]') AND type in (N'U'))
DROP TABLE [CAT].[REG_0402_Column_Index_Details]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0402_Column_Index_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[REG_0402_Column_Index_Details](
	[REG_0402_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Index_Column_ID] [int] NOT NULL,
	[Partition_Ordinal] [int] NOT NULL,
	[Is_Descending_Key] [bit] NOT NULL,
	[Is_Included_Column] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_REG_0402] PRIMARY KEY CLUSTERED 
(
	[Index_Column_ID] ASC,
	[Partition_Ordinal] ASC,
	[Is_Descending_Key] ASC,
	[Is_Included_Column] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0402_ID] UNIQUE NONCLUSTERED 
(
	[REG_0402_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0402_Columnid]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0402_Column_Index_Details] ADD  CONSTRAINT [DF_REG_0402_Columnid]  DEFAULT ((0)) FOR [Index_Column_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0402_partitionid]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0402_Column_Index_Details] ADD  CONSTRAINT [DF_REG_0402_partitionid]  DEFAULT ((0)) FOR [Partition_Ordinal]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0402_Descending]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0402_Column_Index_Details] ADD  CONSTRAINT [DF_REG_0402_Descending]  DEFAULT ('false') FOR [Is_Descending_Key]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0402_Included]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0402_Column_Index_Details] ADD  CONSTRAINT [DF_REG_0402_Included]  DEFAULT ('false') FOR [Is_Included_Column]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0402_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0402_Column_Index_Details] ADD  CONSTRAINT [DF_REG_0402_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
END

GO
