USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[GTMP_Object_Detail_Lookup]') AND type in (N'U'))
DROP TABLE [TMP].[GTMP_Object_Detail_Lookup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[GTMP_Object_Detail_Lookup]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[GTMP_Object_Detail_Lookup](
	[Title] [nvarchar](275) NULL,
	[REG_Server_Name] [nvarchar](256) NOT NULL,
	[REG_Product] [nvarchar](256) NOT NULL,
	[REG_Monitored] [bit] NOT NULL,
	[REG_Database_Name] [nvarchar](256) NOT NULL,
	[REG_Compatibility] [tinyint] NOT NULL,
	[REG_Collation] [nvarchar](65) NOT NULL,
	[REG_Recovery_Model] [nvarchar](65) NOT NULL,
	[Fully_Qualified_Name] [nvarchar](776) NOT NULL,
	[Schema_Bound_Name] [nvarchar](517) NOT NULL,
	[REG_Schema_Name] [nvarchar](256) NOT NULL,
	[REG_Object_Name] [nvarchar](256) NOT NULL,
	[REG_Object_Type] [nvarchar](25) NOT NULL,
	[REG_Column_Name] [nvarchar](256) NOT NULL,
	[REG_Column_Type] [nvarchar](25) NOT NULL,
	[Column_Type_Desc] [sysname] NULL,
	[REG_Size] [int] NOT NULL,
	[REG_Scale] [int] NOT NULL,
	[Is_Identity] [bit] NOT NULL,
	[Is_Nullable] [bit] NOT NULL,
	[Is_Default_Collation] [bit] NOT NULL,
	[REG_Column_Rank] [int] NOT NULL,
	[Column_Definition] [nvarchar](462) NULL,
	[LNK_T2_ID] [int] NOT NULL,
	[LNK_T3_ID] [int] NOT NULL,
	[LNK_T4_ID] [int] NOT NULL,
	[REG_0100_ID] [int] NOT NULL,
	[REG_0200_ID] [int] NOT NULL,
	[REG_0204_ID] [int] NOT NULL,
	[REG_0300_ID] [int] NOT NULL,
	[REG_0400_ID] [int] NOT NULL
) ON [PRIMARY]
END
GO
