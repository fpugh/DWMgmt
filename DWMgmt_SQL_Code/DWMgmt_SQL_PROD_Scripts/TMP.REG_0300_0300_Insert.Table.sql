USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TMP].[REG_0300_0300_Insert](
	[LNK_T3P_ID] [int] NULL,
	[LNK_T3R_ID] [int] NULL,
	[LNK_Latch_Type] [nvarchar](25) NULL,
	[LNK_0300_Prm_ID] [int] NULL,
	[LNK_0300_Ref_ID] [int] NULL,
	[LNK_Prm_Schema_Name] [nvarchar](256) NULL,
	[LNK_Prm_Object_Name] [nvarchar](256) NULL,
	[LNK_Prm_Object_ID] [int] NULL,
	[LNK_Rank] [int] NULL,
	[LNK_Ref_Schema_Name] [nvarchar](256) NULL,
	[LNK_Ref_Object_Name] [nvarchar](256) NULL,
	[LNK_Ref_Object_ID] [int] NULL,
	[LNK_Ref_Caller_Dependent] [bit] NULL
) ON [PRIMARY]

GO
