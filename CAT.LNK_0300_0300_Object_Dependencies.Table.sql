USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_L22_Object_Dependence]'))
DROP TRIGGER [CAT].[TGR_L22_Object_Dependence]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0300_Parent_REG_0300]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0300_Object_Dependencies]'))
ALTER TABLE [CAT].[LNK_0300_0300_Object_Dependencies] DROP CONSTRAINT [FK_LNK_0300_0300_Parent_REG_0300]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0300_Child_REG_0300]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0300_Object_Dependencies]'))
ALTER TABLE [CAT].[LNK_0300_0300_Object_Dependencies] DROP CONSTRAINT [FK_LNK_0300_0300_Child_REG_0300]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T2H_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0300_Object_Dependencies] DROP CONSTRAINT [DF_T2H_Term_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T2H_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0300_Object_Dependencies] DROP CONSTRAINT [DF_T2H_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0300_Object_Dependencies]') AND name = N'idx_nc_LNK_0300_0300_K2_K3')
DROP INDEX [idx_nc_LNK_0300_0300_K2_K3] ON [CAT].[LNK_0300_0300_Object_Dependencies]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0300_Object_Dependencies]') AND type in (N'U'))
DROP TABLE [CAT].[LNK_0300_0300_Object_Dependencies]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0300_Object_Dependencies]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[LNK_0300_0300_Object_Dependencies](
	[LNK_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LNK_FK_T3P_ID] [int] NOT NULL,
	[LNK_FK_T3R_ID] [int] NOT NULL,
	[LNK_Latch_Type] [nvarchar](25) NOT NULL,
	[LNK_FK_0300_Prm_ID] [int] NOT NULL,
	[LNK_FK_0300_Ref_ID] [int] NOT NULL,
	[LNK_Rank] [int] NOT NULL,
	[LNK_Post_Date] [datetime] NOT NULL,
	[LNK_Term_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_LNK_0300_0300] PRIMARY KEY CLUSTERED 
(
	[LNK_Post_Date] DESC,
	[LNK_Latch_Type] ASC,
	[LNK_FK_T3P_ID] ASC,
	[LNK_FK_T3R_ID] ASC,
	[LNK_FK_0300_Prm_ID] ASC,
	[LNK_FK_0300_Ref_ID] ASC,
	[LNK_Rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UQ_LNK_0300_ID] UNIQUE NONCLUSTERED 
(
	[LNK_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0300_Object_Dependencies]') AND name = N'idx_nc_LNK_0300_0300_K2_K3')
CREATE NONCLUSTERED INDEX [idx_nc_LNK_0300_0300_K2_K3] ON [CAT].[LNK_0300_0300_Object_Dependencies]
(
	[LNK_FK_T3P_ID] ASC,
	[LNK_FK_T3R_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T2H_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0300_Object_Dependencies] ADD  CONSTRAINT [DF_T2H_Post_Date]  DEFAULT (getdate()) FOR [LNK_Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T2H_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0300_Object_Dependencies] ADD  CONSTRAINT [DF_T2H_Term_Date]  DEFAULT ('12/31/2099') FOR [LNK_Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0300_Child_REG_0300]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0300_Object_Dependencies]'))
ALTER TABLE [CAT].[LNK_0300_0300_Object_Dependencies]  WITH CHECK ADD  CONSTRAINT [FK_LNK_0300_0300_Child_REG_0300] FOREIGN KEY([LNK_FK_0300_Ref_ID])
REFERENCES [CAT].[REG_0300_Object_registry] ([REG_0300_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0300_Child_REG_0300]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0300_Object_Dependencies]'))
ALTER TABLE [CAT].[LNK_0300_0300_Object_Dependencies] CHECK CONSTRAINT [FK_LNK_0300_0300_Child_REG_0300]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0300_Parent_REG_0300]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0300_Object_Dependencies]'))
ALTER TABLE [CAT].[LNK_0300_0300_Object_Dependencies]  WITH CHECK ADD  CONSTRAINT [FK_LNK_0300_0300_Parent_REG_0300] FOREIGN KEY([LNK_FK_0300_Prm_ID])
REFERENCES [CAT].[REG_0300_Object_registry] ([REG_0300_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0300_Parent_REG_0300]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0300_Object_Dependencies]'))
ALTER TABLE [CAT].[LNK_0300_0300_Object_Dependencies] CHECK CONSTRAINT [FK_LNK_0300_0300_Parent_REG_0300]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_L22_Object_Dependence]'))
EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER [CAT].[TGR_L22_Object_Dependence]
   ON  [CAT].[LNK_0300_0300_Object_Dependencies]
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;
    
    ; WITH Latch22 ([LNK_Latch_Type], [LNK_FK_T3P_ID], [LNK_FK_T3R_ID], [LNK_FK_0300_Prm_ID], [LNK_FK_0300_Ref_ID], [LNK_Rank], [LNK_Term_Date])
    AS (
        SELECT [LNK_Latch_Type], [LNK_FK_T3P_ID], [LNK_FK_T3R_ID], [LNK_FK_0300_Prm_ID], [LNK_FK_0300_Ref_ID], [LNK_Rank], [LNK_Term_Date]
        FROM [CAT].[LNK_0300_0300_Object_Dependencies]
        WHERE [LNK_Term_Date] > getdate()
        GROUP BY [LNK_Latch_Type], [LNK_FK_T3P_ID], [LNK_FK_T3R_ID], [LNK_FK_0300_Prm_ID], [LNK_FK_0300_Ref_ID], [LNK_Rank], [LNK_Term_Date]
        )

    INSERT INTO [CAT].[LNK_0300_0300_Object_Dependencies] ([LNK_Latch_Type], [LNK_FK_T3P_ID], [LNK_FK_T3R_ID], [LNK_FK_0300_Prm_ID], [LNK_FK_0300_Ref_ID], [LNK_Rank], [LNK_Term_Date])
    SELECT [LNK_Latch_Type], [LNK_FK_T3P_ID], [LNK_FK_T3R_ID], [LNK_FK_0300_Prm_ID], [LNK_FK_0300_Ref_ID], [LNK_Rank], ''12/31/2099''
    FROM inserted 
    EXCEPT
    SELECT [LNK_Latch_Type], [LNK_FK_T3P_ID], [LNK_FK_T3R_ID], [LNK_FK_0300_Prm_ID], [LNK_FK_0300_Ref_ID], [LNK_Rank], [LNK_Term_Date]
    FROM Latch22

       
	UPDATE T1 SET LNK_Term_Date = T2.LNK_Post_Date
    FROM CAT.LNK_0300_0300_Object_Dependencies AS T1
	LEFT JOIN CAT.LNK_0204_0300_Schema_Binding T2 with(nolock)
    ON T1.LNK_FK_T3P_ID = T2.LNK_T3_ID
	AND T1.LNK_FK_0300_Prm_ID = T2.LNK_FK_0300_ID
    WHERE T1.LNK_Post_Date < T2.LNK_Post_Date    
    
END
' 
GO
