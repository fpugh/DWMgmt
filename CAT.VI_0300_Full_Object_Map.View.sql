USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0300_Full_Object_Map]'))
DROP VIEW [CAT].[VI_0300_Full_Object_Map]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CAT].[VI_0300_Full_Object_Map]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [CAT].[VI_0300_Full_Object_Map]
AS
SELECT DENSE_Rank() OVER(ORDER BY LNK_T2_ID, LNK_T3_ID, isnull(lat3.LNK_Rank,0), LNK_T4_ID) AS VID
, lat1.LNK_T2_ID
, lat2.LNK_T3_ID
, lat3.LNK_T4_ID
, reg1.REG_0100_ID
, reg2.REG_0200_ID
, reg3.REG_0204_ID
, reg4.REG_0300_ID
, reg5.REG_0400_ID
, reg1.REG_Server_Name
, ''['' + reg1.REG_Server_Name + ''].['' + reg2.REG_Database_Name + ''].['' + reg3.REG_Schema_Name + ''].['' + reg4.REG_Object_Name + '']'' as Fully_Qualified_Name
, ''['' + reg3.REG_Schema_Name + ''].['' + reg4.REG_Object_Name + '']'' as Schema_Bound_Name
, reg2.REG_Database_Name
, reg3.REG_Schema_Name
, reg4.REG_Object_Name
, reg4.REG_Object_Type
, lat3.LNK_Rank as Column_Rank
, reg5.REG_Column_Name
, reg5.REG_Column_Type
, typ.name as Column_Type_Desc
, ''['' + reg5.REG_Column_Name + ''] ['' + typ.name
+ CASE WHEN reg6.Is_Identity = 1 THEN ''] IDENTITY'' ELSE '']'' END
+ CASE WHEN REG_Column_Type IN (34,98,99,106,108,165,167,173,175,231,239,241,256)  THEN '' ('' + CAST(reg6.REG_Size AS nvarchar) + '')''
	WHEN REG_Column_Type IN (106,108) THEN '' ('' + CAST(reg6.REG_Size AS nvarchar) + '','' + CAST(reg6.REG_Scale as nvarchar) + '')''
	ELSE '''' END AS Column_Definition
FROM CAT.LNK_0100_0200_server_databases AS lat1 WITH(NOLOCK)
LEFT JOIN CAT.LNK_0204_0300_Schema_Binding AS lat2 WITH(NOLOCK)
ON lat2.LNK_FK_T2_ID = lat1.LNK_T2_ID
AND (GETDATE() BETWEEN lat2.LNK_Post_Date AND lat2.LNK_Term_Date
OR lat2.LNK_Term_Date = cast(-1 as datetime))
LEFT JOIN CAT.LNK_0300_0400_Object_Column_Collection AS lat3 WITH(NOLOCK)
ON lat3.LNK_FK_T3_ID = lat2.LNK_T3_ID
AND (GETDATE() BETWEEN lat3.LNK_Post_Date AND lat3.LNK_Term_Date
OR lat3.LNK_Term_Date = cast(-1 as datetime))
LEFT JOIN CAT.LNK_Tier4_Peers AS lnk2 WITH(NOLOCK)
ON lnk2.LNK_FK_T4_ID = lat3.LNK_T4_ID
LEFT JOIN CAT.REG_0100_server_registry AS reg1 WITH(NOLOCK)
ON lat1.LNK_FK_0100_ID = reg1.REG_0100_ID
LEFT JOIN CAT.REG_0200_Database_registry AS reg2 WITH(NOLOCK)
ON reg2.REG_0200_ID = lat1.LNK_FK_0200_ID
LEFT JOIN CAT.REG_0204_Database_Schemas AS reg3 WITH(NOLOCK)
ON reg3.REG_0204_ID = lat2.LNK_FK_0204_ID
LEFT JOIN CAT.REG_0300_Object_registry AS reg4 WITH(NOLOCK)
ON reg4.REG_0300_ID = lat2.LNK_FK_0300_ID
LEFT JOIN CAT.REG_0400_Column_registry AS reg5 WITH(NOLOCK)
ON reg5.REG_0400_ID =  lat3.LNK_FK_0400_ID
LEFT JOIN CAT.REG_0401_Column_properties AS reg6 WITH(NOLOCK)
ON reg6.REG_0401_ID = lnk2.LNK_FK_0401_ID
LEFT JOIN sys.types as typ WITH(NOLOCK)
ON typ.user_Type_ID = reg5.REG_Column_Type
WHERE (GETDATE() BETWEEN lat1.LNK_Post_Date AND lat1.LNK_Term_Date
OR lat1.LNK_Term_Date = cast(-1 as datetime))

' 
GO
