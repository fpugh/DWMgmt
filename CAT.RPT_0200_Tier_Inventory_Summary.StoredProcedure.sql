USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[RPT_0200_Tier_Inventory_Summary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[RPT_0200_Tier_Inventory_Summary]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[RPT_0200_Tier_Inventory_Summary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [CAT].[RPT_0200_Tier_Inventory_Summary]
@NamePart nvarchar(4000) = N''ALL''
, @TierLevel tinyint = 0
, @ExactName BIT = 0

AS

SELECT CASE WHEN @TierLevel = 1 THEN REG_Database_Name
	WHEN @TierLevel = 2 THEN REG_Database_Name+''.''+REG_Schema_Name
	WHEN @TierLevel = 3 THEN REG_Database_Name+''.''+REG_Schema_Name+''.''+REG_Object_Name
	WHEN @TierLevel = 4 THEN REG_Database_Name+''.''+REG_Schema_Name+''.''+REG_Object_Name+''.''+REG_Column_Name
	ELSE REG_Server_Name END AS Target_Name
, COUNT(distinct REG_Database_Name) as Database_Count
, COUNT(distinct REG_Schema_Name) as Schema_Count
, COUNT(distinct REG_Object_Name) as Object_Count
, COUNT(distinct REG_Column_Name) as Column_Count
FROM CAT.VI_0300_Full_Object_Map AS v300 WITH(NOLOCK)
WHERE (@ExactName = 0 AND (@NamePart = ''ALL''
		OR CHARINDEX(v300.Fully_Qualified_Name, ''''+@NamePart+'''') > 0 
		OR CHARINDEX(''''+@NamePart+'''', v300.Fully_Qualified_Name) > 0)
OR (@ExactName = 1 AND @NamePart = v300.Fully_Qualified_Name))
GROUP BY CASE WHEN @TierLevel = 1 THEN REG_Database_Name
	WHEN @TierLevel = 2 THEN REG_Database_Name+''.''+REG_Schema_Name
	WHEN @TierLevel = 3 THEN REG_Database_Name+''.''+REG_Schema_Name+''.''+REG_Object_Name
	WHEN @TierLevel = 4 THEN REG_Database_Name+''.''+REG_Schema_Name+''.''+REG_Object_Name+''.''+REG_Column_Name
	ELSE REG_Server_Name END
' 
END
GO
