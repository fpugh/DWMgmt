USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[RPT_0301_Data_Footprint]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[RPT_0301_Data_Footprint]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[RPT_0301_Data_Footprint]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [CAT].[RPT_0301_Data_Footprint]
@NamePart NVARCHAR(4000) = N''ALL''
, @TierLevel TINYINT = 0
, @ExactName BIT = 0

AS

SELECT CASE WHEN @TierLevel = 1 THEN REG_Database_Name
	WHEN @TierLevel = 2 THEN REG_Database_Name+''.''+REG_Schema_Name
	WHEN @TierLevel = 3 THEN REG_Database_Name+''.''+REG_Schema_Name+''.''+REG_Object_Name
	WHEN @TierLevel = 4 THEN REG_Database_Name+''.''+REG_Schema_Name+''.''+REG_Object_Name+''.''+REG_Column_Name
	ELSE REG_Server_Name END AS Target_Name
, Column_Definition
, CASE WHEN REG_Column_Type in (36) then 1
	WHEN REG_Column_Type in (56,127) then 2
	WHEN REG_Column_Type in (48,52,104) then 3
	WHEN REG_Column_Type in (60,106,108,122) then 4
	WHEN REG_Column_Type in (59,62) then 5
	WHEN REG_Column_Type in (40, 41, 43) then 6
	WHEN REG_Column_Type in (42,58,61) then 7
	WHEN REG_Column_Type in (175,239) then 8
	WHEN REG_Column_Type in (167,231) then 9
	WHEN REG_Column_Type in (35,99) then 10
	ELSE 11 END AS Data_Class
, COUNT(isnull(REG_Column_Name,0)) AS Column_Count
FROM CAT.VI_0300_Full_Object_Map AS V300 WITH(NOLOCK)
WHERE (@ExactName = 0 AND (@NamePart = ''ALL''
	OR CHARINDEX(v300.Fully_Qualified_Name, ''''+@NamePart+'''') > 0 
	OR CHARINDEX(''''+@NamePart+'''', v300.Fully_Qualified_Name) > 0)
OR (@ExactName = 1 AND @NamePart = v300.Fully_Qualified_Name))
GROUP BY CASE WHEN @TierLevel = 1 THEN REG_Database_Name
	WHEN @TierLevel = 2 THEN REG_Database_Name+''.''+REG_Schema_Name
	WHEN @TierLevel = 3 THEN REG_Database_Name+''.''+REG_Schema_Name+''.''+REG_Object_Name
	WHEN @TierLevel = 4 THEN REG_Database_Name+''.''+REG_Schema_Name+''.''+REG_Object_Name+''.''+REG_Column_Name
	ELSE REG_Server_Name END
, Column_Definition
, CASE WHEN REG_Column_Type in (36) then 1
	WHEN REG_Column_Type in (56,127) then 2
	WHEN REG_Column_Type in (48,52,104) then 3
	WHEN REG_Column_Type in (60,106,108,122) then 4
	WHEN REG_Column_Type in (59,62) then 5
	WHEN REG_Column_Type in (40, 41, 43) then 6
	WHEN REG_Column_Type in (42,58,61) then 7
	WHEN REG_Column_Type in (175,239) then 8
	WHEN REG_Column_Type in (167,231) then 9
	WHEN REG_Column_Type in (35,99) then 10
	ELSE 11 END
' 
END
GO
