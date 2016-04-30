USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[RPT_0354_Data_Quality_Overview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[RPT_0354_Data_Quality_Overview]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[RPT_0354_Data_Quality_Overview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [CAT].[RPT_0354_Data_Quality_Overview]
@NamePart nvarchar(4000) = N''ALL''
, @IncludeViews BIT = 0
, @TierLevel TINYINT = 3
, @ExactName BIT = 0

AS

DECLARE @ObjectSet NVARCHAR(65)

SET @ObjectSet = CASE WHEN @IncludeViews = 0 THEN ''U'' ELSE ''U,V'' END

SELECT CASE WHEN @TierLevel = 1 THEN REG_Database_Name
	WHEN @TierLevel = 2 THEN REG_Database_Name+''.''+REG_Schema_Name
	WHEN @TierLevel = 3 THEN REG_Database_Name+''.''+REG_Schema_Name+''.''+REG_Object_Name
	WHEN @TierLevel = 4 THEN REG_Database_Name+''.''+REG_Schema_Name+''.''+REG_Object_Name+''.''+REG_Column_Name
	ELSE REG_Server_Name END AS Target_Name
, isnull(avg(trk.TRK_Uniqueness), 0) as Avg_Uniqueness
, isnull(stdev(trk.TRK_Uniqueness), 0) as StdDev_Uniqueness
, isnull(count(distinct trk.TRK_Post_Date), 0) as Scan_Count
, isnull(min(trk.TRK_Post_Date), 0) as First_Scan
, isnull(max(trk.TRK_Post_Date), 0) as Last_Scan
FROM CAT.VI_0200_Column_Tier_Latches AS V200 WITH(NOLOCK)
LEFT JOIN CAT.TRK_0454_Column_Metrics AS trk WITH(NOLOCK)
ON V200.LNK_T4_ID = trk.TRK_FK_T4_ID
WHERE CHARINDEX(REG_Object_Type, @ObjectSet) > 0
AND (@ExactName = 0 AND (@NamePart = ''ALL''
	OR CHARINDEX(v200.Fully_Qualified_Name, ''''+@NamePart+'''') > 0 
	OR CHARINDEX(''''+@NamePart+'''', v200.Fully_Qualified_Name) > 0)
OR (@ExactName = 1 AND @NamePart = v200.Fully_Qualified_Name))
GROUP BY CASE WHEN @TierLevel = 1 THEN REG_Database_Name
	WHEN @TierLevel = 2 THEN REG_Database_Name+''.''+REG_Schema_Name
	WHEN @TierLevel = 3 THEN REG_Database_Name+''.''+REG_Schema_Name+''.''+REG_Object_Name
	WHEN @TierLevel = 4 THEN REG_Database_Name+''.''+REG_Schema_Name+''.''+REG_Object_Name+''.''+REG_Column_Name
	ELSE REG_Server_Name END
' 
END
GO
