USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[RPT_0300_Object_Lookup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[RPT_0300_Object_Lookup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[RPT_0300_Object_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [CAT].[RPT_0300_Object_Lookup]
@NamePart nvarchar(4000) = N''ALL''
, @ExactName BIT = 0

AS

SELECT DISTINCT Fully_Qualified_Name, Schema_Bound_Name
, REG_Server_Name, REG_Database_Name, REG_Schema_Name, REG_Object_Name, REG_Object_Type
, Column_Rank, REG_Column_Name, Column_Definition
FROM CAT.VI_0300_Full_Object_Map AS V300 WITH(NOLOCK)
WHERE (@ExactName = 0 AND (@NamePart = ''ALL''
	OR CHARINDEX(V300.Fully_Qualified_Name, ''''+@NamePart+'''') > 0 
	OR CHARINDEX(''''+@NamePart+'''', V300.Fully_Qualified_Name) > 0)
OR (@ExactName = 1 AND @NamePart = V300.Fully_Qualified_Name))
AND REG_Object_Type IN (''V'',''U'')
' 
END
GO
