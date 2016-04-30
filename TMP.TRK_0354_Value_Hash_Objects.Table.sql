USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0354_Value_Hash_Objects]') AND type in (N'U'))
DROP TABLE [TMP].[TRK_0354_Value_Hash_Objects]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0354_Value_Hash_Objects]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[TRK_0354_Value_Hash_Objects](
	[TBL_ID] [int] IDENTITY(1,1) NOT NULL,
	[LNK_T4_ID] [int] NOT NULL,
	[Server_Name] [nvarchar](256) NULL,
	[Database_Name] [nvarchar](256) NULL,
	[Schema_Bound_Name] [nvarchar](256) NULL,
	[Column_Name] [nvarchar](256) NULL,
	[Column_Type] [nvarchar](256) NULL,
	[Collate_Flag] [nchar](1) NULL
) ON [PRIMARY]
END
GO
