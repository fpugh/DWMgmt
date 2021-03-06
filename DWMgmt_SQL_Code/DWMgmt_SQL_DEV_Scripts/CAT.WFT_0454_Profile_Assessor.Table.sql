USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CK_FQN_Format_Valid]') AND parent_object_id = OBJECT_ID(N'[CAT].[WFT_0454_Profile_Assessor]'))
ALTER TABLE [CAT].[WFT_0454_Profile_Assessor] DROP CONSTRAINT [CK_FQN_Format_Valid]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF__WFT_0454___POST___7775B2CE]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[WFT_0454_Profile_Assessor] DROP CONSTRAINT [DF__WFT_0454___POST___7775B2CE]
END

GO
/****** Object:  Table [CAT].[WFT_0454_Profile_Assessor]    Script Date: 3/1/2017 1:29:55 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[WFT_0454_Profile_Assessor]') AND type in (N'U'))
DROP TABLE [CAT].[WFT_0454_Profile_Assessor]
GO
/****** Object:  Table [CAT].[WFT_0454_Profile_Assessor]    Script Date: 3/1/2017 1:29:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[WFT_0454_Profile_Assessor]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[WFT_0454_Profile_Assessor](
	[SERVER_NAME] [nvarchar](256) NOT NULL,
	[FULLY_QUALIFIED_NAME] [nvarchar](512) NOT NULL,
	[SCAN_MODE] [nvarchar](65) NOT NULL,
	[FCST_DURATION] [time](7) NULL,
	[POST_DATE] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF__WFT_0454___POST___7775B2CE]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[WFT_0454_Profile_Assessor] ADD  DEFAULT (getdate()) FOR [POST_DATE]
END

GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CK_FQN_Format_Valid]') AND parent_object_id = OBJECT_ID(N'[CAT].[WFT_0454_Profile_Assessor]'))
ALTER TABLE [CAT].[WFT_0454_Profile_Assessor]  WITH CHECK ADD  CONSTRAINT [CK_FQN_Format_Valid] CHECK  ((patindex('%.%.%',[FULLY_QUALIFIED_NAME])>(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CK_FQN_Format_Valid]') AND parent_object_id = OBJECT_ID(N'[CAT].[WFT_0454_Profile_Assessor]'))
ALTER TABLE [CAT].[WFT_0454_Profile_Assessor] CHECK CONSTRAINT [CK_FQN_Format_Valid]
GO
