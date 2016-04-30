USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_LDM_Term]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0200_0205_Database_Maintenance_Links] DROP CONSTRAINT [DF_LDM_Term]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_LDM_Post]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0200_0205_Database_Maintenance_Links] DROP CONSTRAINT [DF_LDM_Post]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0200_0205_Database_Maintenance_Links]') AND type in (N'U'))
DROP TABLE [CAT].[LNK_0200_0205_Database_Maintenance_Links]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0200_0205_Database_Maintenance_Links]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[LNK_0200_0205_Database_Maintenance_Links](
	[LNK_TBL_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LNK_FK_T2_ID] [int] NOT NULL,
	[LNK_FK_0205_ID] [int] NOT NULL,
	[LNK_Post_Date] [datetime] NOT NULL,
	[LNK_Term_Date] [datetime] NOT NULL,
 CONSTRAINT [pk_LNK_0200_0205] PRIMARY KEY CLUSTERED 
(
	[LNK_FK_0205_ID] ASC,
	[LNK_FK_T2_ID] ASC,
	[LNK_Term_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_LDM_Post]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0200_0205_Database_Maintenance_Links] ADD  CONSTRAINT [DF_LDM_Post]  DEFAULT (getdate()) FOR [LNK_Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_LDM_Term]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0200_0205_Database_Maintenance_Links] ADD  CONSTRAINT [DF_LDM_Term]  DEFAULT ('12/31/2099') FOR [LNK_Term_Date]
END

GO
