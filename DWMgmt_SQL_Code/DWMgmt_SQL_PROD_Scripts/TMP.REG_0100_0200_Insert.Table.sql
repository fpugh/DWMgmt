USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TMP].[REG_0100_0200_Insert](
	[LNK_T2_ID] [int] NOT NULL,
	[REG_0100_ID] [int] NOT NULL,
	[REG_0200_ID] [int] NOT NULL,
	[Server_ID] [int] NOT NULL,
	[Server_Name] [nvarchar](256) NOT NULL,
	[product] [nvarchar](256) NOT NULL,
	[Database_ID] [int] NULL,
	[Database_Name] [nvarchar](256) NULL,
	[compatibility_level] [tinyint] NULL,
	[collation_Name] [nvarchar](65) NULL,
	[recovery_model_Desc] [nvarchar](65) NULL,
	[Create_Date] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
CREATE CLUSTERED INDEX [tdx_ci_reg_0100_0200_K3_K5] ON [TMP].[REG_0100_0200_Insert]
(
	[Server_Name] ASC,
	[Database_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
