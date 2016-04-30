USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_Lx_T500_Peers_Insert]'))
DROP TRIGGER [CAT].[TGR_Lx_T500_Peers_Insert]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0500_0501_REG_0501_Parameter_Properties]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_T500_Peers]'))
ALTER TABLE [CAT].[LNK_T500_Peers] DROP CONSTRAINT [FK_LNK_0500_0501_REG_0501_Parameter_Properties]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0500_0501_REG_0500_Parameter_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_T500_Peers]'))
ALTER TABLE [CAT].[LNK_T500_Peers] DROP CONSTRAINT [FK_LNK_0500_0501_REG_0500_Parameter_Registry]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T500_term]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_T500_Peers] DROP CONSTRAINT [DF_T500_term]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T500_post]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_T500_Peers] DROP CONSTRAINT [DF_T500_post]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_T500_Peers]') AND type in (N'U'))
DROP TABLE [CAT].[LNK_T500_Peers]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[LNK_T500_Peers]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[LNK_T500_Peers](
	[LNK_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LNK_FK_T3_ID] [int] NOT NULL,
	[LNK_FK_0500_ID] [int] NOT NULL,
	[LNK_FK_0501_ID] [int] NOT NULL,
	[LNK_Post_Date] [datetime] NOT NULL,
	[LNK_Term_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_LNK_0500_0501] PRIMARY KEY CLUSTERED 
(
	[LNK_Post_Date] DESC,
	[LNK_FK_T3_ID] ASC,
	[LNK_FK_0500_ID] ASC,
	[LNK_FK_0501_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UQ_0500_0501_ID] UNIQUE NONCLUSTERED 
(
	[LNK_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T500_post]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_T500_Peers] ADD  CONSTRAINT [DF_T500_post]  DEFAULT (getdate()) FOR [LNK_Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_T500_term]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[LNK_T500_Peers] ADD  CONSTRAINT [DF_T500_term]  DEFAULT ('12/31/2099') FOR [LNK_Term_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0500_0501_REG_0500_Parameter_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_T500_Peers]'))
ALTER TABLE [CAT].[LNK_T500_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_0500_0501_REG_0500_Parameter_Registry] FOREIGN KEY([LNK_FK_0500_ID])
REFERENCES [CAT].[REG_0500_Parameter_Registry] ([REG_0500_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0500_0501_REG_0500_Parameter_Registry]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_T500_Peers]'))
ALTER TABLE [CAT].[LNK_T500_Peers] CHECK CONSTRAINT [FK_LNK_0500_0501_REG_0500_Parameter_Registry]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0500_0501_REG_0501_Parameter_Properties]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_T500_Peers]'))
ALTER TABLE [CAT].[LNK_T500_Peers]  WITH CHECK ADD  CONSTRAINT [FK_LNK_0500_0501_REG_0501_Parameter_Properties] FOREIGN KEY([LNK_FK_0501_ID])
REFERENCES [CAT].[REG_0501_Parameter_Properties] ([REG_0501_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_LNK_0500_0501_REG_0501_Parameter_Properties]') AND parent_object_id = OBJECT_ID(N'[CAT].[LNK_T500_Peers]'))
ALTER TABLE [CAT].[LNK_T500_Peers] CHECK CONSTRAINT [FK_LNK_0500_0501_REG_0501_Parameter_Properties]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_Lx_T500_Peers_Insert]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [CAT].[TGR_Lx_T500_Peers_Insert]
   ON  [CAT].[LNK_T500_Peers]
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;
    

/* Begin Insertion of New Records 
	Select only the currrent valid subset of lnk entries for comparisson
	-- Migrate to OUTER JOIN method with covered index if possible.
	*/

    INSERT INTO CAT.LNK_T500_Peers (LNK_FK_T3_ID, LNK_FK_0500_ID, LNK_FK_0501_ID, LNK_Post_Date)
    SELECT DISTINCT T1.LNK_FK_T3_ID, T1.LNK_FK_0500_ID, T1.LNK_FK_0501_ID, T1.LNK_Post_Date
    FROM inserted AS T1
	LEFT JOIN CAT.LNK_T500_Peers AS T2 with(nolock)
    ON T2.LNK_FK_T3_ID = T1.LNK_FK_T3_ID
	AND T2.LNK_FK_0500_ID = T1.LNK_FK_0500_ID
	AND T2.LNK_FK_0501_ID = T1.LNK_FK_0501_ID
	AND T2.LNK_Post_Date = T1.LNK_Post_Date
	WHERE T2.LNK_ID IS NULL

/* Finally - for cases where multiple versions of the same code are acquired during
	a catalogging event leave only the final version as active. 
	(think testing/development where many versions may exist on the	same day before finalized code is created.) */

	UPDATE T1 SET LNK_Term_Date = T2.LNK_Post_Date
    FROM CAT.LNK_T500_Peers AS T1
	LEFT JOIN CAT.LNK_0300_0500_Object_Parameter_Collection AS T2 with(nolock)
    ON T1.LNK_FK_T3_ID = T2.LNK_FK_T3_ID
	AND T1.LNK_FK_0500_ID = T2.LNK_FK_0500_ID
    WHERE T1.LNK_Post_Date < T2.LNK_Post_Date

END
' 
GO
