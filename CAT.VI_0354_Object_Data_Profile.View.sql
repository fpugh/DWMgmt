USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0354_Object_Data_Profile]'))
DROP VIEW [CAT].[VI_0354_Object_Data_Profile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0354_Object_Data_Profile]'))
EXEC dbo.sp_executesql @statement = N'


CREATE VIEW [CAT].[VI_0354_Object_Data_Profile]
AS
SELECT DENSE_Rank() OVER (ORDER BY lat1.LNK_T2_ID, lat2.LNK_T3_ID, lat3.LNK_Rank, lat3.LNK_T4_ID) as VID
, lat1.LNK_T2_ID, lat2.LNK_T3_ID, lat3.LNK_T4_ID
, reg5.REG_Server_Name, reg4.REG_Database_Name, reg3.REG_Schema_Name, reg2.REG_Object_Name, reg1.REG_Column_Name
, CASE WHEN reg13.Is_Identity = 1 THEN UPPER(typ.name)+'' IDENTITY'' ELSE UPPER(typ.name) END
+'' ''+ CASE WHEN reg1.REG_Column_Type IN (165,167,175,231,239) THEN ''(''+cast(reg13.REG_Size as varchar)+'')'' 
    WHEN reg1.REG_Column_Type IN (106,108) OR reg13.Is_Identity = 1 THEN ''(''+cast(reg13.REG_Size as varchar)+'',''+cast(reg13.REG_Scale as varchar)+'')''
    ELSE '''' END AS REG_Column_space
, lat3.LNK_Rank, trk.TRK_total_values, trk.TRK_Column_nulls, trk.TRK_distinct_values
, trk.TRK_density, trk.TRK_uniqueness, trk.TRK_Post_Date
FROM CAT.LNK_0100_0200_Server_Databases AS lat1 WITH(NOLOCK)
JOIN CAT.LNK_0204_0300_Schema_Binding AS lat2 WITH(NOLOCK)
ON lat2.LNK_FK_T2_ID = lat1.LNK_T2_ID
JOIN CAT.LNK_0300_0400_Object_Column_Collection AS lat3 WITH(NOLOCK)
ON lat3.LNK_FK_T3_ID = lat2.LNK_T3_ID
JOIN (
	SELECT sub.LNK_FK_T3_ID, trk.TRK_FK_T4_ID, trk.TRK_distinct_values
	, trk.TRK_Column_nulls, max(trk.TRK_total_values) as TRK_total_values
	, trk.TRK_density, trk.TRK_uniqueness, trk.TRK_Post_Date
	FROM CAT.TRK_0454_Column_Metrics AS trk WITH(NOLOCK)
	JOIN (
		SELECT occ.LNK_FK_T3_ID, trk.TRK_FK_T4_ID, max(TRK_Post_Date) as TRK_Post_Date
		FROM CAT.TRK_0454_Column_Metrics AS trk WITH(NOLOCK)
		JOIN CAT.LNK_0300_0400_Object_Column_Collection AS occ WITH(NOLOCK)
		ON occ.LNK_T4_ID = trk.TRK_FK_T4_ID
		GROUP BY occ.LNK_FK_T3_ID, trk.TRK_FK_T4_ID
		) AS sub
	ON sub.TRK_FK_T4_ID = trk.TRK_FK_T4_ID
	AND sub.TRK_Post_Date = trk.TRK_Post_Date
	GROUP BY sub.LNK_FK_T3_ID, trk.TRK_FK_T4_ID, trk.TRK_distinct_values
	, trk.TRK_Column_nulls, trk.TRK_density, trk.TRK_uniqueness, trk.TRK_Post_Date
	) AS trk
ON trk.LNK_FK_T3_ID = lat2.LNK_T3_ID
AND trk.TRK_FK_T4_ID = lat3.LNK_T4_ID
AND trk.TRK_Post_Date BETWEEN lat2.LNK_Post_Date AND lat2.LNK_Term_Date
JOIN CAT.REG_0400_Column_registry AS reg1 WITH(NOLOCK)
ON reg1.REG_0400_ID = lat3.LNK_FK_0400_ID
JOIN CAT.REG_0300_Object_registry AS reg2 WITH(NOLOCK)
ON reg2.REG_0300_ID = lat2.LNK_FK_0300_ID
JOIN CAT.REG_0204_Database_Schemas AS reg3 WITH(NOLOCK)
ON reg3.REG_0204_ID = lat2.LNK_FK_0204_ID
JOIN CAT.REG_0200_Database_Registry AS reg4 WITH(NOLOCK)
ON reg4.REG_0200_ID = lat1.LNK_FK_0200_ID
JOIN CAT.REG_0100_Server_Registry AS reg5 WITH(NOLOCK)
ON reg5.REG_0100_ID = lat1.LNK_FK_0100_ID
LEFT JOIN CAT.LNK_Tier4_Peers AS lnk2 WITH(NOLOCK)
ON lnk2.LNK_FK_T4_ID = lat3.LNK_T4_ID
AND getdate() BETWEEN lat2.LNK_Post_Date AND lat2.LNK_Term_Date
LEFT JOIN CAT.REG_0401_Column_properties AS reg13 WITH(NOLOCK)
ON reg13.REG_0401_ID = lnk2.LNK_FK_0401_ID
JOIN sys.types as typ WITH(NOLOCK)
ON typ.user_Type_ID = reg1.REG_Column_Type
' 
GO
