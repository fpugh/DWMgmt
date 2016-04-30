USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VT_0302_New_Objects_Last_Seven_Days]'))
DROP VIEW [CAT].[VT_0302_New_Objects_Last_Seven_Days]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VT_0302_New_Objects_Last_Seven_Days]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [CAT].[VT_0302_New_Objects_Last_Seven_Days]
AS
SELECT sub.REG_Database_Name, sub.REG_Schema_Name
, sub.REG_Object_Name, sub.REG_Object_Type
, count(*) as Incarnations
, max(Object_Inception) as Inception
, avg(Days_Life_Span) as Avg_Days_Life_Span
FROM (
	SELECT rdr.REG_Database_Name, rds.REG_Schema_Name
	, ror.REG_Object_Name, ror.REG_Object_Type
	, lsb.LNK_Post_Date as Object_Inception
	, datediff("day", ror.REG_Create_Date, getdate()) as Days_Life_Span
	FROM CAT.LNK_0100_0200_Server_Databases AS lsd
	JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb
	ON lsb.LNK_FK_T2_ID = lsd.LNK_T2_ID
	JOIN CAT.REG_0200_Database_registry AS rdr
	ON rdr.REG_0200_ID = lsd.LNK_FK_0200_ID
	JOIN CAT.REG_0204_Database_schemas AS rds
	ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
	JOIN CAT.REG_0300_Object_registry AS ror
	ON ror.REG_0300_ID = lsb.LNK_FK_0300_ID
	WHERE lsb.LNK_Post_Date between getdate() - 7 and getdate()
	AND lsb.LNK_Term_Date > getdate()
	AND rds.REG_Schema_Name NOT IN (''sys'',''INFORMATION_SCHEMA'')
	) as sub
GROUP BY sub.REG_Database_Name, sub.REG_Schema_Name
, sub.REG_Object_Name, sub.REG_Object_Type
' 
GO
