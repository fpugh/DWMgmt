USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DFgd_0501_cdate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] DROP CONSTRAINT [DFgd_0501_cdate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF0_0501_read]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] DROP CONSTRAINT [DF0_0501_read]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF0_0501_xmld]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] DROP CONSTRAINT [DF0_0501_xmld]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF0_0501_dfvl]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] DROP CONSTRAINT [DF0_0501_dfvl]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF0_0501_csrf]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] DROP CONSTRAINT [DF0_0501_csrf]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF0_0501_otpt]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] DROP CONSTRAINT [DF0_0501_otpt]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF0_0501_glbl]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] DROP CONSTRAINT [DF0_0501_glbl]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DFm1_0501_Scale]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] DROP CONSTRAINT [DFm1_0501_Scale]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF0_0501_Size]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] DROP CONSTRAINT [DF0_0501_Size]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0501_Parameter_Properties]') AND type in (N'U'))
DROP TABLE [CAT].[REG_0501_Parameter_Properties]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0501_Parameter_Properties]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[REG_0501_Parameter_Properties](
	[REG_0501_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[REG_Size] [int] NOT NULL,
	[REG_Scale] [int] NOT NULL,
	[Is_Input] [bit] NOT NULL,
	[Is_Output] [bit] NOT NULL,
	[Is_cursor_ref] [bit] NOT NULL,
	[has_Default_Value] [bit] NOT NULL,
	[Is_XML_document] [bit] NOT NULL,
	[Is_readonly] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_REG_0501] PRIMARY KEY CLUSTERED 
(
	[REG_Size] ASC,
	[REG_Scale] ASC,
	[Is_Input] ASC,
	[Is_Output] ASC,
	[Is_cursor_ref] ASC,
	[has_Default_Value] ASC,
	[Is_XML_document] ASC,
	[Is_readonly] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0501_ID] UNIQUE NONCLUSTERED 
(
	[REG_0501_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF0_0501_Size]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DF0_0501_Size]  DEFAULT ((0)) FOR [REG_Size]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DFm1_0501_Scale]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DFm1_0501_Scale]  DEFAULT ((-1)) FOR [REG_Scale]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF0_0501_glbl]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DF0_0501_glbl]  DEFAULT ((0)) FOR [Is_Input]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF0_0501_otpt]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DF0_0501_otpt]  DEFAULT ((0)) FOR [Is_Output]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF0_0501_csrf]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DF0_0501_csrf]  DEFAULT ((0)) FOR [Is_cursor_ref]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF0_0501_dfvl]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DF0_0501_dfvl]  DEFAULT ((0)) FOR [has_Default_Value]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF0_0501_xmld]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DF0_0501_xmld]  DEFAULT ((0)) FOR [Is_XML_document]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF0_0501_read]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DF0_0501_read]  DEFAULT ((0)) FOR [Is_readonly]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DFgd_0501_cdate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DFgd_0501_cdate]  DEFAULT (getdate()) FOR [REG_Create_Date]
END

GO
