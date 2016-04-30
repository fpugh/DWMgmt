USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VT_0300_Object_Utilization_Vectors]'))
DROP VIEW [CAT].[VT_0300_Object_Utilization_Vectors]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VT_0300_Object_Utilization_Vectors]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [CAT].[VT_0300_Object_Utilization_Vectors]

AS

WITH MaxActions (Ordinal, TRK_FK_T2_ID, TRK_FK_T3_ID, TRK_Last_Action_Type, TRK_Last_Action_Date)
AS (
	SELECT Ordinal, TRK_FK_T2_ID, TRK_FK_T3_ID, TRK_Last_Action_Type, TRK_Last_Action_Date
	FROM (
		SELECT DENSE_RANK() OVER (PARTITION BY TRK_FK_T2_ID, TRK_FK_T3_ID, TRK_Last_Action_Type ORDER BY TRK_Last_Action_Date DESC) as Ordinal
		, TRK_FK_T2_ID, TRK_FK_T3_ID, TRK_Last_Action_Type, TRK_Last_Action_Date
		FROM CAT.TRK_0300_Object_Utiliztion_Metrics AS oum WITH(NOLOCK)
		) AS SUB
	WHERE Ordinal IN (1,2)
	)

SELECT oum.TRK_FK_T2_ID, oum.TRK_FK_T3_ID, oum.TRK_Last_Action_Type
, REG_0100_ID, REG_0200_ID, REG_0204_ID, REG_0300_ID
, REG_Server_Name, REG_Database_Name, REG_Schema_Name, REG_Object_Name
, ma1.TRK_Last_Action_Date
, ma1.TRK_Last_Action_Date - ISNULL(crap.TRK_Last_Action_Date, ma1.TRK_Last_Action_Date) AS Diff_Last_Scan
, CASE WHEN oum.Total_Lookups < crap.Total_Lookups THEN oum.Total_Lookups + crap.Total_Lookups
	WHEN oum.Total_Lookups >= crap.Total_Lookups THEN oum.Total_Lookups END AS Current_Total_Lookups
, CASE WHEN oum.TRK_Last_Action_Date IS NULL OR oum.Total_Lookups = crap.Total_Lookups THEN 0
	ELSE  oum.Total_Lookups - crap.Total_Lookups END AS Vector_Lookups
, CASE WHEN oum.Total_Seeks < crap.Total_Seeks THEN oum.Total_Seeks + crap.Total_Seeks
	WHEN oum.Total_Seeks >= crap.Total_Seeks THEN oum.Total_Seeks END AS Current_Total_Seeks
, CASE WHEN oum.TRK_Last_Action_Date IS NULL OR oum.Total_Seeks = crap.Total_Seeks THEN 0
	ELSE  oum.Total_Seeks - crap.Total_Seeks END AS Vector_Seeks
, CASE WHEN oum.Total_Scans < crap.Total_Scans THEN oum.Total_Scans + crap.Total_Scans
	WHEN oum.Total_Scans >= crap.Total_Scans THEN oum.Total_Scans END AS Current_Total_Scans
, CASE WHEN oum.TRK_Last_Action_Date IS NULL OR oum.Total_Scans = crap.Total_Scans THEN 0
	ELSE  oum.Total_Scans - crap.Total_Scans END AS Vector_Scans
, CASE WHEN oum.Total_Updates < crap.Total_Updates THEN oum.Total_Updates + crap.Total_Updates
	WHEN oum.Total_Updates >= crap.Total_Updates THEN oum.Total_Updates END AS Current_Total_Updates
, CASE WHEN oum.TRK_Last_Action_Date IS NULL OR oum.Total_Updates = crap.Total_Updates THEN 0
	ELSE  oum.Total_Updates - crap.Total_Updates END AS Vector_Updates
FROM CAT.TRK_0300_Object_Utiliztion_Metrics AS oum WITH(NOLOCK)
JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb WITH(NOLOCK)
ON lsb.LNK_T3_ID = oum.TRK_FK_T3_ID
AND lsb.LNK_FK_T2_ID = oum.TRK_FK_T2_ID
JOIN CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
ON lsd.LNK_T2_ID = oum.TRK_FK_T2_ID
JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = lsd.LNK_FK_0100_ID
JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
JOIN CAT.REG_0300_Object_registry AS ror WITH(NOLOCK)
ON ror.REG_0300_ID = lsb.LNK_FK_0300_ID
JOIN MaxActions AS ma1 WITH(NOLOCK)
ON ma1.TRK_Last_Action_Date = oum.TRK_Last_Action_Date
AND ma1.TRK_FK_T3_ID = oum.TRK_FK_T3_ID
AND ma1.TRK_FK_T2_ID = oum.TRK_FK_T2_ID
AND ma1.TRK_Last_Action_Type = oum.TRK_Last_Action_Type
AND ma1.Ordinal = 1
CROSS APPLY (
	SELECT oum.TRK_FK_T2_ID, oum.TRK_FK_T3_ID, oum.TRK_Last_Action_Type
	, ma2.TRK_Last_Action_Date, oum.Total_Lookups, oum.Total_Scans, oum.Total_Seeks, oum.Total_Updates
	FROM CAT.TRK_0300_Object_Utiliztion_Metrics AS oum WITH(NOLOCK)
	JOIN MaxActions AS ma2 WITH(NOLOCK)
	ON ma2.TRK_Last_Action_Date = oum.TRK_Last_Action_Date
	AND ma2.TRK_FK_T3_ID = oum.TRK_FK_T3_ID
	AND ma2.TRK_FK_T2_ID = oum.TRK_FK_T2_ID
	AND ma2.TRK_Last_Action_Type = oum.TRK_Last_Action_Type
	AND ma2.Ordinal = 2
	) AS CRAP
WHERE CRAP.TRK_FK_T3_ID = ma1.TRK_FK_T3_ID
AND CRAP.TRK_FK_T2_ID = ma1.TRK_FK_T2_ID
AND CRAP.TRK_Last_Action_Type = ma1.TRK_Last_Action_Type
' 
GO
