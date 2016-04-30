USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_Lx_Object_Code]'))
DROP TRIGGER [CAT].[TGR_Lx_Object_Code]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0600_REG_0600_Object_Code_Library]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0600_Object_Code_Sections]'))
ALTER TABLE [CAT].[LNK_0300_0600_Object_Code_Sections] DROP CONSTRAINT [FK_LNK_0300_0600_REG_0600_Object_Code_Library]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0600_REG_0300_Object_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0600_Object_Code_Sections]'))
ALTER TABLE [CAT].[LNK_0300_0600_Object_Code_Sections] DROP CONSTRAINT [FK_LNK_0300_0600_REG_0300_Object_Registry]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_0300_0600_term]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0600_Object_Code_Sections] DROP CONSTRAINT [DF_0300_0600_term]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_0300_0600_post]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0600_Object_Code_Sections] DROP CONSTRAINT [DF_0300_0600_post]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_0300_0600_Rank]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0600_Object_Code_Sections] DROP CONSTRAINT [DF_0300_0600_Rank]
END

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0600_Object_Code_Sections]') AND name = N'idx_nc_0300_0600_K2_K3_K4_I1')
DROP INDEX [idx_nc_0300_0600_K2_K3_K4_I1] ON [CAT].[LNK_0300_0600_Object_Code_Sections]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0600_Object_Code_Sections]') AND type in (N'U'))
DROP TABLE [CAT].[LNK_0300_0600_Object_Code_Sections]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0600_Object_Code_Sections]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[LNK_0300_0600_Object_Code_Sections](
	[LNK_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LNK_FK_T3_ID] [int] NOT NULL,
	[LNK_FK_0300_ID] [int] NOT NULL,
	[LNK_FK_0600_ID] [int] NOT NULL,
	[LNK_Rank] [smallint] NOT NULL,
	[LNK_Post_Date] [datetime] NOT NULL,
	[LNK_Term_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_LNK_0300_0601] PRIMARY KEY CLUSTERED 
(
	[LNK_Post_Date] DESC,
	[LNK_FK_T3_ID] ASC,
	[LNK_FK_0300_ID] ASC,
	[LNK_FK_0600_ID] ASC,
	[LNK_Rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UQ_0300_0600_ID] UNIQUE NONCLUSTERED 
(
	[LNK_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[CAT].[LNK_0300_0600_Object_Code_Sections]') AND name = N'idx_nc_0300_0600_K2_K3_K4_I1')
CREATE NONCLUSTERED INDEX [idx_nc_0300_0600_K2_K3_K4_I1] ON [CAT].[LNK_0300_0600_Object_Code_Sections]
(
	[LNK_FK_0300_ID] ASC,
	[LNK_FK_0600_ID] ASC,
	[LNK_Rank] ASC
)
INCLUDE ( 	[LNK_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_0300_0600_Rank]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0600_Object_Code_Sections] ADD  CONSTRAINT [DF_0300_0600_Rank]  DEFAULT ((0)) FOR [LNK_Rank]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_0300_0600_post]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0600_Object_Code_Sections] ADD  CONSTRAINT [DF_0300_0600_post]  DEFAULT (getdate()) FOR [LNK_Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_0300_0600_term]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_0300_0600_Object_Code_Sections] ADD  CONSTRAINT [DF_0300_0600_term]  DEFAULT ('12/31/2099') FOR [LNK_Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0600_REG_0300_Object_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0600_Object_Code_Sections]'))
ALTER TABLE [CAT].[LNK_0300_0600_Object_Code_Sections]  WITH CHECK ADD  CONSTRAINT [FK_LNK_0300_0600_REG_0300_Object_Registry] FOREIGN KEY([LNK_FK_0300_ID])
REFERENCES [CAT].[REG_0300_Object_registry] ([REG_0300_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0600_REG_0300_Object_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0600_Object_Code_Sections]'))
ALTER TABLE [CAT].[LNK_0300_0600_Object_Code_Sections] CHECK CONSTRAINT [FK_LNK_0300_0600_REG_0300_Object_Registry]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0600_REG_0600_Object_Code_Library]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0600_Object_Code_Sections]'))
ALTER TABLE [CAT].[LNK_0300_0600_Object_Code_Sections]  WITH CHECK ADD  CONSTRAINT [FK_LNK_0300_0600_REG_0600_Object_Code_Library] FOREIGN KEY([LNK_FK_0600_ID])
REFERENCES [CAT].[REG_0600_Object_Code_Library] ([REG_0600_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0300_0600_REG_0600_Object_Code_Library]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_0300_0600_Object_Code_Sections]'))
ALTER TABLE [CAT].[LNK_0300_0600_Object_Code_Sections] CHECK CONSTRAINT [FK_LNK_0300_0600_REG_0600_Object_Code_Library]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_Lx_Object_Code]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [CAT].[TGR_Lx_Object_Code]
   ON  [CAT].[LNK_0300_0600_Object_Code_Sections]
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;
    

/* Begin Insertion of New Records 
	Select only the currrent valid subset of lnk entries for comparisson
	-- Migrate to OUTER JOIN method with covered index if possible.
	*/

    INSERT INTO CAT.LNK_0300_0600_Object_Code_Sections (LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0600_ID, LNK_Rank, LNK_Post_Date)
    SELECT DISTINCT T1.LNK_FK_T3_ID, T1.LNK_FK_0300_ID, T1.LNK_FK_0600_ID, T1.LNK_Rank, T1.LNK_Post_Date
    FROM inserted AS T1
	LEFT JOIN CAT.LNK_0300_0600_Object_Code_Sections AS T2 with(nolock)
    ON T2.LNK_FK_0300_ID = T1.LNK_FK_0300_ID
	AND T2.LNK_FK_0600_ID = T1.LNK_FK_0600_ID
	AND T2.LNK_Rank = T1.LNK_Rank
	WHERE T2.LNK_ID IS NULL

/** Link termination:
	This section provides for automated grooming of old links during every insert;
	keeping code references more or less clean. The first section is replicated in the TGR_L2_Schema_Binding trigger. **/

/* Update object code links selectively - in this statement
	the basis for termination is an open code object with
	an invalid T3 identifier. */

	UPDATE T1 SET LNK_Term_Date = T2.LNK_Term_Date
    FROM CAT.LNK_0300_0600_Object_Code_Sections AS T1
	LEFT JOIN CAT.LNK_0204_0300_Schema_Binding AS T2 with(nolock)
    ON T1.LNK_FK_T3_ID = T2.LNK_T3_ID
    WHERE T1.LNK_Term_Date > T2.LNK_Term_Date

/* Update object code links selectively - in this statement
	the basis for termination is the same REG_0300_ID, and LNK_Rank
	with different LNK_0600_ID, or the same REG_0300_ID and REG_0600_ID
	but different link rank.
	 */

	UPDATE T1 SET LNK_Term_Date = T2.LNK_Post_Date
	--SELECT T1.*, t2.LNK_Post_Date
    FROM CAT.LNK_0300_0600_Object_Code_Sections AS T1
	JOIN CAT.LNK_0300_0600_Object_Code_Sections AS T2
    ON T1.LNK_FK_T3_ID = T2.LNK_FK_T3_ID
	AND T1.LNK_FK_0300_ID = T2.LNK_FK_0300_ID
	AND T1.LNK_Rank = T2.LNK_Rank
	AND T1.LNK_FK_0600_ID <> T2.LNK_FK_0600_ID
	AND T1.LNK_Post_Date < T2.LNK_Post_Date
	WHERE T1.LNK_Term_Date > T2.LNK_Post_Date

	UPDATE T1 SET LNK_Term_Date = T2.LNK_Post_Date
	--SELECT T1.*, t2.LNK_Post_Date
    FROM CAT.LNK_0300_0600_Object_Code_Sections AS T1
	JOIN CAT.LNK_0300_0600_Object_Code_Sections AS T2
    ON T1.LNK_FK_T3_ID = T2.LNK_FK_T3_ID
	AND T1.LNK_FK_0300_ID = T2.LNK_FK_0300_ID
	AND T1.LNK_FK_0600_ID = T2.LNK_FK_0600_ID
	AND T1.LNK_Rank <> T2.LNK_Rank
	AND T1.LNK_Post_Date < T2.LNK_Post_Date
	WHERE T1.LNK_Term_Date > T2.LNK_Post_Date	

END
' 
GO
