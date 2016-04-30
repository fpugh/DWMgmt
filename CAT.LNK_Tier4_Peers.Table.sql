USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_T4_Current_Properties]'))
DROP TRIGGER [CAT].[TGR_T4_Current_Properties]
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_T4_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers] DROP CONSTRAINT [CHK_FK_T4_ID_GT_0]
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_0400_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers] DROP CONSTRAINT [CHK_FK_0400_ID_GT_0]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier4_Peers_REG_0402_Column_Index_Details]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers] DROP CONSTRAINT [FK_LNK_Tier4_Peers_REG_0402_Column_Index_Details]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier4_Peers_REG_0401_Column_Properties]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers] DROP CONSTRAINT [FK_LNK_Tier4_Peers_REG_0401_Column_Properties]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier4_Peers_REG_0400_Column_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers] DROP CONSTRAINT [FK_LNK_Tier4_Peers_REG_0400_Column_Registry]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier4_Peers_LNK_0300_0400]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers] DROP CONSTRAINT [FK_LNK_Tier4_Peers_LNK_0300_0400]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T4P_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier4_Peers] DROP CONSTRAINT [DF_T4P_Term_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T4P_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier4_Peers] DROP CONSTRAINT [DF_T4P_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T4P_FK_0402]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier4_Peers] DROP CONSTRAINT [DF_T4P_FK_0402]
END

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]') AND name = N'idx_nc_T4P_K7_I1_I2_I3_I4_I5_I6')
DROP INDEX [idx_nc_T4P_K7_I1_I2_I3_I4_I5_I6] ON [CAT].[LNK_Tier4_Peers]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]') AND type in (N'U'))
DROP TABLE [CAT].[LNK_Tier4_Peers]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[LNK_Tier4_Peers](
	[T4P_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LNK_FK_T4_ID] [int] NOT NULL,
	[LNK_FK_0400_ID] [int] NOT NULL,
	[LNK_FK_0401_ID] [int] NOT NULL,
	[LNK_FK_0402_ID] [int] NOT NULL,
	[LNK_Post_Date] [datetime] NOT NULL,
	[LNK_Term_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_T4P] PRIMARY KEY CLUSTERED 
(
	[LNK_Post_Date] DESC,
	[LNK_FK_T4_ID] ASC,
	[LNK_FK_0400_ID] ASC,
	[LNK_FK_0401_ID] ASC,
	[LNK_FK_0402_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UQ_T4P_ID] UNIQUE NONCLUSTERED 
(
	[T4P_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]') AND name = N'idx_nc_T4P_K7_I1_I2_I3_I4_I5_I6')
CREATE NONCLUSTERED INDEX [idx_nc_T4P_K7_I1_I2_I3_I4_I5_I6] ON [CAT].[LNK_Tier4_Peers]
(
	[LNK_Term_Date] ASC
)
INCLUDE ( 	[T4P_ID],
	[LNK_FK_T4_ID],
	[LNK_FK_0400_ID],
	[LNK_FK_0401_ID],
	[LNK_FK_0402_ID],
	[LNK_Post_Date]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T4P_FK_0402]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier4_Peers] ADD  CONSTRAINT [DF_T4P_FK_0402]  DEFAULT ((0)) FOR [LNK_FK_0402_ID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T4P_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier4_Peers] ADD  CONSTRAINT [DF_T4P_Post_Date]  DEFAULT (getdate()) FOR [LNK_Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T4P_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_Tier4_Peers] ADD  CONSTRAINT [DF_T4P_Term_Date]  DEFAULT ('12/31/2099') FOR [LNK_Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier4_Peers_LNK_0300_0400]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier4_Peers_LNK_0300_0400] FOREIGN KEY([LNK_FK_T4_ID])
REFERENCES [CAT].[LNK_0300_0400_Object_Column_Collection] ([LNK_T4_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier4_Peers_LNK_0300_0400]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers] CHECK CONSTRAINT [FK_LNK_Tier4_Peers_LNK_0300_0400]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier4_Peers_REG_0400_Column_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier4_Peers_REG_0400_Column_Registry] FOREIGN KEY([LNK_FK_0400_ID])
REFERENCES [CAT].[REG_0400_Column_registry] ([REG_0400_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier4_Peers_REG_0400_Column_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers] CHECK CONSTRAINT [FK_LNK_Tier4_Peers_REG_0400_Column_Registry]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier4_Peers_REG_0401_Column_Properties]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier4_Peers_REG_0401_Column_Properties] FOREIGN KEY([LNK_FK_0401_ID])
REFERENCES [CAT].[REG_0401_Column_Properties] ([REG_0401_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier4_Peers_REG_0401_Column_Properties]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers] CHECK CONSTRAINT [FK_LNK_Tier4_Peers_REG_0401_Column_Properties]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier4_Peers_REG_0402_Column_Index_Details]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_Tier4_Peers_REG_0402_Column_Index_Details] FOREIGN KEY([LNK_FK_0402_ID])
REFERENCES [CAT].[REG_0402_Column_Index_Details] ([REG_0402_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_Tier4_Peers_REG_0402_Column_Index_Details]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers] CHECK CONSTRAINT [FK_LNK_Tier4_Peers_REG_0402_Column_Index_Details]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_0400_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers]  WITH CHECK ADD  CONSTRAINT [CHK_FK_0400_ID_GT_0] CHECK  (([LNK_FK_0400_ID]>(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_0400_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers] CHECK CONSTRAINT [CHK_FK_0400_ID_GT_0]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_T4_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers]  WITH CHECK ADD  CONSTRAINT [CHK_FK_T4_ID_GT_0] CHECK  (([LNK_FK_T4_ID]>(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[CAT].[CHK_FK_T4_ID_GT_0]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_Tier4_Peers]'))
ALTER TABLE [CAT].[LNK_Tier4_Peers] CHECK CONSTRAINT [CHK_FK_T4_ID_GT_0]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_T4_Current_Properties]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [CAT].[TGR_T4_Current_Properties]
    ON  [CAT].[LNK_Tier4_Peers]
    INSTEAD OF INSERT
 AS  
 BEGIN
  SET NOCOUNT ON;
     
         
    UPDATE lnk SET LNK_Term_Date = getdate()
    FROM CAT.LNK_Tier4_Peers AS lnk
    LEFT JOIN Inserted AS i
    ON lnk.LNK_FK_T4_ID = i.LNK_FK_T4_ID
    AND lnk.LNK_FK_0400_ID = i.LNK_FK_0400_ID
    AND lnk.LNK_FK_0401_ID = i.LNK_FK_0401_ID
    AND lnk.LNK_FK_0402_ID = i.LNK_FK_0402_ID
    WHERE (lnk.LNK_Term_Date >= GETDATE()
	OR lnk.LNK_Term_Date < CAST(0 as datetime))
    AND i.LNK_FK_T4_ID IS NULL


    INSERT INTO CAT.LNK_Tier4_Peers (LNK_FK_T4_ID, LNK_FK_0400_ID, LNK_FK_0401_ID, LNK_FK_0402_ID)
    
    SELECT i.LNK_FK_T4_ID, i.LNK_FK_0400_ID, i.LNK_FK_0401_ID, i.LNK_FK_0402_ID
    FROM Inserted AS i
	LEFT JOIN CAT.LNK_Tier4_Peers AS p
	ON p.LNK_FK_T4_ID = i.LNK_FK_T4_ID
	AND p.LNK_FK_0400_ID = i.LNK_FK_0400_ID
	AND p.LNK_FK_0401_ID = i.LNK_FK_0401_ID
	AND p.LNK_FK_0402_ID = i.LNK_FK_0402_ID
	AND p.LNK_Term_Date >= GETDATE()
	WHERE p.T4P_ID IS NULL
     
 END
' 
GO
