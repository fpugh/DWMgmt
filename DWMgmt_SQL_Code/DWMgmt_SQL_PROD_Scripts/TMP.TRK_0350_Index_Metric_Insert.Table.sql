USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	[Index_Type] [nvarchar](65) NULL,
	[Index_Type_Desc] [nvarchar](65) NULL,
	[Scan_Mode] [nvarchar](65) NULL,
	[Partition_Number] [int] NULL,
	[Alloc_Unit_Type_Desc] [nvarchar](65) NULL,
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

GO
ALTER TABLE [TMP].[TRK_0350_Index_Metric_Insert] ADD  DEFAULT (getdate()) FOR [Post_Date]
GO
