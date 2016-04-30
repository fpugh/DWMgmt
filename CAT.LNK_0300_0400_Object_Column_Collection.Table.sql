USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_L3_Object_Column_Collection]'))
DROP TRIGGER [CAT].[TGR_L3_Object_Column_Collection]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0400_REG_0400_Column_Collection]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]'))
ALTER TABLE [CAT].[LNK_0300_0400_Object_Column_Collection] DROP CONSTRAINT [FK_LNK_0300_0400_REG_0400_Column_Collection]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0400_REG_0300_Object_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]'))
ALTER TABLE [CAT].[LNK_0300_0400_Object_Column_Collection] DROP CONSTRAINT [FK_LNK_0300_0400_REG_0300_Object_Registry]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0400_LNK_T3_ID]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]'))
ALTER TABLE [CAT].[LNK_0300_0400_Object_Column_Collection] DROP CONSTRAINT [FK_LNK_0300_0400_LNK_T3_ID]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T4L_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0400_Object_Column_Collection] DROP CONSTRAINT [DF_T4L_Term_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T4L_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0400_Object_Column_Collection] DROP CONSTRAINT [DF_T4L_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T4L_Rank]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0400_Object_Column_Collection] DROP CONSTRAINT [DF_T4L_Rank]
END

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]') AND name = N'UQ_LNK_0300_0400_ID')
DROP INDEX [UQ_LNK_0300_0400_ID] ON [CAT].[LNK_0300_0400_Object_Column_Collection]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]') AND name = N'NC_LNK_0300_0400_K7_I1_2_3_4_5')
DROP INDEX [NC_LNK_0300_0400_K7_I1_2_3_4_5] ON [CAT].[LNK_0300_0400_Object_Column_Collection]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]') AND name = N'NC_LNK_0300_0400_K6_I2_I3_I4')
DROP INDEX [NC_LNK_0300_0400_K6_I2_I3_I4] ON [CAT].[LNK_0300_0400_Object_Column_Collection]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]') AND name = N'NC_LNK_0300_0400_K4_K7_I1_I2_I3')
DROP INDEX [NC_LNK_0300_0400_K4_K7_I1_I2_I3] ON [CAT].[LNK_0300_0400_Object_Column_Collection]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]') AND name = N'idx_nc_LNK_0300_0400_K2_K3_K7_I1_I4_I5')
DROP INDEX [idx_nc_LNK_0300_0400_K2_K3_K7_I1_I4_I5] ON [CAT].[LNK_0300_0400_Object_Column_Collection]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]') AND type in (N'U'))
DROP TABLE [CAT].[LNK_0300_0400_Object_Column_Collection]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[LNK_0300_0400_Object_Column_Collection](
	[LNK_T4_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LNK_FK_T3_ID] [int] NOT NULL,
	[LNK_FK_0300_ID] [int] NOT NULL,
	[LNK_FK_0400_ID] [int] NOT NULL,
	[LNK_Rank] [int] NOT NULL,
	[LNK_Post_Date] [datetime] NOT NULL,
	[LNK_Term_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_LNK_0300_0400] PRIMARY KEY CLUSTERED 
(
	[LNK_Post_Date] DESC,
	[LNK_FK_T3_ID] ASC,
	[LNK_FK_0300_ID] ASC,
	[LNK_FK_0400_ID] ASC,
	[LNK_Rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]') AND name = N'idx_nc_LNK_0300_0400_K2_K3_K7_I1_I4_I5')
CREATE NONCLUSTERED INDEX [idx_nc_LNK_0300_0400_K2_K3_K7_I1_I4_I5] ON [CAT].[LNK_0300_0400_Object_Column_Collection]
(
	[LNK_FK_T3_ID] ASC,
	[LNK_FK_0300_ID] ASC,
	[LNK_Term_Date] ASC
)
INCLUDE ( 	[LNK_T4_ID],
	[LNK_FK_0400_ID],
	[LNK_Rank]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]') AND name = N'NC_LNK_0300_0400_K4_K7_I1_I2_I3')
CREATE NONCLUSTERED INDEX [NC_LNK_0300_0400_K4_K7_I1_I2_I3] ON [CAT].[LNK_0300_0400_Object_Column_Collection]
(
	[LNK_FK_0400_ID] ASC,
	[LNK_Term_Date] ASC
)
INCLUDE ( 	[LNK_T4_ID],
	[LNK_FK_T3_ID],
	[LNK_FK_0300_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]') AND name = N'NC_LNK_0300_0400_K6_I2_I3_I4')
CREATE NONCLUSTERED INDEX [NC_LNK_0300_0400_K6_I2_I3_I4] ON [CAT].[LNK_0300_0400_Object_Column_Collection]
(
	[LNK_Term_Date] ASC
)
INCLUDE ( 	[LNK_FK_T3_ID],
	[LNK_FK_0300_ID],
	[LNK_FK_0400_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]') AND name = N'NC_LNK_0300_0400_K7_I1_2_3_4_5')
CREATE NONCLUSTERED INDEX [NC_LNK_0300_0400_K7_I1_2_3_4_5] ON [CAT].[LNK_0300_0400_Object_Column_Collection]
(
	[LNK_Term_Date] ASC
)
INCLUDE ( 	[LNK_T4_ID],
	[LNK_FK_T3_ID],
	[LNK_FK_0300_ID],
	[LNK_FK_0400_ID],
	[LNK_Rank]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]') AND name = N'UQ_LNK_0300_0400_ID')
CREATE UNIQUE NONCLUSTERED INDEX [UQ_LNK_0300_0400_ID] ON [CAT].[LNK_0300_0400_Object_Column_Collection]
(
	[LNK_T4_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T4L_Rank]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0400_Object_Column_Collection] ADD  CONSTRAINT [DF_T4L_Rank]  DEFAULT ((0)) FOR [LNK_Rank]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T4L_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0400_Object_Column_Collection] ADD  CONSTRAINT [DF_T4L_Post_Date]  DEFAULT (getdate()) FOR [LNK_Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T4L_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0400_Object_Column_Collection] ADD  CONSTRAINT [DF_T4L_Term_Date]  DEFAULT ('12/31/2099') FOR [LNK_Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0400_LNK_T3_ID]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]'))
ALTER TABLE [CAT].[LNK_0300_0400_Object_Column_Collection]  WITH CHECK ADD  CONSTRAINT [FK_LNK_0300_0400_LNK_T3_ID] FOREIGN KEY([LNK_FK_T3_ID])
REFERENCES [CAT].[LNK_0204_0300_Schema_Binding] ([LNK_T3_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0400_LNK_T3_ID]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]'))
ALTER TABLE [CAT].[LNK_0300_0400_Object_Column_Collection] CHECK CONSTRAINT [FK_LNK_0300_0400_LNK_T3_ID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0400_REG_0300_Object_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]'))
ALTER TABLE [CAT].[LNK_0300_0400_Object_Column_Collection]  WITH CHECK ADD  CONSTRAINT [FK_LNK_0300_0400_REG_0300_Object_Registry] FOREIGN KEY([LNK_FK_0300_ID])
REFERENCES [CAT].[REG_0300_Object_registry] ([REG_0300_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0400_REG_0300_Object_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]'))
ALTER TABLE [CAT].[LNK_0300_0400_Object_Column_Collection] CHECK CONSTRAINT [FK_LNK_0300_0400_REG_0300_Object_Registry]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0400_REG_0400_Column_Collection]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]'))
ALTER TABLE [CAT].[LNK_0300_0400_Object_Column_Collection]  WITH CHECK ADD  CONSTRAINT [FK_LNK_0300_0400_REG_0400_Column_Collection] FOREIGN KEY([LNK_FK_0400_ID])
REFERENCES [CAT].[REG_0400_Column_registry] ([REG_0400_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0400_REG_0400_Column_Collection]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0400_Object_Column_Collection]'))
ALTER TABLE [CAT].[LNK_0300_0400_Object_Column_Collection] CHECK CONSTRAINT [FK_LNK_0300_0400_REG_0400_Column_Collection]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_L3_Object_Column_Collection]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [CAT].[TGR_L3_Object_Column_Collection]
   ON  [CAT].[LNK_0300_0400_Object_Column_Collection]
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;
    
        
    UPDATE lat SET LNK_Term_Date = getdate()
    FROM CAT.LNK_0300_0400_Object_Column_Collection AS lat
    LEFT JOIN inserted AS i
    ON lat.LNK_FK_T3_ID = i.LNK_FK_T3_ID
    AND lat.LNK_FK_0300_ID = i.LNK_FK_0300_ID
    AND lat.LNK_FK_0400_ID = i.LNK_FK_0400_ID
	AND lat.LNK_Rank = i.LNK_Rank
    WHERE lat.LNK_Term_Date >= getdate()
    AND i.LNK_FK_T3_ID IS NULL
    

    ; WITH Latch3 (LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0400_ID, LNK_Rank)
    AS (
        SELECT LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0400_ID, LNK_Rank
        FROM CAT.LNK_0300_0400_Object_Column_Collection
        WHERE LNK_Term_Date > getdate()
        GROUP BY LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0400_ID, LNK_Rank
        )
	
    INSERT INTO CAT.LNK_0300_0400_Object_Column_Collection (LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0400_ID, LNK_Rank)
    SELECT DISTINCT LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0400_ID, LNK_Rank
    FROM inserted 
    EXCEPT
    SELECT LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0400_ID, LNK_Rank
    FROM Latch3

    
END
' 
GO
