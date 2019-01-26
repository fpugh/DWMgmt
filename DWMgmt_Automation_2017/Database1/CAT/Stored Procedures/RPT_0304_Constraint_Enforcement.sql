

CREATE PROCEDURE [CAT].[RPT_0304_Constraint_Enforcement]
@NamePart NVARCHAR(4000) = N'ALL'
, @ExactName BIT = 0

AS

SELECT V200.Fully_Qualified_Name
, count(distinct V200.REG_Column_Name) as Table_Column_Count
, count(distinct V344.REG_Column_Name) as Constraint_Column_Count
, CASE WHEN count(distinct V200.REG_Column_Name) = 0 OR count(distinct V344.REG_Column_Name) = 0 THEN 0
	ELSE count(distinct V344.REG_Column_Name) / cast(count(distinct V200.REG_Column_Name) as money)
	* (1 + sum(case when isnull(V344.REG_Constraint_Type,'') = 'D' then 1 else 0 end) * .0125) END AS Data_Integrity_Ratio
, COUNT(distinct V344.REG_Constraint_Name) as Constraint_Count
FROM CAT.VI_0344_Constraint_Column_Latches AS V344 WITH(NOLOCK)
JOIN CAT.VI_0200_Column_Tier_Latches AS V200 WITH(NOLOCK)
ON V200.LNK_T3_ID = V344.LNK_T3P_ID
WHERE (@ExactName = 0 AND (@NamePart = 'ALL'
OR CHARINDEX(REPLACE(REPLACE(v200.Fully_Qualified_Name,'[',''),']',''), ''+@NamePart+'') > 0 
OR CHARINDEX(''+@NamePart+'', REPLACE(REPLACE(v200.Fully_Qualified_Name,'[',''),']','')) > 0)
OR (@ExactName = 1 AND @NamePart = REPLACE(REPLACE(v200.Fully_Qualified_Name,'[',''),']','')))
GROUP BY V200.Fully_Qualified_Name