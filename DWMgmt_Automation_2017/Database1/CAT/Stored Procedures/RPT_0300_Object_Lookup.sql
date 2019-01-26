

CREATE PROCEDURE [CAT].[RPT_0300_Object_Lookup]
@NamePart nvarchar(4000) = N'ALL'
, @ExactName BIT = 0

AS

SELECT DISTINCT Fully_Qualified_Name, Schema_Bound_Name
, REG_Server_Name, REG_Database_Name, REG_Schema_Name, REG_Object_Name, REG_Object_Type
, REG_Column_Rank, REG_Column_Name, Column_Definition
FROM CAT.VI_0300_Full_Object_Map AS V300 WITH(NOLOCK)
WHERE (@ExactName = 0 AND (@NamePart = 'ALL'
OR CHARINDEX(REPLACE(REPLACE(V300.Fully_Qualified_Name,'[',''),']',''), ''+@NamePart+'') > 0 
OR CHARINDEX(''+@NamePart+'', REPLACE(REPLACE(V300.Fully_Qualified_Name,'[',''),']','')) > 0)
OR (@ExactName = 1 AND @NamePart = REPLACE(REPLACE(V300.Fully_Qualified_Name,'[',''),']','')))
AND REG_Object_Type IN ('V','U')