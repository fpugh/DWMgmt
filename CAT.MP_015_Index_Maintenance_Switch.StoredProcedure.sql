USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_015_Index_Maintenance_Switch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[MP_015_Index_Maintenance_Switch]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_015_Index_Maintenance_Switch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [CAT].[MP_015_Index_Maintenance_Switch]
@ExecuteStatus TINYINT = 1
, @ModeId TINYINT = 1

AS

DECLARE @Index NVARCHAR(256) = ''''
, @Object NVARCHAR(256) = ''''
, @Database NVARCHAR(256) = ''''
, @DBInner NVARCHAR(256) = ''''
, @Operation NVARCHAR(256) = ''''
, @SQL NVARCHAR(MAX) = ''''


DECLARE IndexMaintainer CURSOR FOR
SELECT Index_Name, Schema_Bound_Name, ltrim(rtrim(upper(REG_Database_Name)))
, CASE WHEN TRK_Avg_Fragmentation_Percent < .3 THEN ''REORGANIZE''
	ELSE ''REBUILD'' 
	+ CASE WHEN @ModeId = 0 AND TRK_Index_Type_Desc = ''CLUSTERED INDEX'' THEN '' WITH(ONLINE = ON)''
		WHEN @ModeId = 0 AND TRK_Index_Type_Desc = ''NONCLUSTERED INDEX'' THEN '' WITH(ONLINE = OFF)''
		ELSE '' WITH(ONLINE = OFF)'' END
	END AS Operation
FROM CAT.VI_0350_Index_Integrity_Report AS IIR
JOIN (
	SELECT TOP 25 TRK_FK_T2_ID, TRK_FK_T3_OBJ_ID
	FROM CAT.VI_0350_Index_Integrity_Report
	WHERE NOT (REG_Database_Name = ''DWMgmt'' AND LEFT(Schema_Bound_Name,3) = ''TMP'')
	AND TRK_Avg_Fragmentation_Percent > .05
	AND TRK_Page_Count > 500
	AND TRK_Index_Type_Desc <> ''HEAP''
	GROUP BY TRK_FK_T2_ID, TRK_FK_T3_OBJ_ID
	ORDER BY SUM(TRK_Avg_Fragmentation_Percent) DESC
	) AS SUB
ON IIR.TRK_FK_T2_ID = SUB.TRK_FK_T2_ID
AND IIR.TRK_FK_T3_OBJ_ID = SUB.TRK_FK_T3_OBJ_ID
WHERE IIR.TRK_Avg_Fragmentation_Percent > 0
ORDER BY IIR.TRK_FK_T3_OBJ_ID, IIR.TRK_Index_Rank 

OPEN IndexMaintainer

FETCH NEXT FROM IndexMaintainer
INTO @Index, @Object, @Database, @Operation

WHILE @@FETCH_STATUS = 0
BEGIN

IF @DBInner <> @Database
BEGIN	
	SET @SQL = ''USE ''+@Database+''''
	SET @DBInner = @Database
END

SET @SQL = @SQL + ''
ALTER INDEX ''+@Index+'' ON ''+@Database+''.''+@Object+'' ''+@Operation+''
''

IF @ExecuteStatus in (0,1)
BEGIN
	PRINT @SQl
END


IF @ExecuteStatus in (1,2)
BEGIN
	EXEC sp_executesql @SQL
END

SET @SQL = ''''

FETCH NEXT FROM IndexMaintainer
INTO @Index, @Object, @Database, @Operation

END

CLOSE IndexMaintainer
DEALLOCATE IndexMaintainer
' 
END
GO
