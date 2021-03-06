USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [TMP].[REG_0300_0401_Insert](
	[LNK_T2_ID] [int] NULL,
	[LNK_T3_ID] [int] NULL,
	[LNK_T4_ID] [int] NULL,
	[REG_0300_ID] [int] NULL,
	[REG_0400_ID] [int] NULL,
	[REG_0401_ID] [int] NULL,
	[Server_ID] [int] NOT NULL,
	[Database_ID] [int] NULL,
	[Schema_ID] [int] NULL,
	[Object_ID] [int] NULL,
	[Object_Type] [nvarchar](25) NULL,
	[Column_Name] [nvarchar](256) NULL,
	[Column_Type] [varchar](25) NULL,
	[Column_Rank] [int] NULL,
	[Is_Identity] [bit] NULL,
	[Is_Nullable] [bit] NULL,
	[Is_Default_Collation] [bit] NULL,
	[Is_Primary_Key] [bit] NULL,
	[Column_Size] [int] NULL,
	[Column_Scale] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
CREATE CLUSTERED INDEX [tdx_ci_reg_0300_0401_K7_K8_K9_K10_K14] ON [TMP].[REG_0300_0401_Insert]
(
	[Server_ID] ASC,
	[Database_ID] ASC,
	[Schema_ID] ASC,
	[Object_ID] ASC,
	[Column_Rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [tdx_nc_reg_0300_0401_K12_K13_I15_I16_I18] ON [TMP].[REG_0300_0401_Insert]
(
	[Column_Name] ASC,
	[Column_Type] ASC
)
INCLUDE ( 	[Is_Identity],
	[Is_Nullable],
	[Is_Primary_Key]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [tdx_nci_reg_0300_0401_K4_K5_I6] ON [TMP].[REG_0300_0401_Insert]
(
	[REG_0300_ID] ASC,
	[REG_0400_ID] ASC
)
INCLUDE ( 	[REG_0401_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [TMP].[REG_0300_0401_Insert] ADD  CONSTRAINT [DF_0300_0401_Server_ID]  DEFAULT ((0)) FOR [Server_ID]
GO
