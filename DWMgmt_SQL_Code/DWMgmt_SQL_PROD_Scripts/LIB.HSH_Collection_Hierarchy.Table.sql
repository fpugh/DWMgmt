USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LIB].[HSH_Collection_Hierarchy](
	[Hash_ID] [int] IDENTITY(1,1) NOT NULL,
	[Link_Type] [tinyint] NOT NULL,
	[RK_Collection_ID] [int] NOT NULL,
	[FK_Collection_ID] [int] NOT NULL,
	[Post_Date] [datetime] NOT NULL,
	[Term_Date] [datetime] NOT NULL,
	[Use_Count] [int] NOT NULL,
 CONSTRAINT [PK_LNK_Collections] PRIMARY KEY NONCLUSTERED 
(
	[Link_Type] ASC,
	[RK_Collection_ID] ASC,
	[FK_Collection_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_HSH_Collection_ID] UNIQUE NONCLUSTERED 
(
	[Hash_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [LIB].[HSH_Collection_Hierarchy] ADD  CONSTRAINT [DF_HCH_Flag_Default]  DEFAULT ((0)) FOR [Link_Type]
GO
ALTER TABLE [LIB].[HSH_Collection_Hierarchy] ADD  CONSTRAINT [DF_HCH_RkID_Default]  DEFAULT ((0)) FOR [RK_Collection_ID]
GO
ALTER TABLE [LIB].[HSH_Collection_Hierarchy] ADD  CONSTRAINT [DF_HCH_FkID_Default]  DEFAULT ((0)) FOR [FK_Collection_ID]
GO
ALTER TABLE [LIB].[HSH_Collection_Hierarchy] ADD  CONSTRAINT [DF_HCH_Post_Default]  DEFAULT (getdate()) FOR [Post_Date]
GO
ALTER TABLE [LIB].[HSH_Collection_Hierarchy] ADD  CONSTRAINT [DF_HCH_Term_Default]  DEFAULT ('12/31/2099') FOR [Term_Date]
GO
ALTER TABLE [LIB].[HSH_Collection_Hierarchy] ADD  CONSTRAINT [DF_HCH_Count_Base]  DEFAULT ((0)) FOR [Use_Count]
GO
ALTER TABLE [LIB].[HSH_Collection_Hierarchy]  WITH CHECK ADD  CONSTRAINT [FK_HSH_FK_CollectionsID] FOREIGN KEY([FK_Collection_ID])
REFERENCES [LIB].[REG_Collections] ([Collection_ID])
GO
ALTER TABLE [LIB].[HSH_Collection_Hierarchy] CHECK CONSTRAINT [FK_HSH_FK_CollectionsID]
GO
ALTER TABLE [LIB].[HSH_Collection_Hierarchy]  WITH CHECK ADD  CONSTRAINT [FK_HSH_RK_CollectionsID] FOREIGN KEY([RK_Collection_ID])
REFERENCES [LIB].[REG_Collections] ([Collection_ID])
GO
ALTER TABLE [LIB].[HSH_Collection_Hierarchy] CHECK CONSTRAINT [FK_HSH_RK_CollectionsID]
GO
ALTER TABLE [LIB].[HSH_Collection_Hierarchy]  WITH CHECK ADD  CONSTRAINT [CK_HCH_Flag_Values] CHECK  (([Link_Type]=(5) OR [Link_Type]=(4) OR [Link_Type]=(3) OR [Link_Type]=(2) OR [Link_Type]=(1) OR [Link_Type]=(0)))
GO
ALTER TABLE [LIB].[HSH_Collection_Hierarchy] CHECK CONSTRAINT [CK_HCH_Flag_Values]
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
GO