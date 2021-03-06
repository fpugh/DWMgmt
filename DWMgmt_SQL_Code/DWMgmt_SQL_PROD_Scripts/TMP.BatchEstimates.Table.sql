USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [TMP].[BatchEstimates](
	[Batch_ID] [varchar](7) NULL,
	[Items] [int] NULL,
	[Total_File_Size] [bigint] NULL,
	[Avg_Unit_Size] [bigint] NULL,
	[StdDev_Unit_Size] [bigint] NULL,
	[Estimate_Batches] [bigint] NULL,
	[Target_Batch_Units] [bigint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
