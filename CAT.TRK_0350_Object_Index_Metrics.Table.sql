USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_TRK_0350_Index_Metric_Upsert]'))
DROP TRIGGER [CAT].[TGR_TRK_0350_Index_Metric_Upsert]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_TRK_0350_LNK_0204_0300_Schema_Binding_B]') AND parent_object_id = OBJECT_ID(N'[CAT].[TRK_0350_Object_Index_Metrics]'))
ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics] DROP CONSTRAINT [FK_TRK_0350_LNK_0204_0300_Schema_Binding_B]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_TRK_0350_LNK_0204_0300_Schema_Binding_A]') AND parent_object_id = OBJECT_ID(N'[CAT].[TRK_0350_Object_Index_Metrics]'))
ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics] DROP CONSTRAINT [FK_TRK_0350_LNK_0204_0300_Schema_Binding_A]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF__TRK_0350___TRK_P__159B1292]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics] DROP CONSTRAINT [DF__TRK_0350___TRK_P__159B1292]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF__TRK_0350___TRK_S__14A6EE59]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics] DROP CONSTRAINT [DF__TRK_0350___TRK_S__14A6EE59]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF__TRK_0350___TRK_P__13B2CA20]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics] DROP CONSTRAINT [DF__TRK_0350___TRK_P__13B2CA20]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[TRK_0350_Object_Index_Metrics]') AND type in (N'U'))
DROP TABLE [CAT].[TRK_0350_Object_Index_Metrics]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[TRK_0350_Object_Index_Metrics]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[TRK_0350_Object_Index_Metrics](
	[TRK_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TRK_FK_T2_ID] [int] NOT NULL,
	[TRK_FK_T3_OBJ_ID] [int] NOT NULL,
	[TRK_FK_T3_IDX_ID] [int] NOT NULL,
	[TRK_Log_Mode] [nvarchar](25) NOT NULL,
	[TRK_Index_Rank] [int] NOT NULL,
	[TRK_Partition_Number] [int] NOT NULL,
	[TRK_Index_Type_Desc] [nvarchar](25) NOT NULL,
	[TRK_Alloc_Unit_Type_Desc] [nvarchar](25) NOT NULL,
	[TRK_Index_Depth] [tinyint] NOT NULL,
	[TRK_Index_Level] [tinyint] NOT NULL,
	[TRK_Avg_Fragmentation_Percent] [float] NULL,
	[TRK_Fragment_Count] [bigint] NULL,
	[TRK_Avg_Fragment_Page_Size] [float] NULL,
	[TRK_Page_Count] [bigint] NOT NULL,
	[TRK_Avg_Page_Space_Percent_Used] [float] NULL,
	[TRK_Actual_Record_Count] [bigint] NULL,
	[TRK_Scanned_Record_Count] [bigint] NOT NULL,
	[TRK_Min_Record_Byte_Size] [int] NOT NULL,
	[TRK_Max_Record_Byte_Size] [int] NOT NULL,
	[TRK_Avg_Record_Byte_Size] [float] NULL,
	[TRK_Forwarded_Record_Count] [bigint] NULL,
	[TRK_Compressed_Page_Count] [bigint] NULL,
	[TRK_Post_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_TRK_0350] PRIMARY KEY CLUSTERED 
(
	[TRK_FK_T2_ID] ASC,
	[TRK_FK_T3_OBJ_ID] ASC,
	[TRK_FK_T3_IDX_ID] ASC,
	[TRK_Index_Rank] ASC,
	[TRK_Partition_Number] ASC,
	[TRK_Alloc_Unit_Type_Desc] ASC,
	[TRK_Index_Depth] ASC,
	[TRK_Index_Level] ASC,
	[TRK_Page_Count] ASC,
	[TRK_Scanned_Record_Count] ASC,
	[TRK_Min_Record_Byte_Size] ASC,
	[TRK_Max_Record_Byte_Size] ASC,
	[TRK_Post_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_TRK_0350_ID] UNIQUE NONCLUSTERED 
(
	[TRK_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF__TRK_0350___TRK_P__13B2CA20]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics] ADD  DEFAULT ((0)) FOR [TRK_Page_Count]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF__TRK_0350___TRK_S__14A6EE59]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics] ADD  DEFAULT ((0)) FOR [TRK_Scanned_Record_Count]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF__TRK_0350___TRK_P__159B1292]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics] ADD  DEFAULT (getdate()) FOR [TRK_Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_TRK_0350_LNK_0204_0300_Schema_Binding_A]') AND parent_object_id = OBJECT_ID(N'[CAT].[TRK_0350_Object_Index_Metrics]'))
ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics]  WITH CHECK ADD  CONSTRAINT [FK_TRK_0350_LNK_0204_0300_Schema_Binding_A] FOREIGN KEY([TRK_FK_T3_OBJ_ID])
REFERENCES [CAT].[LNK_0204_0300_Schema_Binding] ([LNK_T3_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_TRK_0350_LNK_0204_0300_Schema_Binding_A]') AND parent_object_id = OBJECT_ID(N'[CAT].[TRK_0350_Object_Index_Metrics]'))
ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics] CHECK CONSTRAINT [FK_TRK_0350_LNK_0204_0300_Schema_Binding_A]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_TRK_0350_LNK_0204_0300_Schema_Binding_B]') AND parent_object_id = OBJECT_ID(N'[CAT].[TRK_0350_Object_Index_Metrics]'))
ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics]  WITH CHECK ADD  CONSTRAINT [FK_TRK_0350_LNK_0204_0300_Schema_Binding_B] FOREIGN KEY([TRK_FK_T3_IDX_ID])
REFERENCES [CAT].[LNK_0204_0300_Schema_Binding] ([LNK_T3_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_TRK_0350_LNK_0204_0300_Schema_Binding_B]') AND parent_object_id = OBJECT_ID(N'[CAT].[TRK_0350_Object_Index_Metrics]'))
ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics] CHECK CONSTRAINT [FK_TRK_0350_LNK_0204_0300_Schema_Binding_B]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_TRK_0350_Index_Metric_Upsert]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [CAT].[TGR_TRK_0350_Index_Metric_Upsert]
    ON [CAT].[TRK_0350_Object_Index_Metrics]
    INSTEAD OF INSERT
 AS  
 BEGIN
  SET NOCOUNT ON;
 
  INSERT INTO CAT.TRK_0350_Object_Index_Metrics (TRK_FK_T2_ID, TRK_FK_T3_OBJ_ID, TRK_FK_T3_IDX_ID, TRK_Log_Mode, TRK_Index_Rank, TRK_Partition_Number, TRK_Index_Type_Desc, TRK_Alloc_Unit_Type_Desc, TRK_Index_Depth, TRK_Index_Level, TRK_Avg_Fragmentation_Percent, TRK_Fragment_Count, TRK_Avg_Fragment_Page_Size, TRK_Page_Count, TRK_Avg_Page_Space_Percent_Used, TRK_Scanned_Record_Count, TRK_Min_Record_Byte_Size, TRK_Max_Record_Byte_Size, TRK_Avg_Record_Byte_Size, TRK_Forwarded_Record_Count, TRK_Compressed_Page_Count, trk.TRK_Post_Date)
  SELECT DISTINCT ist.TRK_FK_T2_ID, ist.TRK_FK_T3_OBJ_ID, ist.TRK_FK_T3_IDX_ID, ist.TRK_Log_Mode, ist.TRK_Index_Rank, ist.TRK_Partition_Number, ist.TRK_Index_Type_Desc, ist.TRK_Alloc_Unit_Type_Desc, ist.TRK_Index_Depth, ist.TRK_Index_Level, ist.TRK_Avg_Fragmentation_Percent, ist.TRK_Fragment_Count, ist.TRK_Avg_Fragment_Page_Size, ist.TRK_Page_Count, ist.TRK_Avg_Page_Space_Percent_Used, ist.TRK_Scanned_Record_Count, ist.TRK_Min_Record_Byte_Size, ist.TRK_Max_Record_Byte_Size, ist.TRK_Avg_Record_Byte_Size, ist.TRK_Forwarded_Record_Count, ist.TRK_Compressed_Page_Count, getdate()
  FROM inserted AS ist
  EXCEPT
  SELECT DISTINCT trk.TRK_FK_T2_ID, trk.TRK_FK_T3_OBJ_ID, trk.TRK_FK_T3_IDX_ID, trk.TRK_Log_Mode, trk.TRK_Index_Rank, trk.TRK_Partition_Number, trk.TRK_Index_Type_Desc, trk.TRK_Alloc_Unit_Type_Desc, trk.TRK_Index_Depth, trk.TRK_Index_Level, trk.TRK_Avg_Fragmentation_Percent, trk.TRK_Fragment_Count, trk.TRK_Avg_Fragment_Page_Size, trk.TRK_Page_Count, trk.TRK_Avg_Page_Space_Percent_Used, trk.TRK_Scanned_Record_Count, trk.TRK_Min_Record_Byte_Size, trk.TRK_Max_Record_Byte_Size, trk.TRK_Avg_Record_Byte_Size, trk.TRK_Forwarded_Record_Count, trk.TRK_Compressed_Page_Count, trk.TRK_Post_Date
  FROM CAT.TRK_0350_Object_Index_Metrics AS trk
 
 END
' 
GO
