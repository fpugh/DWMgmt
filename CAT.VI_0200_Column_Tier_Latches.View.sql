USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0200_Column_Tier_Latches]'))
DROP VIEW [CAT].[VI_0200_Column_Tier_Latches]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0200_Column_Tier_Latches]'))
EXEC dbo.sp_executesql @statement = N'

--IF EXISTS (SELECT name FROM sys.views WHERE name = N''VI_0200_Column_Tier_Latches'')
--DROP VIEW [CAT].[VI_0200_Column_Tier_Latches]
--GO


CREATE VIEW [CAT].[VI_0200_Column_Tier_Latches]
AS
SELECT DENSE_Rank() OVER(ORDER BY LNK_T2_ID, LNK_T3_ID, locc.LNK_Rank) AS VID
, rsr.REG_Server_Name, rsr.REG_Product, rsr.REG_Monitored
, rdr.REG_Database_Name, rdr.REG_Compatibility, rdr.REG_Collation, rdr.REG_Recovery_Model
, rdr.REG_Database_Name+''.''+rds.REG_Schema_Name+''.''+ror.REG_Object_Name as Fully_Qualified_Name
, rds.REG_Schema_Name+''.''+ror.REG_Object_Name as Schema_Bound_Name
, rds.REG_Schema_Name
, ror.REG_Object_Name, ror.REG_Object_Type
, rcr.REG_Column_Name, rcr.REG_Column_Type, typ.name as Column_Type_Desc
, rcp.REG_Size, rcp.REG_Scale, rcp.Is_Identity, rcp.Is_Nullable, rcp.Is_Default_Collation
, locc.LNK_Rank as REG_Column_Rank
, ''[''+rcr.REG_Column_Name + ''] ['' + typ.name
+ CASE WHEN rcp.Is_Identity = 1 THEN ''] IDENTITY'' ELSE '']'' END
+ CASE WHEN rcr.REG_Column_Type IN (34,98,99,106,108,165,167,173,175,231,239,241,256)  THEN '' (''+CAST(rcp.REG_Size AS NVARCHAR) + '')''
	WHEN rcr.REG_Column_Type IN (106,108) THEN '' (''+CAST(rcp.REG_Size AS NVARCHAR) + '','' + CAST(rcp.REG_Scale AS NVARCHAR)+'')''
	ELSE '''' END AS Column_Definition
, lsr.LNK_T2_ID, lsb.LNK_T3_ID, locc.LNK_T4_ID, rsr.REG_0100_ID, rdr.REG_0200_ID, rds.REG_0204_ID, ror.REG_0300_ID, rcr.REG_0400_ID
FROM CAT.LNK_0100_0200_Server_Databases as lsr WITH(NOLOCK)
JOIN CAT.LNK_0204_0300_Schema_Binding as lsb WITH(NOLOCK)
ON lsb.LNK_FK_T2_ID = lsr.LNK_T2_ID
AND (lsb.LNK_Term_Date > GETDATE()
OR lsb.LNK_Term_Date = CAST(-1 as datetime))
JOIN CAT.LNK_0300_0400_Object_Column_Collection AS locc WITH(NOLOCK)
ON locc.LNK_FK_T3_ID = lsb.LNK_T3_ID
AND locc.LNK_FK_0300_ID = lsb.LNK_FK_0300_ID
AND (locc.LNK_Term_Date > GETDATE()
OR locc.LNK_Term_Date = CAST(-1 as datetime))
JOIN CAT.LNK_Tier4_Peers AS t4p WITH(NOLOCK)
ON t4p.LNK_FK_T4_ID = locc.LNK_T4_ID
AND t4p.LNK_FK_0400_ID = locc.LNK_FK_0400_ID
AND (t4p.LNK_Term_Date > GETDATE()
OR  t4p.LNK_Term_Date = CAST(-1 as datetime))
JOIN CAT.REG_0100_server_registry AS rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = lsr.LNK_FK_0100_ID
JOIN CAT.REG_0200_Database_registry AS rdr WITH(NOLOCK)
ON rdr.REG_0200_ID = lsr.LNK_FK_0200_ID
JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
ON rds.REG_0204_ID = lsb.LNK_FK_0204_ID
JOIN CAT.REG_0300_Object_registry AS ror WITH(NOLOCK)
ON ror.REG_0300_ID = lsb.LNK_FK_0300_ID
JOIN CAT.REG_0400_Column_registry AS rcr WITH(NOLOCK)
ON rcr.REG_0400_ID =  locc.LNK_FK_0400_ID
JOIN CAT.REG_0401_Column_properties AS rcp WITH(NOLOCK)
ON rcp.REG_0401_ID =  t4p.LNK_FK_0401_ID
LEFT JOIN sys.types AS typ WITH(NOLOCK)
ON typ.user_Type_ID = rcr.REG_Column_Type
WHERE (lsr.LNK_Term_Date > GETDATE()
OR lsr.LNK_Term_Date = cast(-1 as datetime))
AND ror.REG_Object_Type IN (''U'',''V'',''UT1'',''UT2'',''UT3'')
' 
GO
