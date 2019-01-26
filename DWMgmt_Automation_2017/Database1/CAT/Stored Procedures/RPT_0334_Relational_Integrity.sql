

CREATE PROCEDURE [CAT].[RPT_0334_Relational_Integrity]
@NamePart NVARCHAR(4000) = N'ALL'
, @ExactName BIT = 0

AS

/* RI value of the source table - Links FROM this table TO other tables */

SELECT v200.Fully_Qualified_Name
, 'Referencing' AS Relational_Vector
, count(distinct v200.LNK_T4_ID) as Table_Column_Count
, count(distinct v345.LNK_T4P_ID) as Relational_Column_Count
, CASE WHEN count(distinct v200.LNK_T4_ID) = 0 OR count(distinct v345.LNK_T4P_ID) = 0 THEN 0
	ELSE count(distinct v345.LNK_T4P_ID) / cast(count(distinct v200.LNK_T4_ID) as money) END AS Relational_Integrity_Ratio
, COUNT(distinct V345.REG_Foreign_Key_Name) as Foreign_Key_Count
FROM CAT.VI_0345_Foreign_Key_Column_Latches AS V345 WITH(NOLOCK)
LEFT JOIN CAT.VI_0300_Full_Object_Map AS V200 WITH(NOLOCK)
ON V200.LNK_T2_ID = V345.LNK_T2_ID
AND V200.LNK_T3_ID = V345.LNK_T3P_ID
WHERE (@ExactName = 0 AND (@NamePart = 'ALL'
OR CHARINDEX(REPLACE(REPLACE(v200.Fully_Qualified_Name,'[',''),']',''), ''+@NamePart+'') > 0 
OR CHARINDEX(''+@NamePart+'', REPLACE(REPLACE(v200.Fully_Qualified_Name,'[',''),']','')) > 0)
OR (@ExactName = 1 AND @NamePart = REPLACE(REPLACE(v200.Fully_Qualified_Name,'[',''),']','')))
GROUP BY V345.REG_Foreign_Key_Name, v200.Fully_Qualified_Name

UNION

/* RI value of the source table - Links TO this table FROM other tables */

SELECT v200.Fully_Qualified_Name
, 'Referenced' AS Relational_Vector
, count(distinct v200.LNK_T4_ID) as Table_Column_Count
, count(distinct v345.LNK_T4R_ID) as Relational_Column_Count
, CASE WHEN count(distinct v200.LNK_T4_ID) = 0 OR count(distinct v345.LNK_T4R_ID) = 0 THEN 0
	ELSE count(distinct v345.LNK_T4R_ID) / cast(count(distinct v200.LNK_T4_ID) as money) END AS Relational_Integrity_Ratio
, count(distinct V345.REG_Foreign_Key_Name) as Foreign_Key_Count
FROM CAT.VI_0345_Foreign_Key_Column_Latches AS V345 WITH(NOLOCK)
LEFT JOIN CAT.VI_0300_Full_Object_Map AS V200 WITH(NOLOCK)
ON V200.LNK_T2_ID = V345.LNK_T2_ID
AND V200.LNK_T3_ID = V345.LNK_T3R_ID
WHERE (@ExactName = 0 AND (@NamePart = 'ALL'
OR CHARINDEX(REPLACE(REPLACE(v200.Fully_Qualified_Name,'[',''),']',''), ''+@NamePart+'') > 0 
OR CHARINDEX(''+@NamePart+'', REPLACE(REPLACE(v200.Fully_Qualified_Name,'[',''),']','')) > 0)
OR (@ExactName = 1 AND @NamePart = REPLACE(REPLACE(v200.Fully_Qualified_Name,'[',''),']','')))
GROUP BY v200.Fully_Qualified_Name