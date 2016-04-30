USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_T1_Current_Properties]'))
DROP TRIGGER [CAT].[TGR_T1_Current_Properties]
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_0100_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]'))
ALTER TABLE [CAT].[LNK_Tier1_Peers] DROP CONSTRAINT [CHK_FK_0100_ID_GT_0]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier1_Peers_REG_0103_Server_Providers]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]'))
ALTER TABLE [CAT].[LNK_Tier1_Peers] DROP CONSTRAINT [FK_LNK_Tier1_Peers_REG_0103_Server_Providers]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier1_Peers_REG_0102_Publication_Replication_Server_Settings]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]'))
ALTER TABLE [CAT].[LNK_Tier1_Peers] DROP CONSTRAINT [FK_LNK_Tier1_Peers_REG_0102_Publication_Replication_Server_Settings]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier1_Peers_REG_0101_Linked_Server_Settings]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]'))
ALTER TABLE [CAT].[LNK_Tier1_Peers] DROP CONSTRAINT [FK_LNK_Tier1_Peers_REG_0101_Linked_Server_Settings]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier1_Peers_REG_0100_Server_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]'))
ALTER TABLE [CAT].[LNK_Tier1_Peers] DROP CONSTRAINT [FK_LNK_Tier1_Peers_REG_0100_Server_Registry]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T1P_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier1_Peers] DROP CONSTRAINT [DF_T1P_Term_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T1P_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier1_Peers] DROP CONSTRAINT [DF_T1P_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T1P_K5]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier1_Peers] DROP CONSTRAINT [DF_T1P_K5]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]') AND type in (N'U'))
DROP TABLE [CAT].[LNK_Tier1_Peers]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[LNK_Tier1_Peers](
	[T1P_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LNK_FK_0100_ID] [int] NOT NULL,
	[LNK_FK_0101_ID] [int] NOT NULL,
	[LNK_FK_0102_ID] [int] NOT NULL,
	[LNK_FK_0103_ID] [int] NOT NULL,
	[LNK_Post_Date] [datetime] NOT NULL,
	[LNK_Term_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_T1P] PRIMARY KEY CLUSTERED 
(
	[LNK_Post_Date] ASC,
	[LNK_FK_0100_ID] ASC,
	[LNK_FK_0101_ID] ASC,
	[LNK_FK_0102_ID] ASC,
	[LNK_FK_0103_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_T1P_ID] UNIQUE NONCLUSTERED 
(
	[T1P_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T1P_K5]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier1_Peers] ADD  CONSTRAINT [DF_T1P_K5]  DEFAULT ((0)) FOR [LNK_FK_0103_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T1P_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier1_Peers] ADD  CONSTRAINT [DF_T1P_Post_Date]  DEFAULT (getdate()) FOR [LNK_Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T1P_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier1_Peers] ADD  CONSTRAINT [DF_T1P_Term_Date]  DEFAULT ('12/31/2099') FOR [LNK_Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier1_Peers_REG_0100_Server_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]'))
ALTER TABLE [CAT].[LNK_Tier1_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier1_Peers_REG_0100_Server_Registry] FOREIGN KEY([LNK_FK_0100_ID])
REFERENCES [CAT].[REG_0100_Server_Registry] ([REG_0100_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier1_Peers_REG_0100_Server_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]'))
ALTER TABLE [CAT].[LNK_Tier1_Peers] CHECK CONSTRAINT [FK_LNK_Tier1_Peers_REG_0100_Server_Registry]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier1_Peers_REG_0101_Linked_Server_Settings]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]'))
ALTER TABLE [CAT].[LNK_Tier1_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier1_Peers_REG_0101_Linked_Server_Settings] FOREIGN KEY([LNK_FK_0101_ID])
REFERENCES [CAT].[REG_0101_Linked_Server_Settings] ([REG_0101_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier1_Peers_REG_0101_Linked_Server_Settings]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]'))
ALTER TABLE [CAT].[LNK_Tier1_Peers] CHECK CONSTRAINT [FK_LNK_Tier1_Peers_REG_0101_Linked_Server_Settings]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier1_Peers_REG_0102_Publication_Replication_Server_Settings]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]'))
ALTER TABLE [CAT].[LNK_Tier1_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier1_Peers_REG_0102_Publication_Replication_Server_Settings] FOREIGN KEY([LNK_FK_0102_ID])
REFERENCES [CAT].[REG_0102_Publication_Replication_Server_Settings] ([REG_0102_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier1_Peers_REG_0102_Publication_Replication_Server_Settings]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]'))
ALTER TABLE [CAT].[LNK_Tier1_Peers] CHECK CONSTRAINT [FK_LNK_Tier1_Peers_REG_0102_Publication_Replication_Server_Settings]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier1_Peers_REG_0103_Server_Providers]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]'))
ALTER TABLE [CAT].[LNK_Tier1_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier1_Peers_REG_0103_Server_Providers] FOREIGN KEY([LNK_FK_0103_ID])
REFERENCES [CAT].[REG_0103_Server_Providers] ([REG_0103_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier1_Peers_REG_0103_Server_Providers]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]'))
ALTER TABLE [CAT].[LNK_Tier1_Peers] CHECK CONSTRAINT [FK_LNK_Tier1_Peers_REG_0103_Server_Providers]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_0100_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]'))
ALTER TABLE [CAT].[LNK_Tier1_Peers]  WITH CHECK ADD  CONSTRAINT [CHK_FK_0100_ID_GT_0] CHECK  (([LNK_FK_0100_ID]>(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_0100_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier1_Peers]'))
ALTER TABLE [CAT].[LNK_Tier1_Peers] CHECK CONSTRAINT [CHK_FK_0100_ID_GT_0]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_T1_Current_Properties]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [CAT].[TGR_T1_Current_Properties]
    ON  [CAT].[LNK_Tier1_Peers]
    INSTEAD OF INSERT
 AS  
 BEGIN
  SET NOCOUNT ON;
     
         
     UPDATE lnk SET LNK_Term_Date = getdate()
     FROM CAT.LNK_Tier1_Peers AS lnk
     LEFT JOIN inserted AS i
     ON lnk.LNK_FK_0100_ID = i.LNK_FK_0100_ID
     AND lnk.LNK_FK_0101_ID = i.LNK_FK_0101_ID
     AND lnk.LNK_FK_0102_ID = i.LNK_FK_0102_ID
     AND lnk.LNK_FK_0103_ID = i.LNK_FK_0103_ID
     WHERE (lnk.LNK_Term_Date >= getdate()
	 OR lnk.LNK_Term_Date < cast(0 as datetime))
	 AND lnk.T1P_ID IS NULL
	 
     
     INSERT INTO CAT.LNK_Tier1_Peers (LNK_FK_0100_ID, LNK_FK_0101_ID, LNK_FK_0102_ID, LNK_FK_0103_ID)

     SELECT i.LNK_FK_0100_ID, i.LNK_FK_0101_ID, i.LNK_FK_0102_ID, i.LNK_FK_0103_ID
     FROM inserted AS i
     LEFT JOIN CAT.LNK_Tier1_Peers AS p
     ON p.LNK_FK_0100_ID = i.LNK_FK_0100_ID
     AND p.LNK_FK_0101_ID = i.LNK_FK_0101_ID
     AND p.LNK_FK_0102_ID = i.LNK_FK_0102_ID
     AND p.LNK_FK_0103_ID = i.LNK_FK_0103_ID
     AND p.LNK_Term_Date >= GETDATE()
     WHERE p.T1P_ID IS NULL
     
 END
' 
GO
