USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0601_Performance_Tracking]') AND type in (N'U'))
DROP TABLE [TMP].[TRK_0601_Performance_Tracking]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0601_Performance_Tracking]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[TRK_0601_Performance_Tracking](
	[REG_0601_ID] [int] NOT NULL,
	[server_id] [int] NOT NULL,
	[database_id] [int] NOT NULL,
	[object_id] [int] NOT NULL,
	[type] [char](2) NOT NULL,
	[sql_handle] [varbinary](64) NOT NULL,
	[plan_handle] [varbinary](64) NOT NULL,
	[post_date] [datetime] NULL,
	[current_execution_count] [bigint] NOT NULL,
	[last_execution_time] [datetime] NULL,
	[last_worker_time] [bigint] NOT NULL,
	[last_physical_reads] [bigint] NOT NULL,
	[last_logical_writes] [bigint] NOT NULL,
	[last_logical_reads] [bigint] NOT NULL,
	[last_elapsed_time] [bigint] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
