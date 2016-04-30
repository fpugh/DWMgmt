USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__TRK_0350___Post___7CA47C3F]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[TRK_0350_Index_Metric_Insert] DROP CONSTRAINT [DF__TRK_0350___Post___7CA47C3F]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0350_Index_Metric_Insert]') AND type in (N'U'))
DROP TABLE [TMP].[TRK_0350_Index_Metric_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0350_Index_Metric_Insert]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[TRK_0350_Index_Metric_Insert](
	[Server_ID] [tinyint] NULL,
	[database_ID] [int] NULL,
	[Schema_ID] [int] NULL,
	[Object_ID] [int] NULL,
	[Index_Rank] [int] NULL,
	[Server_Name] [nvarchar](256) NULL,
	[Database_Name] [nvarchar](256) NULL,
	[Schema_Name] [nvarchar](256) NULL,
	[Object_Name] [nvarchar](256) NULL,
	[Index_Name] [nvarchar](256) NULL,
	[index_type] [nvarchar](25) NULL,
	[Index_Type_Desc] [nvarchar](25) NULL,
	[Log_Mode] [nvarchar](25) NULL,
	[Partition_Number] [int] NULL,
	[Alloc_Unit_Type_Desc] [nvarchar](25) NULL,
	[Index_Depth] [tinyint] NULL,
	[Index_Level] [tinyint] NULL,
	[Avg_Fragmentation_Percent] [float] NULL,
	[Fragment_Count] [int] NULL,
	[Avg_Fragment_Page_Size] [float] NULL,
	[Page_Count] [int] NULL,
	[Avg_Page_Space_Percent_Used] [float] NULL,
	[Scanned_Record_Count] [int] NULL,
	[Min_Record_Byte_Size] [int] NULL,
	[Max_Record_Byte_Size] [int] NULL,
	[Avg_Record_Byte_Size] [float] NULL,
	[Forwarded_Record_Count] [int] NULL,
	[Compressed_Page_Count] [int] NULL,
	[Post_Date] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF__TRK_0350___Post___7CA47C3F]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[TRK_0350_Index_Metric_Insert] ADD  DEFAULT (getdate()) FOR [Post_Date]
END

GO
