CREATE TABLE [LIB].[HSH_Collection_Rules] (
    [HASH_ID]         INT             IDENTITY (1, 1) NOT NULL,
    [Collection_ID]   INT             NOT NULL,
    [Rule_ID]         INT             NOT NULL,
    [Rule_Rank]       SMALLINT        CONSTRAINT [DF_Rule_Rank] DEFAULT ((0)) NOT NULL,
    [Rule_Value_Type] NVARCHAR (128)  NOT NULL,
    [Rule_Value]      NVARCHAR (4000) NOT NULL,
    [Post_Date]       DATETIME        CONSTRAINT [DF_HSH_Rules_Post] DEFAULT (getdate()) NOT NULL,
    [Term_Date]       DATETIME        CONSTRAINT [DF_HSH_Rules_Term] DEFAULT ('12/31/2099') NOT NULL,
    [Use_Count]       INT             DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_LIB_CR] PRIMARY KEY CLUSTERED ([Collection_ID] ASC, [Rule_ID] ASC, [Rule_Rank] ASC, [Post_Date] ASC),
    CONSTRAINT [FK_CR_REG_Collections] FOREIGN KEY ([Collection_ID]) REFERENCES [LIB].[REG_Collections] ([Collection_ID]),
    CONSTRAINT [FK_CR_REG_Rules] FOREIGN KEY ([Rule_ID]) REFERENCES [LIB].[REG_Rules] ([Rule_ID]),
    CONSTRAINT [UQ_CR_Hash_ID] UNIQUE NONCLUSTERED ([HASH_ID] ASC)
);


GO


CREATE TRIGGER [LIB].[Collection_Rules_Insert]
ON  [LIB].[HSH_Collection_Rules]
INSTEAD OF INSERT
AS 

BEGIN

	/* Terminates old rule values
		Updates the collection hash table with the current value.
	*/

    UPDATE hcr SET Term_Date = getdate()
    FROM LIB.HSH_Collection_Rules AS hcr
    LEFT JOIN inserted AS i
    ON hcr.Collection_ID = i.Collection_ID
	AND hcr.Rule_Value = i.Rule_Value
	AND hcr.Rule_Rank = i.Rule_Rank
    WHERE hcr.Term_Date >= getdate()
    AND hcr.Rule_ID = i.Rule_ID
	AND i.Use_Count IS NULL


	INSERT INTO LIB.HSH_Collection_Rules (Collection_ID, Rule_ID, Rule_Rank, Rule_Value_Type, Rule_Value)
	SELECT Collection_ID, Rule_ID, Rule_Rank, Rule_Value_Type, Rule_Value
	FROM Inserted
	EXCEPT
	SELECT Collection_ID, Rule_ID, Rule_Rank, Rule_Value_Type, Rule_Value
	FROM LIB.HSH_Collection_Rules
	WHERE getdate() <= Term_Date

END