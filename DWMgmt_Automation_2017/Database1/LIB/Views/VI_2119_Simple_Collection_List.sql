

CREATE VIEW [LIB].[VI_2119_Simple_Collection_List]
AS

 WITH Recursive_Collections (Collection_ID, Name, Description)
AS (
	SELECT DISTINCT RK.Collection_ID
	, RK.Name
	, RK.Description
	FROM LIB.HSH_Collection_Hierarchy AS hsh WITH(NOLOCK)
	JOIN LIB.REG_Collections AS rk WITH(NOLOCK)
	ON RK.Collection_ID = hsh.rk_Collection_ID
	WHERE GETDATE() BETWEEN hsh.Post_Date AND hsh.Term_Date
	)

, Subordinate_Collections (Link_Type, Rk_Collection_ID, Collection_ID, Name, Description)
AS (
	SELECT DISTINCT hsh.Link_Type
	, hsh.rk_Collection_ID
	, FK.Collection_ID
	, FK.Name
	, FK.Description
	FROM LIB.HSH_Collection_Hierarchy AS hsh WITH(NOLOCK)
	JOIN LIB.REG_Collections AS FK WITH(NOLOCK)
	ON FK.Collection_ID = hsh.Fk_Collection_ID
	WHERE GETDATE() BETWEEN hsh.Post_Date AND hsh.Term_Date
	)


/* Review of Primary Collection. */
SELECT DISTINCT cast(prt.Collection_ID as varchar)+'.'+cast(sub.Fk_Collection_ID as varchar) AS Collection_Key
, prt.Name AS Parent_Collection
, sub.Name AS Subordinate_Collection
, sub.Link_Type
, sub.Description as Collection_Description
, CASE WHEN sub.Link_Type = 0 THEN 'Parent - This is the most fundamental collection in a Hierarchy. This may be identified by a Referenced, or Lateral link.' 
	WHEN sub.Link_Type = 1THEN 'Direct - This collection is a direct and/or primary subordinate of the parent.'
	WHEN sub.Link_Type = 2 THEN 'Lateral - This collection is subordiante to the indicated parent, but is not a direct branch.'
	WHEN sub.Link_Type = 3 THEN 'Referenced - This collection has attested references via code under the parent collection.'
	WHEN sub.Link_Type = 4 THEN 'Theoretical - This collection has a high degree of qualified common values, a potential resource for reporting.'
	ELSE 'Other' END AS Link_Type_Description
FROM Recursive_Collections AS prt
JOIN (
	SELECT DISTINCT RANK() OVER (PARTITION BY subI.Rk_Collection_ID ORDER BY subI.Collection_ID, subII.Collection_ID) AS Node_Set
	, subI.Collection_ID as Rk_Collection_ID
	, subII.Collection_ID as Fk_Collection_ID
	, subI.Name as Rk_Name
	, subII.Description
	, subII.Name
	, subII.Link_Type
	FROM Subordinate_Collections AS subI
	CROSS APPLY Subordinate_Collections AS subII
	WHERE subII.rk_Collection_ID = subI.Collection_ID
	) as sub
ON sub.Rk_Collection_ID = prt.Collection_ID