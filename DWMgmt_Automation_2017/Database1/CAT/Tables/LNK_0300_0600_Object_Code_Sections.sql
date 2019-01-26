CREATE TABLE [CAT].[LNK_0300_0600_Object_Code_Sections] (
    [LNK_OCS_ID]     INT      IDENTITY (1, 1) NOT NULL,
    [LNK_FK_T3_ID]   INT      NOT NULL,
    [LNK_FK_0300_ID] INT      NOT NULL,
    [LNK_FK_0600_ID] INT      NOT NULL,
    [LNK_Rank]       SMALLINT CONSTRAINT [DF_0300_0600_Rank] DEFAULT ((0)) NOT NULL,
    [LNK_Class]      INT      NULL,
    [LNK_Post_Date]  DATETIME CONSTRAINT [DF_0300_0600_post] DEFAULT (getdate()) NOT NULL,
    [LNK_Term_Date]  DATETIME CONSTRAINT [DF_0300_0600_term] DEFAULT ('12/31/2099') NOT NULL,
    CONSTRAINT [PK_LNK_0300_0601] PRIMARY KEY CLUSTERED ([LNK_FK_T3_ID] ASC, [LNK_FK_0300_ID] ASC, [LNK_FK_0600_ID] ASC, [LNK_Rank] ASC, [LNK_Term_Date] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_LNK_0300_0600_REG_0300_Object_Registry] FOREIGN KEY ([LNK_FK_0300_ID]) REFERENCES [CAT].[REG_0300_Object_Registry] ([REG_0300_ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_LNK_0300_0600_REG_0600_Object_Code_Library] FOREIGN KEY ([LNK_FK_0600_ID]) REFERENCES [CAT].[REG_0600_Object_Code_Library] ([REG_0600_ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [UQ_0300_0600_ID] UNIQUE NONCLUSTERED ([LNK_OCS_ID] ASC)
);


GO


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

    INSERT INTO CAT.LNK_0300_0600_Object_Code_Sections (LNK_FK_T3_ID, LNK_FK_0300_ID, LNK_FK_0600_ID, LNK_Rank, LNK_Class, LNK_Post_Date)
    SELECT DISTINCT T1.LNK_FK_T3_ID, T1.LNK_FK_0300_ID, T1.LNK_FK_0600_ID, T1.LNK_Rank, T1.LNK_Class, T1.LNK_Post_Date
    FROM inserted AS T1
	LEFT JOIN CAT.LNK_0300_0600_Object_Code_Sections AS T2 with(nolock)
    ON T2.LNK_FK_0300_ID = T1.LNK_FK_0300_ID
	AND T2.LNK_FK_0600_ID = T1.LNK_FK_0600_ID
	AND T2.LNK_Rank = T1.LNK_Rank
	WHERE T2.LNK_OCS_ID IS NULL

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