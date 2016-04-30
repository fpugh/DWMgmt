USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_TRK_0400_LNK_0300_0400_Object_Column_Collection]') AND parent_object_id = OBJECT_ID(N'[CAT].[TRK_0400_Column_Metrics]'))
ALTER TABLE [CAT].[TRK_0400_Column_Metrics] DROP CONSTRAINT [FK_TRK_0400_LNK_0300_0400_Object_Column_Collection]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_TRK_0400_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0400_Column_Metrics] DROP CONSTRAINT [DF_TRK_0400_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_TRK_0400_Uniqueness]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0400_Column_Metrics] DROP CONSTRAINT [DF_TRK_0400_Uniqueness]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_TRK_0400_Density]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0400_Column_Metrics] DROP CONSTRAINT [DF_TRK_0400_Density]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_TRK_0400_Column_Nulls]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0400_Column_Metrics] DROP CONSTRAINT [DF_TRK_0400_Column_Nulls]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_TRK_0400_Total_Values]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0400_Column_Metrics] DROP CONSTRAINT [DF_TRK_0400_Total_Values]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[TRK_0400_Column_Metrics]') AND type in (N'U'))
DROP TABLE [CAT].[TRK_0400_Column_Metrics]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[TRK_0400_Column_Metrics]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[TRK_0400_Column_Metrics](
	[TRK_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TRK_FK_T4_ID] [int] NOT NULL,
	[TRK_Total_Values] [bigint] NOT NULL,
	[TRK_Column_Nulls] [bigint] NOT NULL,
	[TRK_Density] [decimal](7, 6) NOT NULL,
	[TRK_Uniqueness] [decimal](7, 6) NOT NULL,
	[TRK_Distinct_Values] [int] NULL,
	[TRK_Post_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_TRK_0400] PRIMARY KEY CLUSTERED 
(
	[TRK_FK_T4_ID] ASC,
	[TRK_Post_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UQ_TRK_0400_ID] UNIQUE NONCLUSTERED 
(
	[TRK_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_TRK_0400_Total_Values]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0400_Column_Metrics] ADD  CONSTRAINT [DF_TRK_0400_Total_Values]  DEFAULT ((0)) FOR [TRK_Total_Values]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_TRK_0400_Column_Nulls]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0400_Column_Metrics] ADD  CONSTRAINT [DF_TRK_0400_Column_Nulls]  DEFAULT ((0)) FOR [TRK_Column_Nulls]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_TRK_0400_Density]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0400_Column_Metrics] ADD  CONSTRAINT [DF_TRK_0400_Density]  DEFAULT ((0)) FOR [TRK_Density]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_TRK_0400_Uniqueness]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0400_Column_Metrics] ADD  CONSTRAINT [DF_TRK_0400_Uniqueness]  DEFAULT ((0)) FOR [TRK_Uniqueness]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_TRK_0400_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0400_Column_Metrics] ADD  CONSTRAINT [DF_TRK_0400_Post_Date]  DEFAULT (getdate()) FOR [TRK_Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_TRK_0400_LNK_0300_0400_Object_Column_Collection]') AND parent_object_id = OBJECT_ID(N'[CAT].[TRK_0400_Column_Metrics]'))
ALTER TABLE [CAT].[TRK_0400_Column_Metrics]  WITH CHECK ADD  CONSTRAINT [FK_TRK_0400_LNK_0300_0400_Object_Column_Collection] FOREIGN KEY([TRK_FK_T4_ID])
REFERENCES [CAT].[LNK_0300_0400_Object_Column_Collection] ([LNK_T4_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_TRK_0400_LNK_0300_0400_Object_Column_Collection]') AND parent_object_id = OBJECT_ID(N'[CAT].[TRK_0400_Column_Metrics]'))
ALTER TABLE [CAT].[TRK_0400_Column_Metrics] CHECK CONSTRAINT [FK_TRK_0400_LNK_0300_0400_Object_Column_Collection]
GO
