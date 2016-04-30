USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_L3_Object_Parameter_Collection]'))
DROP TRIGGER [CAT].[TGR_L3_Object_Parameter_Collection]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0500_REG_0500_Parameter_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0500_Object_Parameter_Collection]'))
ALTER TABLE [CAT].[LNK_0300_0500_Object_Parameter_Collection] DROP CONSTRAINT [FK_LNK_0300_0500_REG_0500_Parameter_Registry]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0500_REG_0300_Object_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0500_Object_Parameter_Collection]'))
ALTER TABLE [CAT].[LNK_0300_0500_Object_Parameter_Collection] DROP CONSTRAINT [FK_LNK_0300_0500_REG_0300_Object_Registry]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_LNK_0300_0500_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0500_Object_Parameter_Collection] DROP CONSTRAINT [DF_LNK_0300_0500_Term_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_LNK_0300_0500_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0500_Object_Parameter_Collection] DROP CONSTRAINT [DF_LNK_0300_0500_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_LNK_0300_0500_Rank]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0500_Object_Parameter_Collection] DROP CONSTRAINT [DF_LNK_0300_0500_Rank]
END

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0500_Object_Parameter_Collection]') AND name = N'IDX_NCI_LNK_0300_0500_K7_I2_I3_I4_I5')
DROP INDEX [IDX_NCI_LNK_0300_0500_K7_I2_I3_I4_I5] ON [CAT].[LNK_0300_0500_Object_Parameter_Collection]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0500_Object_Parameter_Collection]') AND type in (N'U'))
DROP TABLE [CAT].[LNK_0300_0500_Object_Parameter_Collection]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0500_Object_Parameter_Collection]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[LNK_0300_0500_Object_Parameter_Collection](
	[LNK_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LNK_FK_T3_ID] [int] NOT NULL,
	[LNK_FK_0300_ID] [int] NOT NULL,
	[LNK_FK_0500_ID] [int] NOT NULL,
	[LNK_Rank] [smallint] NOT NULL,
	[LNK_Post_Date] [datetime] NOT NULL,
	[LNK_Term_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_LNK_0300_0500] PRIMARY KEY CLUSTERED 
(
	[LNK_Post_Date] DESC,
	[LNK_FK_T3_ID] ASC,
	[LNK_FK_0300_ID] ASC,
	[LNK_FK_0500_ID] ASC,
	[LNK_Rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UQ_LNK_0300_0500_ID] UNIQUE NONCLUSTERED 
(
	[LNK_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0500_Object_Parameter_Collection]') AND name = N'IDX_NCI_LNK_0300_0500_K7_I2_I3_I4_I5')
CREATE NONCLUSTERED INDEX [IDX_NCI_LNK_0300_0500_K7_I2_I3_I4_I5] ON [CAT].[LNK_0300_0500_Object_Parameter_Collection]
(
	[LNK_Term_Date] ASC
)
INCLUDE ( 	[LNK_FK_T3_ID],
	[LNK_FK_0300_ID],
	[LNK_FK_0500_ID],
	[LNK_Rank]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_LNK_0300_0500_Rank]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0500_Object_Parameter_Collection] ADD  CONSTRAINT [DF_LNK_0300_0500_Rank]  DEFAULT ((1)) FOR [LNK_Rank]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_LNK_0300_0500_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0500_Object_Parameter_Collection] ADD  CONSTRAINT [DF_LNK_0300_0500_Post_Date]  DEFAULT (getdate()) FOR [LNK_Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_LNK_0300_0500_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0500_Object_Parameter_Collection] ADD  CONSTRAINT [DF_LNK_0300_0500_Term_Date]  DEFAULT ('12/31/2099') FOR [LNK_Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0500_REG_0300_Object_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0500_Object_Parameter_Collection]'))
ALTER TABLE [CAT].[LNK_0300_0500_Object_Parameter_Collection]  WITH CHECK ADD  CONSTRAINT [FK_LNK_0300_0500_REG_0300_Object_Registry] FOREIGN KEY([LNK_FK_0300_ID])
REFERENCES [CAT].[REG_0300_Object_registry] ([REG_0300_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0500_REG_0300_Object_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0500_Object_Parameter_Collection]'))
ALTER TABLE [CAT].[LNK_0300_0500_Object_Parameter_Collection] CHECK CONSTRAINT [FK_LNK_0300_0500_REG_0300_Object_Registry]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0500_REG_0500_Parameter_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0500_Object_Parameter_Collection]'))
ALTER TABLE [CAT].[LNK_0300_0500_Object_Parameter_Collection]  WITH CHECK ADD  CONSTRAINT [FK_LNK_0300_0500_REG_0500_Parameter_Registry] FOREIGN KEY([LNK_FK_0500_ID])
REFERENCES [CAT].[REG_0500_Parameter_Registry] ([REG_0500_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0500_REG_0500_Parameter_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0500_Object_Parameter_Collection]'))
ALTER TABLE [CAT].[LNK_0300_0500_Object_Parameter_Collection] CHECK CONSTRAINT [FK_LNK_0300_0500_REG_0500_Parameter_Registry]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_L3_Object_Parameter_Collection]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [CAT].[TGR_L3_Object_Parameter_Collection]
   ON  [CAT].[LNK_0300_0500_Object_Parameter_Collection]
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;
    
        
    UPDATE lat SET LNK_Term_Date = getdate()
    FROM CAT.LNK_0300_0500_Object_Parameter_Collection AS lat
    LEFT JOIN inserted AS i
    ON lat.LNK_FK_T3_ID = i.LNK_FK_T3_ID
    AND lat.LNK_FK_0300_ID = i.LNK_FK_0300_ID
    AND lat.LNK_FK_0500_ID = i.LNK_FK_0500_ID
	AND lat.LNK_Rank = i.LNK_Rank
    WHERE lat.LNK_Term_Date >= getdate()
    AND i.LNK_FK_T3_ID IS NULL
    

    ; WITH Latch_OPC (LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0500_ID, LNK_Rank)
    AS (
        SELECT DISTINCT LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0500_ID, LNK_Rank
        FROM CAT.LNK_0300_0500_Object_Parameter_Collection
        WHERE LNK_Term_Date > getdate()
        )
	
    INSERT INTO CAT.LNK_0300_0500_Object_Parameter_Collection (LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0500_ID, LNK_Rank)
    SELECT DISTINCT LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0500_ID, LNK_Rank
    FROM inserted 
    EXCEPT
    SELECT LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0500_ID, LNK_Rank
    FROM Latch_OPC

    
END
' 
GO
