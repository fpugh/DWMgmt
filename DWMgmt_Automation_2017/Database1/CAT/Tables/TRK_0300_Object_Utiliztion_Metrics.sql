CREATE TABLE [CAT].[TRK_0300_Object_Utiliztion_Metrics] (
    [TRK_0300_ID]          INT           IDENTITY (1, 1) NOT NULL,
    [TRK_FK_T2_ID]         INT           NOT NULL,
    [TRK_FK_T3_ID]         INT           NOT NULL,
    [TRK_Last_Action_Type] NVARCHAR (25) NOT NULL,
    [TRK_Last_Action_Date] DATETIME      NOT NULL,
    [Total_Seeks]          INT           NOT NULL,
    [Total_Scans]          INT           NOT NULL,
    [Total_Lookups]        INT           NOT NULL,
    [Total_Updates]        INT           NOT NULL,
    [TRK_Post_Date]        DATETIME      CONSTRAINT [DF_TRK_0300_Post] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_TRK_0300] PRIMARY KEY CLUSTERED ([TRK_FK_T2_ID] ASC, [TRK_FK_T3_ID] ASC, [TRK_Last_Action_Type] ASC, [TRK_Last_Action_Date] ASC),
    CONSTRAINT [FK_TRK_0300_LNK_0100_0200_Server_Databases] FOREIGN KEY ([TRK_FK_T2_ID]) REFERENCES [CAT].[LNK_0100_0200_Server_Databases] ([LNK_T2_ID]),
    CONSTRAINT [FK_TRK_0300_LNK_0204_0300_Schema_Binding] FOREIGN KEY ([TRK_FK_T3_ID]) REFERENCES [CAT].[LNK_0204_0300_Schema_Binding] ([LNK_T3_ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [UQ_TRK_0300_ID] UNIQUE NONCLUSTERED ([TRK_0300_ID] ASC)
);


GO


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
			, CASE WHEN piv.Action_Type like '%seek' THEN 1
				WHEN piv.Action_Type like '%scan' THEN 2
				WHEN piv.Action_Type like '%lookup' THEN 3
				WHEN piv.Action_Type like '%update' THEN 4
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
		AND TMP.Object_Type = 'u'
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