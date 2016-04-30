USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_LogErrors_Post]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_SSIS_Import_Errors] DROP CONSTRAINT [DF_LogErrors_Post]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[TRK_SSIS_Import_Errors]') AND type in (N'U'))
DROP TABLE [CAT].[TRK_SSIS_Import_Errors]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[TRK_SSIS_Import_Errors]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[TRK_SSIS_Import_Errors](
	[Post_Date] [datetime] NOT NULL,
	[Execution_ID] [uniqueidentifier] NOT NULL,
	[Target_Server] [nvarchar](256) NULL,
	[Target_Database] [nvarchar](256) NULL,
	[Task_Name] [nvarchar](256) NULL,
	[Error_Code] [int] NULL,
	[Error_Description] [nvarchar](max) NULL,
	[Records] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_LogErrors_Post]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_SSIS_Import_Errors] ADD  CONSTRAINT [DF_LogErrors_Post]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
