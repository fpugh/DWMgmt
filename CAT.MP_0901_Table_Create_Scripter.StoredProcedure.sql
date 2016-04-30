USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_0901_Table_Create_Scripter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[MP_0901_Table_Create_Scripter]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_0901_Table_Create_Scripter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [CAT].[MP_0901_Table_Create_Scripter]

AS


/* Build Work Table and Fill It 
	Create an output table to select results of 
		RPT_0100_Object_Detail_Lookup	
	*/

IF NOT EXISTS (SELECT name FROM tempdb.sys.tables WHERE name LIKE N''#RPT_Object_Detail_Lookup%'')
CREATE TABLE #RPT_Object_Detail_Lookup([Title] [nvarchar](512) NULL, [REG_Server_Name] [nvarchar](256) NOT NULL, [REG_Product] [nvarchar](256) NOT NULL
, [REG_Monitored] [bit] NOT NULL, [REG_Database_Name] [nvarchar](256) NOT NULL, [REG_Compatibility] [tinyint] NOT NULL, [REG_Collation] [nvarchar](65) NOT NULL
, [REG_Recovery_Model] [nvarchar](65) NOT NULL, [Fully_Qualified_Name] [nvarchar](1024) NOT NULL, [Schema_Bound_Name] [nvarchar](1024) NOT NULL, [REG_Schema_Name] [nvarchar](256) NOT NULL
, [REG_Object_Name] [nvarchar](256) NOT NULL, [REG_Object_Type] [nvarchar](25) NOT NULL, [REG_Column_Name] [nvarchar](256) NOT NULL, [REG_Column_Type] [nvarchar](25) NOT NULL
, [Column_Type_Desc] [nvarchar](65) NULL, [REG_Size] [int] NOT NULL, [REG_Scale] [int] NOT NULL, [Is_Identity] [bit] NOT NULL, [Is_Nullable] [bit] NOT NULL, [Is_Default_Collation] [bit] NOT NULL
, [REG_Column_Rank] [int] NOT NULL, [Column_Definition] [nvarchar](512) NULL, [LNK_T2_ID] [int] NOT NULL, [LNK_T3_ID] [int] NOT NULL, [LNK_T4_ID] [int] NOT NULL
, [REG_0100_ID] [int] NOT NULL, [REG_0200_ID] [int] NOT NULL, [REG_0204_ID] [int] NOT NULL, [REG_0300_ID] [int] NOT NULL, [REG_0400_ID] [int] NOT NULL
, [Object_String] [NVARCHAR] (4000) NULL
)

INSERT INTO  #RPT_Object_Detail_Lookup (Title, REG_Server_Name, REG_Product, REG_Monitored, REG_Database_Name, REG_Compatibility, REG_Collation, REG_Recovery_Model
, Fully_Qualified_Name, Schema_Bound_Name, REG_Schema_Name, REG_Object_Name, REG_Object_Type, REG_Column_Name, REG_Column_Type, Column_Type_Desc, REG_Size, REG_Scale
, Is_Identity, Is_Nullable, Is_Default_Collation, REG_Column_Rank, Column_Definition, LNK_T2_ID, LNK_T3_ID, LNK_T4_ID, REG_0100_ID, REG_0200_ID, REG_0204_ID, REG_0300_ID, REG_0400_ID)
EXEC CAT.RPT_0100_Object_Detail_Lookup
@NamePart = ''CAT.REG''
, @ObjectType = ''I''
, @SearchDate = ''3/15/2016''

CREATE CLUSTERED INDEX tds_RPT_ODL_K24_K25_K26 ON #RPT_Object_Detail_Lookup (LNK_T2_ID, LNK_T3_ID, REG_Column_Rank)

SELECT *
FROM #RPT_Object_Detail_Lookup' 
END
GO
