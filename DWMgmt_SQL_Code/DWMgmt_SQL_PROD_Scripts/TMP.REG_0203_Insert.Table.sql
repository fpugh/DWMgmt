USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TMP].[REG_0203_Insert](
	[REG_0203_ID] [int] NULL,
	[Server_ID] [int] NOT NULL,
	[Database_ID] [int] NULL,
	[Size] [int] NULL,
	[Max_Size] [bigint] NULL,
	[Growth] [bigint] NULL,
	[Physical_Name] [nvarchar](256) NULL,
	[File_ID] [int] NULL,
	[Type] [tinyint] NULL,
	[Database_File_Name] [nvarchar](256) NULL
) ON [PRIMARY]

GO
CREATE CLUSTERED INDEX [tdx_ci_reg_0203_K2_K3] ON [TMP].[REG_0203_Insert]
(
	[Server_ID] ASC,
	[Database_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [TMP].[REG_0203_Insert] ADD  CONSTRAINT [DF_0203_Server_ID]  DEFAULT ((0)) FOR [Server_ID]
GO
