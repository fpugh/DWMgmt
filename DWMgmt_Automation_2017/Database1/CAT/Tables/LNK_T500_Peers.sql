CREATE TABLE [CAT].[LNK_T500_Peers] (
    [LNK_ID]         INT      IDENTITY (1, 1) NOT NULL,
    [LNK_FK_T3_ID]   INT      NOT NULL,
    [LNK_FK_0500_ID] INT      NOT NULL,
    [LNK_FK_0501_ID] INT      NOT NULL,
    [LNK_Post_Date]  DATETIME CONSTRAINT [DF_T500_post] DEFAULT (getdate()) NOT NULL,
    [LNK_Term_Date]  DATETIME CONSTRAINT [DF_T500_term] DEFAULT ('12/31/2099') NOT NULL,
    CONSTRAINT [PK_LNK_0500_0501] PRIMARY KEY CLUSTERED ([LNK_FK_T3_ID] ASC, [LNK_FK_0500_ID] ASC, [LNK_FK_0501_ID] ASC, [LNK_Post_Date] ASC, [LNK_Term_Date] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_LNK_0500_0501_REG_0500_Parameter_Registry] FOREIGN KEY ([LNK_FK_0500_ID]) REFERENCES [CAT].[REG_0500_Parameter_Registry] ([REG_0500_ID]),
    CONSTRAINT [FK_LNK_0500_0501_REG_0501_Parameter_Properties] FOREIGN KEY ([LNK_FK_0501_ID]) REFERENCES [CAT].[REG_0501_Parameter_Properties] ([REG_0501_ID]),
    CONSTRAINT [UQ_0500_0501_ID] UNIQUE NONCLUSTERED ([LNK_ID] ASC)
);


GO


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