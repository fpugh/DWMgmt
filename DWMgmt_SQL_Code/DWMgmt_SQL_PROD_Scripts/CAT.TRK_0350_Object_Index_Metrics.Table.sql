USE [DWMgmt]
GO

CREATE TABLE [CAT].[TRK_0350_Object_Index_Metrics](
	[TRK_ID] [int] IDENTITY(1,1) NOT NULL,
	[TRK_FK_T2_ID] [int] NOT NULL,
	[TRK_FK_T3_OBJ_ID] [int] NOT NULL,
	[TRK_FK_T3_IDX_ID] [int] NOT NULL,
	[TRK_Scan_Mode] [nvarchar](65) NOT NULL,
	[TRK_Index_Rank] [int] NOT NULL,
	[TRK_Partition_Number] [int] NOT NULL,
	[TRK_Index_Type_Desc] [nvarchar](65) NOT NULL,
	[TRK_Alloc_Unit_Type_Desc] [nvarchar](65) NOT NULL,
	[TRK_Index_Depth] [tinyint] NOT NULL,
	[TRK_Index_Level] [tinyint] NOT NULL,
	[TRK_Avg_Fragmentation_Percent] [float] NULL,
	[TRK_Fragment_Count] [bigint] NULL,
	[TRK_Avg_Fragment_Page_Size] [float] NULL,
	[TRK_Page_Count] [bigint] NOT NULL,
	[TRK_Avg_Page_Space_Percent_Used] [float] NULL,
	[TRK_Scanned_Record_Count] [bigint] NOT NULL,
	[TRK_Min_Record_Byte_Size] [int] NOT NULL,
	[TRK_Max_Record_Byte_Size] [int] NOT NULL,
	[TRK_Avg_Record_Byte_Size] [float] NULL,
	[TRK_Forwarded_Record_Count] [bigint] NULL,
	[TRK_Compressed_Page_Count] [bigint] NULL,
	[TRK_Post_Date] [datetime] NOT NULL,
 CONSTRAINT [UQ_TRK_0350_ID] UNIQUE NONCLUSTERED 
(
	[TRK_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics] ADD  DEFAULT ((0)) FOR [TRK_Page_Count]
GO

ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics] ADD  DEFAULT ((0)) FOR [TRK_Scanned_Record_Count]
GO

ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics] ADD  DEFAULT (getdate()) FOR [TRK_Post_Date]
GO

ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics]  WITH CHECK ADD  CONSTRAINT [FK_TRK_0350_LNK_0100_0200_Server_Databases] FOREIGN KEY([TRK_FK_T2_ID])
REFERENCES [CAT].[LNK_0100_0200_Server_Databases] ([LNK_T2_ID])
GO

ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics] CHECK CONSTRAINT [FK_TRK_0350_LNK_0100_0200_Server_Databases]
GO

ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics]  WITH CHECK ADD  CONSTRAINT [FK_TRK_0350_LNK_0204_0300_Schema_Binding_A] FOREIGN KEY([TRK_FK_T3_OBJ_ID])
REFERENCES [CAT].[LNK_0204_0300_Schema_Binding] ([LNK_T3_ID])
GO

ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics] CHECK CONSTRAINT [FK_TRK_0350_LNK_0204_0300_Schema_Binding_A]
GO

ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics]  WITH CHECK ADD  CONSTRAINT [FK_TRK_0350_LNK_0204_0300_Schema_Binding_B] FOREIGN KEY([TRK_FK_T3_IDX_ID])
REFERENCES [CAT].[LNK_0204_0300_Schema_Binding] ([LNK_T3_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [CAT].[TRK_0350_Object_Index_Metrics] CHECK CONSTRAINT [FK_TRK_0350_LNK_0204_0300_Schema_Binding_B]
GO

CREATE NONCLUSTERED INDEX IDX_NC_TRK_0350_K2_K3_K4_I_OIM ON [CAT].[TRK_0350_Object_Index_Metrics]
(
	[TRK_FK_T2_ID] ASC,
	[TRK_FK_T3_OBJ_ID] ASC,
	[TRK_FK_T3_IDX_ID] ASC
)
INCLUDE ( 	[TRK_ID],
	[TRK_Index_Rank],
	[TRK_Partition_Number],
	[TRK_Index_Type_Desc],
	[TRK_Alloc_Unit_Type_Desc],
	[TRK_Index_Depth],
	[TRK_Index_Level],
	[TRK_Avg_Fragmentation_Percent],
	[TRK_Fragment_Count],
	[TRK_Avg_Fragment_Page_Size],
	[TRK_Page_Count],
	[TRK_Avg_Page_Space_Percent_Used],
	[TRK_Scanned_Record_Count],
	[TRK_Min_Record_Byte_Size],
	[TRK_Max_Record_Byte_Size],
	[TRK_Avg_Record_Byte_Size],
	[TRK_Post_Date]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE TRIGGER [CAT].[TGR_TRK_0350_Index_Metric_Upsert]
    ON [CAT].[TRK_0350_Object_Index_Metrics]
    INSTEAD OF INSERT
 AS  
 BEGIN
  SET NOCOUNT ON;
 
  INSERT INTO CAT.TRK_0350_Object_Index_Metrics (TRK_FK_T2_ID, TRK_FK_T3_OBJ_ID, TRK_FK_T3_IDX_ID, TRK_Scan_Mode, TRK_Index_Rank, TRK_Partition_Number, TRK_Index_Type_Desc, TRK_Alloc_Unit_Type_Desc, TRK_Index_Depth, TRK_Index_Level, TRK_Avg_Fragmentation_Percent, TRK_Fragment_Count, TRK_Avg_Fragment_Page_Size, TRK_Page_Count, TRK_Avg_Page_Space_Percent_Used, TRK_Scanned_Record_Count, TRK_Min_Record_Byte_Size, TRK_Max_Record_Byte_Size, TRK_Avg_Record_Byte_Size, TRK_Forwarded_Record_Count, TRK_Compressed_Page_Count, trk.TRK_Post_Date)
  SELECT DISTINCT ist.TRK_FK_T2_ID, ist.TRK_FK_T3_OBJ_ID, ist.TRK_FK_T3_IDX_ID, ist.TRK_Scan_Mode, ist.TRK_Index_Rank, ist.TRK_Partition_Number, ist.TRK_Index_Type_Desc, ist.TRK_Alloc_Unit_Type_Desc, ist.TRK_Index_Depth, ist.TRK_Index_Level, ist.TRK_Avg_Fragmentation_Percent, ist.TRK_Fragment_Count, ist.TRK_Avg_Fragment_Page_Size, ist.TRK_Page_Count, ist.TRK_Avg_Page_Space_Percent_Used, ist.TRK_Scanned_Record_Count, ist.TRK_Min_Record_Byte_Size, ist.TRK_Max_Record_Byte_Size, ist.TRK_Avg_Record_Byte_Size, ist.TRK_Forwarded_Record_Count, ist.TRK_Compressed_Page_Count, getdate()
  FROM inserted AS ist
  EXCEPT
  SELECT DISTINCT trk.TRK_FK_T2_ID, trk.TRK_FK_T3_OBJ_ID, trk.TRK_FK_T3_IDX_ID, trk.TRK_Scan_Mode, trk.TRK_Index_Rank, trk.TRK_Partition_Number, trk.TRK_Index_Type_Desc, trk.TRK_Alloc_Unit_Type_Desc, trk.TRK_Index_Depth, trk.TRK_Index_Level, trk.TRK_Avg_Fragmentation_Percent, trk.TRK_Fragment_Count, trk.TRK_Avg_Fragment_Page_Size, trk.TRK_Page_Count, trk.TRK_Avg_Page_Space_Percent_Used, trk.TRK_Scanned_Record_Count, trk.TRK_Min_Record_Byte_Size, trk.TRK_Max_Record_Byte_Size, trk.TRK_Avg_Record_Byte_Size, trk.TRK_Forwarded_Record_Count, trk.TRK_Compressed_Page_Count, trk.TRK_Post_Date
  FROM CAT.TRK_0350_Object_Index_Metrics AS trk
 
 END


GO
