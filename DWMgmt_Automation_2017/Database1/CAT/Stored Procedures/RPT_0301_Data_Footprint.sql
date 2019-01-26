

CREATE PROCEDURE [CAT].[RPT_0301_Data_Footprint]
@NamePart NVARCHAR(4000) = N'ALL'
, @TierLevel TINYINT = 0
, @ExactName BIT = 0

AS

SELECT CASE WHEN @TierLevel = 1 THEN REG_Database_Name
	WHEN @TierLevel = 2 THEN REG_Database_Name+'.'+REG_Schema_Name
	WHEN @TierLevel = 3 THEN REG_Database_Name+'.'+REG_Schema_Name+'.'+REG_Object_Name
	WHEN @TierLevel = 4 THEN REG_Database_Name+'.'+REG_Schema_Name+'.'+REG_Object_Name+'.'+REG_Column_Name
	ELSE REG_Server_Name END AS Target_Name
, Column_Definition
, CASE WHEN REG_Column_Type in (36) then 'GUID'
	WHEN REG_Column_Type in (56,127) then 'Integer 16.32'
	WHEN REG_Column_Type in (48,52,104) then 'Integer 2.4.8'
	WHEN REG_Column_Type in (60,106,108,122) then 'Precise Numeric'
	WHEN REG_Column_Type in (59,62) then 'Non-precise Numeric'
	WHEN REG_Column_Type in (40, 41, 43) then 'Date or Time'
	WHEN REG_Column_Type in (42,58,61) then 'Precise Datetime'
	WHEN REG_Column_Type in (175,239) then 'Precise String'
	WHEN REG_Column_Type in (167,231) then 'Variable String'
	WHEN REG_Column_Type in (35,99) then 'Large Text'
	ELSE 'Other Type' END AS Data_Class
, COUNT(isnull(REG_Column_Name,0)) AS Column_Count
FROM CAT.VI_0300_Full_Object_Map AS V300 WITH(NOLOCK)
WHERE (@ExactName = 0 AND (@NamePart = 'ALL'
OR CHARINDEX(REPLACE(REPLACE(V300.Fully_Qualified_Name,'[',''),']',''), ''+@NamePart+'') > 0 
OR CHARINDEX(''+@NamePart+'', REPLACE(REPLACE(V300.Fully_Qualified_Name,'[',''),']','')) > 0)
OR (@ExactName = 1 AND @NamePart = REPLACE(REPLACE(V300.Fully_Qualified_Name,'[',''),']','')))
GROUP BY CASE WHEN @TierLevel = 1 THEN REG_Database_Name
	WHEN @TierLevel = 2 THEN REG_Database_Name+'.'+REG_Schema_Name
	WHEN @TierLevel = 3 THEN REG_Database_Name+'.'+REG_Schema_Name+'.'+REG_Object_Name
	WHEN @TierLevel = 4 THEN REG_Database_Name+'.'+REG_Schema_Name+'.'+REG_Object_Name+'.'+REG_Column_Name
	ELSE REG_Server_Name END
, Column_Definition
, CASE WHEN REG_Column_Type in (36) then 'GUID'
	WHEN REG_Column_Type in (56,127) then 'Integer 16.32'
	WHEN REG_Column_Type in (48,52,104) then 'Integer 2.4.8'
	WHEN REG_Column_Type in (60,106,108,122) then 'Precise Numeric'
	WHEN REG_Column_Type in (59,62) then 'Non-precise Numeric'
	WHEN REG_Column_Type in (40, 41, 43) then 'Date or Time'
	WHEN REG_Column_Type in (42,58,61) then 'Precise Datetime'
	WHEN REG_Column_Type in (175,239) then 'Precise String'
	WHEN REG_Column_Type in (167,231) then 'Variable String'
	WHEN REG_Column_Type in (35,99) then 'Large Text'
	ELSE 'Other Type' END