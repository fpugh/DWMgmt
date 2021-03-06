USE [DWMgmt]
GO


CREATE TABLE [TMP].[TRK_0354_Value_Hash_Objects](
	[TBL_VHO_ID] [int] IDENTITY(1,1) NOT NULL,
	[LNK_T4_ID] [int] NOT NULL,
	[Server_Name] [nvarchar](256) NULL,
	[Database_Name] [nvarchar](256) NULL,
	[Schema_Bound_Name] [nvarchar](512) NULL,
	[Column_Name] [nvarchar](256) NULL,
	[Column_Type] [nvarchar](256) NULL,
	[Collate_Flag] [nchar](1) NULL
) ON [PRIMARY]

GO
