USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_L2_Schema_Binding]'))
DROP TRIGGER [CAT].[TGR_L2_Schema_Binding]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0204_0300_REG_0300_Object_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0204_0300_Schema_Binding]'))
ALTER TABLE [CAT].[LNK_0204_0300_Schema_Binding] DROP CONSTRAINT [FK_LNK_0204_0300_REG_0300_Object_Registry]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0204_0300_REG_0204_DatabaseSchemas]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0204_0300_Schema_Binding]'))
ALTER TABLE [CAT].[LNK_0204_0300_Schema_Binding] DROP CONSTRAINT [FK_LNK_0204_0300_REG_0204_DatabaseSchemas]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0204_0300_LNK_T2_ID]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0204_0300_Schema_Binding]'))
ALTER TABLE [CAT].[LNK_0204_0300_Schema_Binding] DROP CONSTRAINT [FK_LNK_0204_0300_LNK_T2_ID]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T3L_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0204_0300_Schema_Binding] DROP CONSTRAINT [DF_T3L_Term_Date]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T3L_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0204_0300_Schema_Binding] DROP CONSTRAINT [DF_T3L_Post_Date]
END

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0204_0300_Schema_Binding]') AND name = N'NC_LNK_0204_0300_K3_I1_2_4_6')
DROP INDEX [NC_LNK_0204_0300_K3_I1_2_4_6] ON [CAT].[LNK_0204_0300_Schema_Binding]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0204_0300_Schema_Binding]') AND name = N'NC_LNK_0204_0300_K2_2_4_6_I1')
DROP INDEX [NC_LNK_0204_0300_K2_2_4_6_I1] ON [CAT].[LNK_0204_0300_Schema_Binding]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0204_0300_Schema_Binding]') AND type in (N'U'))
DROP TABLE [CAT].[LNK_0204_0300_Schema_Binding]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0204_0300_Schema_Binding]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[LNK_0204_0300_Schema_Binding](
	[LNK_T3_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LNK_FK_T2_ID] [int] NOT NULL,
	[LNK_FK_0204_ID] [int] NOT NULL,
	[LNK_FK_0300_ID] [int] NOT NULL,
	[LNK_Post_Date] [datetime] NOT NULL,
	[LNK_Term_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_LNK_0204_0300] PRIMARY KEY CLUSTERED 
(
	[LNK_Post_Date] DESC,
	[LNK_FK_T2_ID] ASC,
	[LNK_FK_0204_ID] ASC,
	[LNK_FK_0300_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UQ_LNK_0204_ID] UNIQUE NONCLUSTERED 
(
	[LNK_T3_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0204_0300_Schema_Binding]') AND name = N'NC_LNK_0204_0300_K2_2_4_6_I1')
CREATE NONCLUSTERED INDEX [NC_LNK_0204_0300_K2_2_4_6_I1] ON [CAT].[LNK_0204_0300_Schema_Binding]
(
	[LNK_FK_T2_ID] ASC,
	[LNK_FK_0204_ID] ASC,
	[LNK_FK_0300_ID] ASC,
	[LNK_Term_Date] ASC
)
INCLUDE ( 	[LNK_T3_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0204_0300_Schema_Binding]') AND name = N'NC_LNK_0204_0300_K3_I1_2_4_6')
CREATE NONCLUSTERED INDEX [NC_LNK_0204_0300_K3_I1_2_4_6] ON [CAT].[LNK_0204_0300_Schema_Binding]
(
	[LNK_FK_0204_ID] ASC
)
INCLUDE ( 	[LNK_T3_ID],
	[LNK_FK_T2_ID],
	[LNK_FK_0300_ID],
	[LNK_Post_Date],
	[LNK_Term_Date]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T3L_Post_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0204_0300_Schema_Binding] ADD  CONSTRAINT [DF_T3L_Post_Date]  DEFAULT (getdate()) FOR [LNK_Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T3L_Term_Date]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0204_0300_Schema_Binding] ADD  CONSTRAINT [DF_T3L_Term_Date]  DEFAULT ('12/31/2099') FOR [LNK_Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0204_0300_LNK_T2_ID]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0204_0300_Schema_Binding]'))
ALTER TABLE [CAT].[LNK_0204_0300_Schema_Binding]  WITH CHECK ADD  CONSTRAINT [FK_LNK_0204_0300_LNK_T2_ID] FOREIGN KEY([LNK_FK_T2_ID])
REFERENCES [CAT].[LNK_0100_0200_Server_Databases] ([LNK_T2_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0204_0300_LNK_T2_ID]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0204_0300_Schema_Binding]'))
ALTER TABLE [CAT].[LNK_0204_0300_Schema_Binding] CHECK CONSTRAINT [FK_LNK_0204_0300_LNK_T2_ID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0204_0300_REG_0204_DatabaseSchemas]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0204_0300_Schema_Binding]'))
ALTER TABLE [CAT].[LNK_0204_0300_Schema_Binding]  WITH CHECK ADD  CONSTRAINT [FK_LNK_0204_0300_REG_0204_DatabaseSchemas] FOREIGN KEY([LNK_FK_0204_ID])
REFERENCES [CAT].[REG_0204_Database_Schemas] ([REG_0204_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0204_0300_REG_0204_DatabaseSchemas]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0204_0300_Schema_Binding]'))
ALTER TABLE [CAT].[LNK_0204_0300_Schema_Binding] CHECK CONSTRAINT [FK_LNK_0204_0300_REG_0204_DatabaseSchemas]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0204_0300_REG_0300_Object_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0204_0300_Schema_Binding]'))
ALTER TABLE [CAT].[LNK_0204_0300_Schema_Binding]  WITH CHECK ADD  CONSTRAINT [FK_LNK_0204_0300_REG_0300_Object_Registry] FOREIGN KEY([LNK_FK_0300_ID])
REFERENCES [CAT].[REG_0300_Object_registry] ([REG_0300_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0204_0300_REG_0300_Object_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0204_0300_Schema_Binding]'))
ALTER TABLE [CAT].[LNK_0204_0300_Schema_Binding] CHECK CONSTRAINT [FK_LNK_0204_0300_REG_0300_Object_Registry]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_L2_Schema_Binding]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [CAT].[TGR_L2_Schema_Binding]
   ON  [CAT].[LNK_0204_0300_Schema_Binding]
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;
    
        
    UPDATE lat SET LNK_Term_Date = getdate()
    FROM CAT.LNK_0204_0300_Schema_Binding AS lat
    LEFT JOIN inserted AS i
    ON lat.LNK_FK_T2_ID = i.LNK_FK_T2_ID
    AND lat.LNK_FK_0204_ID = i.LNK_FK_0204_ID
    AND lat.LNK_FK_0300_ID = i.LNK_FK_0300_ID
    WHERE lat.LNK_Term_Date >= getdate()
    AND (i.LNK_FK_0204_ID IS NULL
	OR i.LNK_FK_0300_ID IS NULL)
    

	INSERT INTO CAT.LNK_0204_0300_Schema_Binding (LNK_FK_T2_ID, LNK_FK_0204_ID, LNK_FK_0300_ID)

	SELECT i.LNK_FK_T2_ID, i.LNK_FK_0204_ID, i.LNK_FK_0300_ID
	FROM inserted AS i
	LEFT JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb
	ON lsb.LNK_FK_T2_ID = i.LNK_FK_T2_ID
	AND lsb.LNK_FK_0204_ID = i.LNK_FK_0204_ID
	AND lsb.LNK_FK_0300_ID = i.LNK_FK_0300_ID
	AND lsb.LNK_Term_Date >= getdate()
	WHERE lsb.LNK_T3_ID IS NULL


	/* Update object code links selectively - in this statement
	the basis for termination is an open code object with
	an invalid T3 identifier. This maintains the vi_0360_Object_Code_Reference view
	more or less accurately during each LNK_0204_0300_Schema_Binding insert. */

	UPDATE T1 SET LNK_Term_Date = T2.LNK_Term_Date
    FROM CAT.LNK_0300_0600_Object_Code_Sections AS T1
	LEFT JOIN CAT.LNK_0204_0300_Schema_Binding AS T2 with(nolock)
    ON T1.LNK_FK_T3_ID = T2.LNK_T3_ID
    WHERE T1.LNK_Term_Date > T2.LNK_Term_Date

    
END
' 
GO
