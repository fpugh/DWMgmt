USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_T3_Current_Properties]'))
DROP TRIGGER [CAT].[TGR_T3_Current_Properties]
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_T3_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers] DROP CONSTRAINT [CHK_FK_T3_ID_GT_0]
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_0300_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers] DROP CONSTRAINT [CHK_FK_0300_ID_GT_0]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier3_Peers_REG_0302_Foreign_Key_Details]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers] DROP CONSTRAINT [FK_LNK_Tier3_Peers_REG_0302_Foreign_Key_Details]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier3_Peers_REG_0302_Constraint_Details]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers] DROP CONSTRAINT [FK_LNK_Tier3_Peers_REG_0302_Constraint_Details]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier3_Peers_REG_0301_Index_Details]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers] DROP CONSTRAINT [FK_LNK_Tier3_Peers_REG_0301_Index_Details]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier3_Peers_REG_0300_Object_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers] DROP CONSTRAINT [FK_LNK_Tier3_Peers_REG_0300_Object_Registry]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier3_Peers_LNK_0204_0300]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers] DROP CONSTRAINT [FK_LNK_Tier3_Peers_LNK_0204_0300]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T3P_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier3_Peers] DROP CONSTRAINT [DF_T3P_Term_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T3P_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier3_Peers] DROP CONSTRAINT [DF_T3P_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T3P_FK_0302_CD]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier3_Peers] DROP CONSTRAINT [DF_T3P_FK_0302_CD]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T3P_FK_0302_FK]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier3_Peers] DROP CONSTRAINT [DF_T3P_FK_0302_FK]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T3P_FK_0301]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier3_Peers] DROP CONSTRAINT [DF_T3P_FK_0301]
END

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]') AND name = N'idx_T3P_K8_I2_I4')
DROP INDEX [idx_T3P_K8_I2_I4] ON [CAT].[LNK_Tier3_Peers]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]') AND type in (N'U'))
DROP TABLE [CAT].[LNK_Tier3_Peers]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[LNK_Tier3_Peers](
	[T3P_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LNK_FK_T3_ID] [int] NOT NULL,
	[LNK_FK_0300_ID] [int] NOT NULL,
	[LNK_FK_0301_ID] [int] NOT NULL,
	[LNK_FK_0302_FK_ID] [int] NOT NULL,
	[LNK_FK_0302_CD_ID] [int] NOT NULL,
	[LNK_Post_Date] [datetime] NOT NULL,
	[LNK_Term_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_T3P] PRIMARY KEY CLUSTERED 
(
	[LNK_Post_Date] DESC,
	[LNK_FK_T3_ID] ASC,
	[LNK_FK_0300_ID] ASC,
	[LNK_FK_0301_ID] ASC,
	[LNK_FK_0302_FK_ID] ASC,
	[LNK_FK_0302_CD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UQ_T3P_ID] UNIQUE NONCLUSTERED 
(
	[T3P_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]') AND name = N'idx_T3P_K8_I2_I4')
CREATE NONCLUSTERED INDEX [idx_T3P_K8_I2_I4] ON [CAT].[LNK_Tier3_Peers]
(
	[LNK_Term_Date] ASC
)
INCLUDE ( 	[LNK_FK_T3_ID],
	[LNK_FK_0301_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T3P_FK_0301]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier3_Peers] ADD  CONSTRAINT [DF_T3P_FK_0301]  DEFAULT ((0)) FOR [LNK_FK_0301_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T3P_FK_0302_FK]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier3_Peers] ADD  CONSTRAINT [DF_T3P_FK_0302_FK]  DEFAULT ((0)) FOR [LNK_FK_0302_FK_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T3P_FK_0302_CD]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier3_Peers] ADD  CONSTRAINT [DF_T3P_FK_0302_CD]  DEFAULT ((0)) FOR [LNK_FK_0302_CD_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T3P_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier3_Peers] ADD  CONSTRAINT [DF_T3P_Post_Date]  DEFAULT (getdate()) FOR [LNK_Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T3P_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier3_Peers] ADD  CONSTRAINT [DF_T3P_Term_Date]  DEFAULT ('12/31/2099') FOR [LNK_Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier3_Peers_LNK_0204_0300]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier3_Peers_LNK_0204_0300] FOREIGN KEY([LNK_FK_T3_ID])
REFERENCES [CAT].[LNK_0204_0300_Schema_Binding] ([LNK_T3_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier3_Peers_LNK_0204_0300]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers] CHECK CONSTRAINT [FK_LNK_Tier3_Peers_LNK_0204_0300]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier3_Peers_REG_0300_Object_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier3_Peers_REG_0300_Object_Registry] FOREIGN KEY([LNK_FK_0300_ID])
REFERENCES [CAT].[REG_0300_Object_registry] ([REG_0300_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier3_Peers_REG_0300_Object_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers] CHECK CONSTRAINT [FK_LNK_Tier3_Peers_REG_0300_Object_Registry]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier3_Peers_REG_0301_Index_Details]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier3_Peers_REG_0301_Index_Details] FOREIGN KEY([LNK_FK_0301_ID])
REFERENCES [CAT].[REG_0301_Index_Details] ([REG_0301_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier3_Peers_REG_0301_Index_Details]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers] CHECK CONSTRAINT [FK_LNK_Tier3_Peers_REG_0301_Index_Details]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier3_Peers_REG_0302_Constraint_Details]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier3_Peers_REG_0302_Constraint_Details] FOREIGN KEY([LNK_FK_0302_CD_ID])
REFERENCES [CAT].[REG_0302_Foreign_Key_Details] ([REG_0302_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier3_Peers_REG_0302_Constraint_Details]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers] CHECK CONSTRAINT [FK_LNK_Tier3_Peers_REG_0302_Constraint_Details]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier3_Peers_REG_0302_Foreign_Key_Details]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier3_Peers_REG_0302_Foreign_Key_Details] FOREIGN KEY([LNK_FK_0302_FK_ID])
REFERENCES [CAT].[REG_0302_Foreign_Key_Details] ([REG_0302_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier3_Peers_REG_0302_Foreign_Key_Details]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers] CHECK CONSTRAINT [FK_LNK_Tier3_Peers_REG_0302_Foreign_Key_Details]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_0300_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers]  WITH CHECK ADD  CONSTRAINT [CHK_FK_0300_ID_GT_0] CHECK  (([LNK_FK_0300_ID]>(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_0300_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers] CHECK CONSTRAINT [CHK_FK_0300_ID_GT_0]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_T3_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers]  WITH CHECK ADD  CONSTRAINT [CHK_FK_T3_ID_GT_0] CHECK  (([LNK_FK_T3_ID]>(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_T3_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier3_Peers]'))
ALTER TABLE [CAT].[LNK_Tier3_Peers] CHECK CONSTRAINT [CHK_FK_T3_ID_GT_0]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_T3_Current_Properties]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [CAT].[TGR_T3_Current_Properties]
    ON  [CAT].[LNK_Tier3_Peers]
    INSTEAD OF INSERT
 AS  
 BEGIN
  SET NOCOUNT ON;
     
         
    UPDATE lnk SET LNK_Term_Date = getdate()
    FROM CAT.LNK_Tier3_Peers AS lnk
    LEFT JOIN inserted AS i
    ON lnk.LNK_FK_T3_ID = i.LNK_FK_T3_ID
    AND lnk.LNK_FK_0300_ID = i.LNK_FK_0300_ID
    AND lnk.LNK_FK_0301_ID = i.LNK_FK_0301_ID
    AND lnk.LNK_FK_0302_FK_ID = i.LNK_FK_0302_FK_ID
    AND lnk.LNK_FK_0302_CD_ID = i.LNK_FK_0302_CD_ID
    WHERE (lnk.LNK_Term_Date >= getdate()
	OR lnk.LNK_Term_Date < cast(0 as datetime))
    AND i.LNK_FK_T3_ID IS NULL
     

    INSERT INTO CAT.LNK_Tier3_Peers (LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0301_ID, LNK_FK_0302_FK_ID, LNK_FK_0302_CD_ID)
    
    SELECT i.LNK_FK_T3_ID, i.LNK_FK_0300_ID, i.LNK_FK_0301_ID, i.LNK_FK_0302_FK_ID, i.LNK_FK_0302_CD_ID
    FROM inserted AS i
	LEFT JOIN CAT.LNK_Tier3_Peers AS p WITH(NOLOCK)
    ON i.LNK_FK_T3_ID = p.LNK_FK_T3_ID
    AND i.LNK_FK_0300_ID = p.LNK_FK_0300_ID
    AND i.LNK_FK_0301_ID = p.LNK_FK_0301_ID
    AND i.LNK_FK_0302_FK_ID = p.LNK_FK_0302_FK_ID
    AND i.LNK_FK_0302_CD_ID = p.LNK_FK_0302_CD_ID
    AND p.LNK_Term_Date >= GETDATE() 
    WHERE p.T3P_ID IS NULL
 
     
 END
' 
GO
