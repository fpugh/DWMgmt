USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CAT].[TRK_SSIS_Import_Error_Summary](
	[Error_Code] [int] NULL,
	[Target_Server] [nvarchar](256) NULL,
	[Target_Database] [nvarchar](256) NULL,
	[Min_Error_Post_Date] [datetime] NULL,
	[Max_Error_Post_Date] [datetime] NULL,
	[Error_Instances] [int] NULL,
	[Error_Records] [int] NULL,
	[Post_Date] [datetime] NOT NULL
) ON [PRIMARY]

GO
