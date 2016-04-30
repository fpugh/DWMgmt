USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_TRK_0300_Utilization_Upsert]'))
DROP TRIGGER [CAT].[TGR_TRK_0300_Utilization_Upsert]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_TRK_0300_LNK_0204_0300_Schema_Binding]') AND parent_object_id = OBJECT_ID(N'[CAT].[TRK_0300_Object_Utiliztion_Metrics]'))
ALTER TABLE [CAT].[TRK_0300_Object_Utiliztion_Metrics] DROP CONSTRAINT [FK_TRK_0300_LNK_0204_0300_Schema_Binding]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_TRK_0300_LNK_0100_0200_Server_Databases]') AND parent_object_id = OBJECT_ID(N'[CAT].[TRK_0300_Object_Utiliztion_Metrics]'))
ALTER TABLE [CAT].[TRK_0300_Object_Utiliztion_Metrics] DROP CONSTRAINT [FK_TRK_0300_LNK_0100_0200_Server_Databases]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_TRK_0300_Post]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0300_Object_Utiliztion_Metrics] DROP CONSTRAINT [DF_TRK_0300_Post]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[TRK_0300_Object_Utiliztion_Metrics]') AND type in (N'U'))
DROP TABLE [CAT].[TRK_0300_Object_Utiliztion_Metrics]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[TRK_0300_Object_Utiliztion_Metrics]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[TRK_0300_Object_Utiliztion_Metrics](
	[TRK_0300_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TRK_FK_T2_ID] [int] NOT NULL,
	[TRK_FK_T3_ID] [int] NOT NULL,
	[TRK_Last_Action_Type] [nvarchar](25) NOT NULL,
	[TRK_Last_Action_Date] [datetime] NOT NULL,
	[Total_Seeks] [int] NOT NULL,
	[Total_Scans] [int] NOT NULL,
	[Total_Lookups] [int] NOT NULL,
	[Total_Updates] [int] NOT NULL,
	[TRK_Post_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_TRK_0300] PRIMARY KEY CLUSTERED 
(
	[TRK_FK_T2_ID] ASC,
	[TRK_FK_T3_ID] ASC,
	[TRK_Last_Action_Type] ASC,
	[TRK_Last_Action_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_TRK_0300_ID] UNIQUE NONCLUSTERED 
(
	[TRK_0300_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_TRK_0300_Post]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[TRK_0300_Object_Utiliztion_Metrics] ADD  CONSTRAINT [DF_TRK_0300_Post]  DEFAULT (getdate()) FOR [TRK_Post_Date]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_TRK_0300_LNK_0100_0200_Server_Databases]') AND parent_object_id = OBJECT_ID(N'[CAT].[TRK_0300_Object_Utiliztion_Metrics]'))
ALTER TABLE [CAT].[TRK_0300_Object_Utiliztion_Metrics]  WITH CHECK ADD  CONSTRAINT [FK_TRK_0300_LNK_0100_0200_Server_Databases] FOREIGN KEY([TRK_FK_T2_ID])
REFERENCES [CAT].[LNK_0100_0200_Server_Databases] ([LNK_T2_ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_TRK_0300_LNK_0100_0200_Server_Databases]') AND parent_object_id = OBJECT_ID(N'[CAT].[TRK_0300_Object_Utiliztion_Metrics]'))
ALTER TABLE [CAT].[TRK_0300_Object_Utiliztion_Metrics] CHECK CONSTRAINT [FK_TRK_0300_LNK_0100_0200_Server_Databases]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_TRK_0300_LNK_0204_0300_Schema_Binding]') AND parent_object_id = OBJECT_ID(N'[CAT].[TRK_0300_Object_Utiliztion_Metrics]'))
ALTER TABLE [CAT].[TRK_0300_Object_Utiliztion_Metrics]  WITH CHECK ADD  CONSTRAINT [FK_TRK_0300_LNK_0204_0300_Schema_Binding] FOREIGN KEY([TRK_FK_T3_ID])
REFERENCES [CAT].[LNK_0204_0300_Schema_Binding] ([LNK_T3_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[CAT].[FK_TRK_0300_LNK_0204_0300_Schema_Binding]') AND parent_object_id = OBJECT_ID(N'[CAT].[TRK_0300_Object_Utiliztion_Metrics]'))
ALTER TABLE [CAT].[TRK_0300_Object_Utiliztion_Metrics] CHECK CONSTRAINT [FK_TRK_0300_LNK_0204_0300_Schema_Binding]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[CAT].[TGR_TRK_0300_Utilization_Upsert]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [CAT].[TGR_TRK_0300_Utilization_Upsert]
   ON [CAT].[TRK_0300_Object_Utiliztion_Metrics]
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;
    
	/* Test Model
			; WITH LastActionZeroes (Database_ID, Object_ID, action_Type, action_weight, action_Date)
		AS (
			SELECT DISTINCT Database_ID, Object_ID
			, piv.Action_Type
			, CASE WHEN piv.Action_Type like ''%seek'' THEN 1
				WHEN piv.Action_Type like ''%scan'' THEN 2
				WHEN piv.Action_Type like ''%lookup'' THEN 3
				WHEN piv.Action_Type like ''%update'' THEN 4
				END AS Action_Weight
			, piv.Action_Date
			FROM sys.dm_db_Index_usage_stats
			UNPIVOT (Action_Date FOR Action_Type IN 
			(last_user_seek,last_user_scan,last_user_lookup,last_user_update
			,last_System_seek,last_System_scan,last_System_lookup,last_System_update)) AS piv
			)

		SELECT DISTINCT TMP.LNK_T2_ID as TRK_FK_T2_ID, TMP.LNK_T3_ID as TRK_FK_T3_ID,T1.action_Type as TRK_Last_Action_Type, T1.action_Date as TRK_Last_Action_Date
		, T3.Total_Seeks, T3.Total_Scans, T3.Total_Lookups, T3.Total_Updates
		INTO #InsertedProxy
		FROM ##REG_0204_0300_Insert AS tmp
		JOIN LastActionZeroes AS t1
		ON t1.Database_ID = TMP.Database_ID
		AND t1.Object_ID = TMP.Object_ID
		AND TMP.Object_Type = ''u''
		JOIN (
			SELECT Database_ID
			, Object_ID, MAX(action_weight) as action_weight
			, MAX(Action_Date) as action_Date
			FROM LastActionZeroes
			GROUP BY Database_ID, Object_ID
			) AS T2
		ON T2.action_weight = T1.action_weight
		AND T2.Database_ID = T1.Database_ID
		AND T2.Object_ID = T1.Object_ID
		AND T2.action_Date = T1.action_Date
		JOIN (
			SELECT Database_ID, Object_ID
			, SUM(user_seeks)+SUM(system_seeks) as Total_Seeks 
			, SUM(user_scans)+SUM(system_scans) as Total_Scans
			, SUM(user_lookups)+SUM(system_lookups) as Total_Lookups
			, SUM(user_updates)+SUM(system_updates) as Total_Updates
			FROM sys.dm_db_Index_usage_stats
			GROUP BY Database_ID, Object_ID
			) AS T3
		ON T3.Database_ID = T1.Database_ID
		AND T3.Object_ID = T1.Object_ID
	*/

    INSERT INTO CAT.TRK_0300_Object_Utiliztion_Metrics (TRK_FK_T2_ID, TRK_FK_T3_ID, TRK_Last_Action_Type, TRK_Last_Action_Date, Total_Seeks, Total_Scans, Total_Lookups, Total_Updates)
    
    SELECT DISTINCT i.TRK_FK_T2_ID, i.TRK_FK_T3_ID, i.TRK_Last_Action_Type, i.TRK_Last_Action_Date, i.Total_Seeks, i.Total_Scans, i.Total_Lookups, i.Total_Updates
    FROM Inserted as i
    LEFT JOIN CAT.TRK_0300_Object_Utiliztion_Metrics AS trk
    ON trk.TRK_FK_T2_ID = i.TRK_FK_T2_ID
    AND trk.TRK_FK_T3_ID = i.TRK_FK_T3_ID
	AND trk.TRK_Last_Action_Type = i.TRK_Last_Action_Type
	AND trk.TRK_Last_Action_Date = i.TRK_Last_Action_Date
	WHERE trk.TRK_0300_ID IS NULL
	
	
END
' 
GO
