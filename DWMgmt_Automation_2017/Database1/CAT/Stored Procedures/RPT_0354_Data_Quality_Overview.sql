

CREATE PROCEDURE [CAT].[RPT_0354_Data_Quality_Overview]
@NamePart nvarchar(4000) = N'ALL'
, @TierLevel tinyint = 0
, @ExactName BIT = 0

AS

SELECT CASE WHEN @TierLevel = 1 THEN REG_Database_Name
	WHEN @TierLevel = 2 THEN REG_Database_Name+'.'+REG_Schema_Name
	WHEN @TierLevel = 3 THEN REG_Database_Name+'.'+REG_Schema_Name+'.'+REG_Object_Name
	WHEN @TierLevel = 4 THEN REG_Database_Name+'.'+REG_Schema_Name+'.'+REG_Object_Name+'.'+REG_Column_Name
	ELSE REG_Server_Name END AS Target_Name
, isnull(avg(trk.TRK_Uniqueness), 0) as Avg_Uniqueness
, isnull(stdev(trk.TRK_Uniqueness), 0) as StdDev_Uniqueness
, isnull(count(distinct trk.TRK_Post_Date), 0) as Scan_Count
, isnull(min(trk.TRK_Post_Date), 0) as First_Scan
, isnull(max(trk.TRK_Post_Date), 0) as Last_Scan
FROM CAT.VH_0200_Column_Tier_Latches AS V200 WITH(NOLOCK)
LEFT JOIN CAT.TRK_0454_Column_Metrics AS trk WITH(NOLOCK)
ON V200.LNK_T4_ID = trk.TRK_FK_T4_ID
WHERE REG_Object_Type = 'U'
AND (@ExactName = 0 AND (@NamePart = 'ALL'
OR CHARINDEX(REPLACE(REPLACE(v200.Fully_Qualified_Name,'[',''),']',''), ''+@NamePart+'') > 0 
OR CHARINDEX(''+@NamePart+'', REPLACE(REPLACE(v200.Fully_Qualified_Name,'[',''),']','')) > 0)
OR (@ExactName = 1 AND @NamePart = REPLACE(REPLACE(v200.Fully_Qualified_Name,'[',''),']','')))
GROUP BY CASE WHEN @TierLevel = 1 THEN REG_Database_Name
	WHEN @TierLevel = 2 THEN REG_Database_Name+'.'+REG_Schema_Name
	WHEN @TierLevel = 3 THEN REG_Database_Name+'.'+REG_Schema_Name+'.'+REG_Object_Name
	WHEN @TierLevel = 4 THEN REG_Database_Name+'.'+REG_Schema_Name+'.'+REG_Object_Name+'.'+REG_Column_Name
	ELSE REG_Server_Name END