CREATE TABLE [CAT].[LNK_0100_0200_Server_Databases] (
    [LNK_T2_ID]      INT      IDENTITY (1, 1) NOT NULL,
    [LNK_FK_0100_ID] INT      NOT NULL,
    [LNK_FK_0200_ID] INT      NOT NULL,
    [LNK_db_Rank]    TINYINT  NOT NULL,
    [LNK_Post_Date]  DATETIME CONSTRAINT [DF_T2L_Post_Date] DEFAULT (getdate()) NOT NULL,
    [LNK_Term_Date]  DATETIME CONSTRAINT [DF_T2L_Term_Date] DEFAULT ('12/31/2099') NOT NULL,
    CONSTRAINT [PK_0100_0200] PRIMARY KEY CLUSTERED ([LNK_FK_0100_ID] ASC, [LNK_FK_0200_ID] ASC, [LNK_db_Rank] ASC, [LNK_Term_Date] ASC),
    CONSTRAINT [FK_LNK_T1_Server_Databases] FOREIGN KEY ([LNK_FK_0100_ID]) REFERENCES [CAT].[REG_0100_Server_Registry] ([REG_0100_ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_LNK_T2_Server_Databases] FOREIGN KEY ([LNK_FK_0200_ID]) REFERENCES [CAT].[REG_0200_Database_Registry] ([REG_0200_ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [UQ_LNK_0100_ID] UNIQUE NONCLUSTERED ([LNK_T2_ID] ASC)
);


GO


CREATE TRIGGER [CAT].[TGR_L1_Server_Database_Registry]
   ON  [CAT].[LNK_0100_0200_Server_Databases]
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	/* Term by Abscence Methodology - if the scan can't see it the linkage goes away.
		Subsequent scans will automatically re-establish it after an offline event. */
		      
    UPDATE lsd SET LNK_Term_Date = getdate()
    FROM CAT.LNK_0100_0200_Server_Databases AS lsd
    LEFT JOIN inserted AS i
    ON lsd.LNK_FK_0100_ID = i.LNK_FK_0100_ID
    AND lsd.LNK_FK_0200_ID = i.LNK_FK_0200_ID
	AND lsd.LNK_db_Rank = i.LNK_db_Rank
    WHERE lsd.LNK_Term_Date >= getdate()
    AND (i.LNK_FK_0100_ID IS NULL
	OR i.LNK_FK_0200_ID IS NULL)

	/* Reconfigured from an earlier EXCEPT methodology with CTE. Much faster performance for larger inserts.
		Would work fine here due to low volume. Ultimtely - a code-thrifty way to achieve the same result.
		I prefer consistent methodology, and EXCEPT statements are NOT performant at high volume. */

    INSERT INTO CAT.LNK_0100_0200_Server_Databases (LNK_FK_0100_ID, LNK_FK_0200_ID, LNK_db_Rank)

    SELECT i.LNK_FK_0100_ID, i.LNK_FK_0200_ID, i.LNK_db_Rank
	FROM inserted AS i
	LEFT JOIN CAT.LNK_0100_0200_Server_Databases AS lsd
	ON lsd.LNK_FK_0100_ID = i.LNK_FK_0100_ID
	AND lsd.LNK_FK_0200_ID = i.LNK_FK_0200_ID
	AND lsd.LNK_db_Rank = i.LNK_db_Rank
	AND lsd.LNK_Term_Date >= getdate()
	WHERE lsd.LNK_T2_ID IS NULL
END