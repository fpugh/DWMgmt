USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] DROP CONSTRAINT [DF_REG_0302_CDate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_updtref]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] DROP CONSTRAINT [DF_REG_0302_updtref]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_delref]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] DROP CONSTRAINT [DF_REG_0302_delref]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_sysnamed]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] DROP CONSTRAINT [DF_REG_0302_sysnamed]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_notreplicate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] DROP CONSTRAINT [DF_REG_0302_notreplicate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_nottrust]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] DROP CONSTRAINT [DF_REG_0302_nottrust]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] DROP CONSTRAINT [DF_REG_0302_Disabled]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_schmpub]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] DROP CONSTRAINT [DF_REG_0302_schmpub]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_Published]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] DROP CONSTRAINT [DF_REG_0302_Published]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_hypothetical]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] DROP CONSTRAINT [DF_REG_0302_hypothetical]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_msshipped]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] DROP CONSTRAINT [DF_REG_0302_msshipped]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0302_Foreign_Key_Details]') AND type in (N'U'))
DROP TABLE [CAT].[REG_0302_Foreign_Key_Details]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0302_Foreign_Key_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[REG_0302_Foreign_Key_Details](
	[REG_0302_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Is_ms_shipped] [bit] NOT NULL,
	[Is_hypothetical] [bit] NOT NULL,
	[Is_Published] [bit] NOT NULL,
	[Is_Schema_Published] [bit] NOT NULL,
	[Is_Disabled] [bit] NOT NULL,
	[Is_not_trusted] [bit] NOT NULL,
	[Is_not_for_replication] [bit] NOT NULL,
	[Is_System_Named] [bit] NOT NULL,
	[delete_referential_action] [tinyint] NOT NULL,
	[update_referential_action] [tinyint] NOT NULL,
	[Key_Index_ID] [int] NOT NULL,
	[principal_ID] [int] NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_REG_0302] PRIMARY KEY CLUSTERED 
(
	[Is_ms_shipped] ASC,
	[Is_hypothetical] ASC,
	[Is_Published] ASC,
	[Is_Schema_Published] ASC,
	[Is_Disabled] ASC,
	[Is_not_trusted] ASC,
	[Is_not_for_replication] ASC,
	[Is_System_Named] ASC,
	[delete_referential_action] ASC,
	[update_referential_action] ASC,
	[Key_Index_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0302_ID] UNIQUE NONCLUSTERED 
(
	[REG_0302_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_msshipped]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_msshipped]  DEFAULT ('false') FOR [Is_ms_shipped]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_hypothetical]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_hypothetical]  DEFAULT ('false') FOR [Is_hypothetical]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_Published]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_Published]  DEFAULT ('false') FOR [Is_Published]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_schmpub]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_schmpub]  DEFAULT ('false') FOR [Is_Schema_Published]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_Disabled]  DEFAULT ('false') FOR [Is_Disabled]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_nottrust]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_nottrust]  DEFAULT ('false') FOR [Is_not_trusted]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_notreplicate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_notreplicate]  DEFAULT ('true') FOR [Is_not_for_replication]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_sysnamed]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_sysnamed]  DEFAULT ('true') FOR [Is_System_Named]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_delref]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_delref]  DEFAULT ((0)) FOR [delete_referential_action]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_updtref]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_updtref]  DEFAULT ((0)) FOR [update_referential_action]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0302_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
END

GO
