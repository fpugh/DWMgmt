CREATE TABLE [LIB].[HSH_Collection_Hierarchy] (
    [Hash_ID]          INT      IDENTITY (1, 1) NOT NULL,
    [Link_Type]        TINYINT  CONSTRAINT [DF_HCH_Flag_Default] DEFAULT ((0)) NOT NULL,
    [RK_Collection_ID] INT      CONSTRAINT [DF_HCH_RkID_Default] DEFAULT ((0)) NOT NULL,
    [FK_Collection_ID] INT      CONSTRAINT [DF_HCH_FkID_Default] DEFAULT ((0)) NOT NULL,
    [Post_Date]        DATETIME CONSTRAINT [DF_HCH_Post_Default] DEFAULT (getdate()) NOT NULL,
    [Term_Date]        DATETIME CONSTRAINT [DF_HCH_Term_Default] DEFAULT ('12/31/2099') NOT NULL,
    [Use_Count]        INT      CONSTRAINT [DF_HCH_Count_Base] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_LNK_Collections] PRIMARY KEY NONCLUSTERED ([Link_Type] ASC, [RK_Collection_ID] ASC, [FK_Collection_ID] ASC),
    CONSTRAINT [CK_HCH_Flag_Values] CHECK ([Link_Type]=(5) OR [Link_Type]=(4) OR [Link_Type]=(3) OR [Link_Type]=(2) OR [Link_Type]=(1) OR [Link_Type]=(0)),
    CONSTRAINT [FK_HSH_FK_CollectionsID] FOREIGN KEY ([FK_Collection_ID]) REFERENCES [LIB].[REG_Collections] ([Collection_ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_HSH_RK_CollectionsID] FOREIGN KEY ([RK_Collection_ID]) REFERENCES [LIB].[REG_Collections] ([Collection_ID]),
    CONSTRAINT [UQ_HSH_Collection_ID] UNIQUE NONCLUSTERED ([Hash_ID] ASC)
);


GO


CREATE TRIGGER [LIB].[Collection_Hierarchy_Insert]
ON  [LIB].[HSH_Collection_Hierarchy]
INSTEAD OF INSERT
AS 

BEGIN

	/* Inserts unique code blocks into the HSH_Collection_Hierarchy Table
		Updates the collection hash table with the current use count.
	*/

	INSERT INTO LIB.HSH_Collection_Hierarchy (Link_Type, RK_Collection_ID, FK_Collection_ID)
	SELECT Link_Type, RK_Collection_ID, FK_Collection_ID
	FROM Inserted
	EXCEPT
	SELECT Link_Type, RK_Collection_ID, FK_Collection_ID
	FROM LIB.HSH_Collection_Hierarchy

	UPDATE hsh SET Use_Count = hsh.Use_Count + ins.Use_Count
	FROM LIB.HSH_Collection_Hierarchy AS hsh
	JOIN Inserted AS ins
	ON ins.Link_Type = hsh.Link_Type
	AND ins.RK_Collection_ID = hsh.RK_Collection_ID
	AND ins.FK_Collection_ID = hsh.FK_Collection_ID

END