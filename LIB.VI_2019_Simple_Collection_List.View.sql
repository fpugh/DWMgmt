USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[VI_2019_Simple_Collection_List]'))
DROP VIEW [LIB].[VI_2019_Simple_Collection_List]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[VI_2019_Simple_Collection_List]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [LIB].[VI_2019_Simple_Collection_List]
AS

 WITH Recursive_Collections (Collection_ID, Name, Description)
AS (
	SELECT DISTINCT RK.Collection_ID, RK.Name, RK.Description
	FROM LIB.HSH_Collection_Heirarchy AS hsh WITH(NOLOCK)
	JOIN LIB.REG_Collections AS rk WITH(NOLOCK)
	ON RK.Collection_ID = hsh.rk_Collection_ID
	WHERE GETDATE() BETWEEN hsh.Post_Date AND hsh.Term_Date
	)

, Subordinate_Collections (Rk_Collection_ID, Collection_ID, Name, Description)
AS (
	SELECT DISTINCT hsh.rk_Collection_ID, FK.Collection_ID, FK.Name, FK.Description
	FROM LIB.HSH_Collection_Heirarchy AS hsh WITH(NOLOCK)
	JOIN LIB.REG_Collections AS FK WITH(NOLOCK)
	ON FK.Collection_ID = hsh.Fk_Collection_ID
	WHERE GETDATE() BETWEEN hsh.Post_Date AND hsh.Term_Date
	)


/* Review of Primary Collection. */
SELECT DISTINCT cast(prt.Collection_ID as varchar)+''.''+cast(sub.Fk_Collection_ID as varchar) AS Collection_Code
, prt.Name AS Parent_Collection, sub.Name AS Subordinate_Collection, sub.Description as Collection_Description
FROM Recursive_Collections AS prt
JOIN (
	SELECT DISTINCT RANK() OVER (PARTITION BY subI.Rk_Collection_ID ORDER BY subI.Collection_ID, subII.Collection_ID) AS Node_Set
	, subI.Collection_ID as Rk_Collection_ID, subII.Collection_ID as Fk_Collection_ID
	, subI.Name as Rk_Name, subII.Description, subII.Name
	FROM Subordinate_Collections AS subI
	CROSS APPLY Subordinate_Collections AS subII
	WHERE subII.rk_Collection_ID = subI.Collection_ID
	--ORDER BY subI.Collection_ID, NodeSet, subII.Collection_ID
	) as sub
ON sub.Rk_Collection_ID = prt.Collection_ID
' 
GO
