USE [DWMgmt]
GO


CREATE TABLE [CAT].[WFT_Maintenance_Job_Queue](
	[Job_Title] [varchar](256) NOT NULL,
	[Job_Process_Mode] [int] NOT NULL,
	[Job_Priority] [int] NOT NULL,
	[Target_Server_Reference] [varchar](128) NOT NULL,
	[Target_Database_Name] [varchar](128) NOT NULL,
	[SQL_Execute_Statement] [nvarchar](4000) NULL
) ON [PRIMARY]
END

