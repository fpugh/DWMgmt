USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CAT].[TRK_SSIS_Import_Audit](
	[Execution_ID] [nvarchar](65) NULL,
	[Target_Server] [nvarchar](256) NULL,
	[Target_Database] [nvarchar](256) NULL,
	[Task_Name] [nvarchar](256) NULL,
	[Records] [int] NULL,
	[Post_Date] [datetime] NOT NULL
) ON [PRIMARY]

GO
ALTER TABLE [CAT].[TRK_SSIS_Import_Audit] ADD  DEFAULT (getdate()) FOR [Post_Date]
GO
