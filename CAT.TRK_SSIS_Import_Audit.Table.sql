USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF__TRK_SSIS___Post___5C629536]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_SSIS_Import_Audit] DROP CONSTRAINT [DF__TRK_SSIS___Post___5C629536]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[TRK_SSIS_Import_Audit]') AND type in (N'U'))
DROP TABLE [CAT].[TRK_SSIS_Import_Audit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[TRK_SSIS_Import_Audit]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[TRK_SSIS_Import_Audit](
	[Execution_ID] [nvarchar](65) NULL,
	[Target_Server] [nvarchar](256) NULL,
	[Target_Database] [nvarchar](256) NULL,
	[Task_Name] [nvarchar](256) NULL,
	[Records] [int] NULL,
	[Post_Date] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF__TRK_SSIS___Post___5C629536]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_SSIS_Import_Audit] ADD  DEFAULT (getdate()) FOR [Post_Date]
END

GO
