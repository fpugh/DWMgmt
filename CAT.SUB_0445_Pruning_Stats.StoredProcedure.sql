USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[SUB_0445_Pruning_Stats]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[SUB_0445_Pruning_Stats]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[SUB_0445_Pruning_Stats]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/* Make this part of a maintenance function - MP_XXX_Table_Grooming 
	This collects a list of statistics to drop from an import of scan data.
	Only those items with a clean overlap are selected (a!=b:b!=a;a=c|c).
*/

CREATE PROCEDURE [CAT].[SUB_0445_Pruning_Stats]
AS
SELECT ST1.TRK_Server_Name, ST1.TRK_Database_Name
, ''USE ['' + ST1.TRK_Database_Name + '']
DROP STATISTICS ['' + ST1.TRK_Object_Name
+ ''].['' + ST1.TRK_Column_Name + ''].[''
+ ST2.TRK_Stats_Name + '']'' as SQL_String
FROM TMP.TRK_0440_Column_Statistics AS ST1 WITH(NOLOCK)
JOIN TMP.TRK_0440_Column_Statistics AS ST2 WITH(NOLOCK)
ON ST1.TRK_Object_ID = ST2.TRK_Object_ID
AND ST1.TRK_Column_ID = ST2.TRK_Column_ID
AND ST1.TRK_Stats_ID != ST2.TRK_Stats_ID
WHERE ST1.TRK_Column_ID = 1
AND ST1.TRK_Auto_created = 0
--EXCEPT
--SELECT ST1.TRK_Server_Name, ST1.TRK_Database_Name
--, ''USE ['' + ST1.TRK_Database_Name + '']
--DROP STATISTICS ['' + ST1.TRK_Object_Name
--+ ''].['' + ST1.TRK_Column_Name + ''].[''
--+ ST1.TRK_Stats_Name + '']''
--FROM TMP.TRK_0440_Column_Statistics AS ST1 WITH(NOLOCK)
--JOIN TMP.TRK_0440_Column_Statistics AS ST2 WITH(NOLOCK)
--ON ST1.TRK_Object_ID = ST2.TRK_Object_ID
--AND ST1.TRK_Column_ID = ST2.TRK_Column_ID
--AND ST1.TRK_Stats_ID != ST2.TRK_Stats_ID
--WHERE ST1.TRK_Column_ID = 1
--AND ST1.TRK_Auto_created = 0
--GO
' 
END
GO
