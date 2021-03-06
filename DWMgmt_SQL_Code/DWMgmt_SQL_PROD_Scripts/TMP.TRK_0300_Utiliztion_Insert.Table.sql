USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TMP].[TRK_0300_Utiliztion_Insert](
	[TRK_fk_T2_ID] [int] NULL,
	[TRK_fk_T3_ID] [int] NULL,
	[Server_ID] [int] NULL,
	[Database_ID] [int] NULL,
	[Object_ID] [int] NULL,
	[TRK_Last_Action_Type] [nvarchar](25) NULL,
	[TRK_Last_Action_Date] [datetime] NULL,
	[Total_Seeks] [int] NULL,
	[Total_Scans] [int] NULL,
	[Total_Lookups] [int] NULL,
	[Total_Updates] [int] NULL
) ON [PRIMARY]

GO
ALTER TABLE [TMP].[TRK_0300_Utiliztion_Insert] ADD  CONSTRAINT [DF_Utilization_T2_ID]  DEFAULT ((0)) FOR [TRK_fk_T2_ID]
GO
ALTER TABLE [TMP].[TRK_0300_Utiliztion_Insert] ADD  CONSTRAINT [DF_Utilization_T3_ID]  DEFAULT ((0)) FOR [TRK_fk_T3_ID]
GO
