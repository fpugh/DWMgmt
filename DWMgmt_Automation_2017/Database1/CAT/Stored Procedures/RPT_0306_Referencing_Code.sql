

CREATE PROCEDURE [CAT].[RPT_0306_Referencing_Code]
@NamePart NVARCHAR(256)
, @ExactName BIT = 0

AS

SELECT REG_Object_Name, REG_Object_Type
, DENSE_Rank() OVER(PARTITION BY dbr.REG_Database_Name, dbs.REG_Schema_Name, REG_Object_Name
	ORDER BY COUNT(DISTINCT lnk.LNK_OCS_ID) DESC) as Line_References
/* Acquire utilization counts for procedures from system execution logs, external surveilance sources, etc. */
--, sum(executions) as Utilizations
FROM CAT.LNK_0100_0200_Server_Databases AS srv WITH(NOLOCK)
JOIN CAT.LNK_0204_0300_Schema_Binding AS scm WITH(NOLOCK)
ON scm.LNK_FK_T2_ID = srv.LNK_T2_ID
JOIN CAT.LNK_0300_0600_Object_Code_Sections AS lnk WITH(NOLOCK)
ON lnk.LNK_FK_T3_ID = scm.LNK_T3_ID
JOIN CAT.REG_0200_Database_registry AS dbr WITH(NOLOCK)
ON dbr.REG_0200_ID = srv.LNK_FK_0200_ID
JOIN CAT.REG_0204_Database_Schemas AS dbs WITH(NOLOCK)
ON dbs.REG_0204_ID = scm.LNK_FK_0204_ID
JOIN CAT.REG_0300_Object_registry AS ror WITH(NOLOCK)
ON ror.REG_0300_ID = lnk.LNK_FK_0300_ID
JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
ON ocl.REG_0600_ID = lnk.LNK_FK_0600_ID
WHERE GETDATE() BETWEEN lnk.LNK_Post_Date AND lnk.LNK_Term_Date
AND (CHARINDEX('INTO', REG_Code_Content ) > 0
OR CHARINDEX('FROM', REG_Code_Content ) > 0
OR CHARINDEX('JOIN', REG_Code_Content ) > 0
OR CHARINDEX('APPLY', REG_Code_Content ) > 0)
AND ((@ExactName = 0 AND PATINDEX('%'+@NamePart+'%', REG_Code_Content) > 0)
OR (@ExactName = 1 AND PATINDEX('% '+@NamePart+' %', REG_Code_Content) > 0))
GROUP BY dbr.REG_Database_Name, dbs.REG_Schema_Name, REG_Object_Name, REG_Object_Type


/* ToDo: Create code utilization tracking. LineReferences will become secondary to Utilizations when available */