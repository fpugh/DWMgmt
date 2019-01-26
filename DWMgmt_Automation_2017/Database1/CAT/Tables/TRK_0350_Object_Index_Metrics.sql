CREATE TABLE [CAT].[TRK_0350_Object_Index_Metrics] (
    [TRK_ID]                          INT           IDENTITY (1, 1) NOT NULL,
    [TRK_FK_T2_ID]                    INT           NOT NULL,
    [TRK_FK_T3_OBJ_ID]                INT           NOT NULL,
    [TRK_FK_T3_IDX_ID]                INT           NOT NULL,
    [TRK_Scan_Mode]                   NVARCHAR (65) NOT NULL,
    [TRK_Index_Rank]                  INT           NOT NULL,
    [TRK_Partition_Number]            INT           NOT NULL,
    [TRK_Index_Type_Desc]             NVARCHAR (65) NOT NULL,
    [TRK_Alloc_Unit_Type_Desc]        NVARCHAR (65) NOT NULL,
    [TRK_Index_Depth]                 TINYINT       NOT NULL,
    [TRK_Index_Level]                 TINYINT       NOT NULL,
    [TRK_Avg_Fragmentation_Percent]   FLOAT (53)    NULL,
    [TRK_Fragment_Count]              BIGINT        NULL,
    [TRK_Avg_Fragment_Page_Size]      FLOAT (53)    NULL,
    [TRK_Page_Count]                  BIGINT        DEFAULT ((0)) NOT NULL,
    [TRK_Avg_Page_Space_Percent_Used] FLOAT (53)    NULL,
    [TRK_Scanned_Record_Count]        BIGINT        DEFAULT ((0)) NOT NULL,
    [TRK_Min_Record_Byte_Size]        INT           NOT NULL,
    [TRK_Max_Record_Byte_Size]        INT           NOT NULL,
    [TRK_Avg_Record_Byte_Size]        FLOAT (53)    NULL,
    [TRK_Forwarded_Record_Count]      BIGINT        NULL,
    [TRK_Compressed_Page_Count]       BIGINT        NULL,
    [TRK_Post_Date]                   DATETIME      DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [FK_TRK_0350_LNK_0100_0200_Server_Databases] FOREIGN KEY ([TRK_FK_T2_ID]) REFERENCES [CAT].[LNK_0100_0200_Server_Databases] ([LNK_T2_ID]),
    CONSTRAINT [FK_TRK_0350_LNK_0204_0300_Schema_Binding_A] FOREIGN KEY ([TRK_FK_T3_OBJ_ID]) REFERENCES [CAT].[LNK_0204_0300_Schema_Binding] ([LNK_T3_ID]),
    CONSTRAINT [FK_TRK_0350_LNK_0204_0300_Schema_Binding_B] FOREIGN KEY ([TRK_FK_T3_IDX_ID]) REFERENCES [CAT].[LNK_0204_0300_Schema_Binding] ([LNK_T3_ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [UQ_TRK_0350_ID] UNIQUE NONCLUSTERED ([TRK_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_TRK_0350_K17_I2_I3_I4_I23]
    ON [CAT].[TRK_0350_Object_Index_Metrics]([TRK_Scanned_Record_Count] ASC)
    INCLUDE([TRK_FK_T2_ID], [TRK_FK_T3_OBJ_ID], [TRK_FK_T3_IDX_ID], [TRK_Post_Date]);


GO
CREATE NONCLUSTERED INDEX [IDX_NC_TRK_0350_K2_K3_K4_I_OIM]
    ON [CAT].[TRK_0350_Object_Index_Metrics]([TRK_FK_T2_ID] ASC, [TRK_FK_T3_OBJ_ID] ASC, [TRK_FK_T3_IDX_ID] ASC)
    INCLUDE([TRK_ID], [TRK_Index_Rank], [TRK_Partition_Number], [TRK_Index_Type_Desc], [TRK_Alloc_Unit_Type_Desc], [TRK_Index_Depth], [TRK_Index_Level], [TRK_Avg_Fragmentation_Percent], [TRK_Fragment_Count], [TRK_Avg_Fragment_Page_Size], [TRK_Page_Count], [TRK_Avg_Page_Space_Percent_Used], [TRK_Scanned_Record_Count], [TRK_Min_Record_Byte_Size], [TRK_Max_Record_Byte_Size], [TRK_Avg_Record_Byte_Size], [TRK_Post_Date]);


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