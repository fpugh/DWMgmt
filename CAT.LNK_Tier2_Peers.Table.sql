USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_T2_Current_Properties]'))
DROP TRIGGER [CAT].[TGR_T2_Current_Properties]
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_T2_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] DROP CONSTRAINT [CHK_FK_T2_ID_GT_0]
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_0200_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] DROP CONSTRAINT [CHK_FK_0200_ID_GT_0]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0205_Database_Maintenance_Properties]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] DROP CONSTRAINT [FK_LNK_Tier2_Peers_REG_0205_Database_Maintenance_Properties]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0204_Database_Schemas]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] DROP CONSTRAINT [FK_LNK_Tier2_Peers_REG_0204_Database_Schemas]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0203_Database_Files]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] DROP CONSTRAINT [FK_LNK_Tier2_Peers_REG_0203_Database_Files]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0202_Database_Extended_Properties_B]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] DROP CONSTRAINT [FK_LNK_Tier2_Peers_REG_0202_Database_Extended_Properties_B]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0201_Database_Extended_Properties_A]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] DROP CONSTRAINT [FK_LNK_Tier2_Peers_REG_0201_Database_Extended_Properties_A]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0200_Database_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] DROP CONSTRAINT [FK_LNK_Tier2_Peers_REG_0200_Database_Registry]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_LNK_0100_0200]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] DROP CONSTRAINT [FK_LNK_Tier2_Peers_LNK_0100_0200]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T2P_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier2_Peers] DROP CONSTRAINT [DF_T2P_Term_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T2P_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier2_Peers] DROP CONSTRAINT [DF_T2P_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T2P_FK_0205]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier2_Peers] DROP CONSTRAINT [DF_T2P_FK_0205]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]') AND type in (N'U'))
DROP TABLE [CAT].[LNK_Tier2_Peers]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[LNK_Tier2_Peers](
	[T2P_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LNK_FK_T2_ID] [int] NOT NULL,
	[LNK_FK_0200_ID] [int] NOT NULL,
	[LNK_FK_0201_ID] [int] NOT NULL,
	[LNK_FK_0202_ID] [int] NOT NULL,
	[LNK_FK_0203_ID] [int] NOT NULL,
	[LNK_FK_0204_ID] [int] NOT NULL,
	[LNK_FK_0205_ID] [int] NOT NULL,
	[LNK_Post_Date] [datetime] NOT NULL,
	[LNK_Term_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_T2P] PRIMARY KEY CLUSTERED 
(
	[LNK_Post_Date] DESC,
	[LNK_FK_T2_ID] ASC,
	[LNK_FK_0200_ID] ASC,
	[LNK_FK_0201_ID] ASC,
	[LNK_FK_0202_ID] ASC,
	[LNK_FK_0203_ID] ASC,
	[LNK_FK_0204_ID] ASC,
	[LNK_FK_0205_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UQ_T2P_ID] UNIQUE NONCLUSTERED 
(
	[T2P_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T2P_FK_0205]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier2_Peers] ADD  CONSTRAINT [DF_T2P_FK_0205]  DEFAULT ((0)) FOR [LNK_FK_0205_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T2P_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier2_Peers] ADD  CONSTRAINT [DF_T2P_Post_Date]  DEFAULT (getdate()) FOR [LNK_Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T2P_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier2_Peers] ADD  CONSTRAINT [DF_T2P_Term_Date]  DEFAULT ('12/31/2099') FOR [LNK_Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_LNK_0100_0200]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier2_Peers_LNK_0100_0200] FOREIGN KEY([LNK_FK_T2_ID])
REFERENCES [CAT].[LNK_0100_0200_Server_Databases] ([LNK_T2_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_LNK_0100_0200]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] CHECK CONSTRAINT [FK_LNK_Tier2_Peers_LNK_0100_0200]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0200_Database_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier2_Peers_REG_0200_Database_Registry] FOREIGN KEY([LNK_FK_0200_ID])
REFERENCES [CAT].[REG_0200_Database_Registry] ([REG_0200_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0200_Database_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] CHECK CONSTRAINT [FK_LNK_Tier2_Peers_REG_0200_Database_Registry]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0201_Database_Extended_Properties_A]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier2_Peers_REG_0201_Database_Extended_Properties_A] FOREIGN KEY([LNK_FK_0201_ID])
REFERENCES [CAT].[REG_0201_Database_Extended_Properties_A] ([REG_0201_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0201_Database_Extended_Properties_A]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] CHECK CONSTRAINT [FK_LNK_Tier2_Peers_REG_0201_Database_Extended_Properties_A]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0202_Database_Extended_Properties_B]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier2_Peers_REG_0202_Database_Extended_Properties_B] FOREIGN KEY([LNK_FK_0202_ID])
REFERENCES [CAT].[REG_0202_Database_Extended_Properties_B] ([REG_0202_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0202_Database_Extended_Properties_B]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] CHECK CONSTRAINT [FK_LNK_Tier2_Peers_REG_0202_Database_Extended_Properties_B]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0203_Database_Files]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier2_Peers_REG_0203_Database_Files] FOREIGN KEY([LNK_FK_0203_ID])
REFERENCES [CAT].[REG_0203_Database_files] ([REG_0203_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0203_Database_Files]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] CHECK CONSTRAINT [FK_LNK_Tier2_Peers_REG_0203_Database_Files]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0204_Database_Schemas]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier2_Peers_REG_0204_Database_Schemas] FOREIGN KEY([LNK_FK_0204_ID])
REFERENCES [CAT].[REG_0204_Database_Schemas] ([REG_0204_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0204_Database_Schemas]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] CHECK CONSTRAINT [FK_LNK_Tier2_Peers_REG_0204_Database_Schemas]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0205_Database_Maintenance_Properties]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier2_Peers_REG_0205_Database_Maintenance_Properties] FOREIGN KEY([LNK_FK_0205_ID])
REFERENCES [CAT].[REG_0205_Database_Maintenance_Properties] ([REG_0205_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier2_Peers_REG_0205_Database_Maintenance_Properties]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] CHECK CONSTRAINT [FK_LNK_Tier2_Peers_REG_0205_Database_Maintenance_Properties]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_0200_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers]  WITH CHECK ADD  CONSTRAINT [CHK_FK_0200_ID_GT_0] CHECK  (([LNK_FK_0200_ID]>(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_0200_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] CHECK CONSTRAINT [CHK_FK_0200_ID_GT_0]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_T2_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers]  WITH CHECK ADD  CONSTRAINT [CHK_FK_T2_ID_GT_0] CHECK  (([LNK_FK_T2_ID]>(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_T2_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier2_Peers]'))
ALTER TABLE [CAT].[LNK_Tier2_Peers] CHECK CONSTRAINT [CHK_FK_T2_ID_GT_0]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_T2_Current_Properties]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [CAT].[TGR_T2_Current_Properties]
    ON  [CAT].[LNK_Tier2_Peers]
    INSTEAD OF INSERT
 AS  
 BEGIN
  SET NOCOUNT ON;
     
         
    UPDATE lnk SET LNK_Term_Date = getdate()
    FROM CAT.LNK_Tier2_Peers AS lnk
    LEFT JOIN inserted AS i
    ON lnk.LNK_FK_T2_ID = i.LNK_FK_T2_ID
    AND lnk.LNK_FK_0200_ID = i.LNK_FK_0200_ID
    AND lnk.LNK_FK_0201_ID = i.LNK_FK_0201_ID
    AND lnk.LNK_FK_0202_ID = i.LNK_FK_0202_ID
    AND lnk.LNK_FK_0203_ID = i.LNK_FK_0203_ID
    AND lnk.LNK_FK_0204_ID = i.LNK_FK_0204_ID
    AND lnk.LNK_FK_0205_ID = i.LNK_FK_0205_ID
    WHERE (lnk.LNK_Term_Date >= getdate()
	OR lnk.LNK_Term_Date < cast(0 as datetime))
    AND i.LNK_FK_T2_ID IS NULL
     

    INSERT INTO CAT.LNK_Tier2_Peers (LNK_FK_T2_ID, LNK_FK_0200_ID, LNK_FK_0201_ID, LNK_FK_0202_ID
    , LNK_FK_0203_ID, LNK_FK_0204_ID, LNK_FK_0205_ID)
    
    SELECT i.LNK_FK_T2_ID, i.LNK_FK_0200_ID, i.LNK_FK_0201_ID, i.LNK_FK_0202_ID
    , i.LNK_FK_0203_ID, i.LNK_FK_0204_ID, i.LNK_FK_0205_ID
    FROM inserted AS i
    LEFT JOIN CAT.LNK_Tier2_Peers AS p
    ON p.LNK_FK_T2_ID = i.LNK_FK_T2_ID
    AND p.LNK_FK_0200_ID = i.LNK_FK_0200_ID
    AND p.LNK_FK_0201_ID = i.LNK_FK_0201_ID
    AND p.LNK_FK_0202_ID = i.LNK_FK_0202_ID
    AND p.LNK_FK_0203_ID = i.LNK_FK_0203_ID
    AND p.LNK_FK_0204_ID = i.LNK_FK_0204_ID
    AND p.LNK_FK_0205_ID = i.LNK_FK_0205_ID
	AND p.LNK_Term_Date >= GETDATE()
	WHERE p.T2P_ID IS NULL
     
 END
' 
GO
