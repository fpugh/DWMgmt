CREATE TABLE [CAT].[LNK_0300_0300_Object_Dependencies] (
    [LNK_ID]             INT           IDENTITY (1, 1) NOT NULL,
    [LNK_FK_T3P_ID]      INT           NOT NULL,
    [LNK_FK_T3R_ID]      INT           NOT NULL,
    [LNK_Latch_Type]     NVARCHAR (25) NOT NULL,
    [LNK_FK_0300_Prm_ID] INT           NOT NULL,
    [LNK_FK_0300_Ref_ID] INT           NOT NULL,
    [LNK_Rank]           INT           NOT NULL,
    [LNK_Post_Date]      DATETIME      CONSTRAINT [DF_T2H_Post_Date] DEFAULT (getdate()) NOT NULL,
    [LNK_Term_Date]      DATETIME      CONSTRAINT [DF_T2H_Term_Date] DEFAULT ('12/31/2099') NOT NULL,
    CONSTRAINT [PK_LNK_0300_0300] PRIMARY KEY CLUSTERED ([LNK_Latch_Type] ASC, [LNK_FK_T3P_ID] ASC, [LNK_FK_T3R_ID] ASC, [LNK_FK_0300_Prm_ID] ASC, [LNK_FK_0300_Ref_ID] ASC, [LNK_Rank] ASC, [LNK_Term_Date] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_LNK_0300_0300_Child_REG_0300] FOREIGN KEY ([LNK_FK_0300_Ref_ID]) REFERENCES [CAT].[REG_0300_Object_Registry] ([REG_0300_ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_LNK_0300_0300_Parent_REG_0300] FOREIGN KEY ([LNK_FK_0300_Prm_ID]) REFERENCES [CAT].[REG_0300_Object_Registry] ([REG_0300_ID]),
    CONSTRAINT [UQ_LNK_0300_0300_ID] UNIQUE NONCLUSTERED ([LNK_ID] ASC) WITH (FILLFACTOR = 90)
);


GO


CREATE TRIGGER [CAT].[TGR_L22_Object_Dependence]
   ON  [CAT].[LNK_0300_0300_Object_Dependencies]
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;
    
    /* Use common Select/Except method to identify new insertions from ANY statement source */

    ; WITH Latch22 ([LNK_Latch_Type], [LNK_FK_T3P_ID], [LNK_FK_T3R_ID], [LNK_FK_0300_Prm_ID], [LNK_FK_0300_Ref_ID], [LNK_Rank], [LNK_Term_Date])
    AS (
        SELECT [LNK_Latch_Type], [LNK_FK_T3P_ID], [LNK_FK_T3R_ID], [LNK_FK_0300_Prm_ID], [LNK_FK_0300_Ref_ID], [LNK_Rank], [LNK_Term_Date]
        FROM [CAT].[LNK_0300_0300_Object_Dependencies]
        WHERE [LNK_Term_Date] > getdate()
        )

    INSERT INTO [CAT].[LNK_0300_0300_Object_Dependencies] ([LNK_Latch_Type], [LNK_FK_T3P_ID], [LNK_FK_T3R_ID], [LNK_FK_0300_Prm_ID], [LNK_FK_0300_Ref_ID], [LNK_Rank], [LNK_Term_Date])
    SELECT [LNK_Latch_Type], [LNK_FK_T3P_ID], [LNK_FK_T3R_ID], [LNK_FK_0300_Prm_ID], [LNK_FK_0300_Ref_ID], [LNK_Rank], '12/31/2099'
    FROM inserted
	EXCEPT
    SELECT [LNK_Latch_Type], [LNK_FK_T3P_ID], [LNK_FK_T3R_ID], [LNK_FK_0300_Prm_ID], [LNK_FK_0300_Ref_ID], [LNK_Rank], [LNK_Term_Date]
    FROM Latch22

	/* Update LNK_Term_Date to reflect the status of the object within it's tier collection. 
		Per order by opperations, the LNK_0204_0300_Schema_Binding source is systematically updated
		before the LNK_0300_0300_Object_Dependencies portion of the catalogging process is run.

		Addtionally ad-hoc inserts made by Library processes, or by users should be tied to specific
		Catalog objects. These occasions will provide fresher view and model data.
	*/

    UPDATE lod SET [LNK_Term_Date] = lsb.LNK_Term_Date
    FROM [CAT].[LNK_0300_0300_Object_Dependencies] AS lod
	LEFT JOIN [CAT].[LNK_0204_0300_Schema_Binding] AS lsb
	ON lsb.LNK_T3_ID = lod.LNK_FK_T3P_ID
	OR lsb.LNK_T3_ID = lod.LNK_FK_T3R_ID
    WHERE lod.[LNK_Term_Date] <> lsb.LNK_Term_Date

END