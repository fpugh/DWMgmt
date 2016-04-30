USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_TRK_0352_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[TRK_0452_Column_Stat_Scans] DROP CONSTRAINT [DF_TRK_0352_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0452_Column_Stat_Scans]') AND type in (N'U'))
DROP TABLE [TMP].[TRK_0452_Column_Stat_Scans]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0452_Column_Stat_Scans]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[TRK_0452_Column_Stat_Scans](
	[LNK_T4_ID] [int] NULL,
	[Post_Date] [datetime] NOT NULL,
	[Range_Hi_Key] [nvarchar](4000) NULL,
	[Range_Rows] [bigint] NULL,
	[EQ_Rows] [bigint] NULL,
	[Dist_Range_Rows] [bigint] NULL,
	[Avg_Range_Rows] [bigint] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_TRK_0352_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[TRK_0452_Column_Stat_Scans] ADD  CONSTRAINT [DF_TRK_0352_Post_Date]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
