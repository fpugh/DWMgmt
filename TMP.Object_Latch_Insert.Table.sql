USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[Object_Latch_Insert]') AND type in (N'U'))
DROP TABLE [TMP].[Object_Latch_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[Object_Latch_Insert]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[Object_Latch_Insert](
	[LNK_T2_ID] [int] NULL,
	[LNK_T3_ID] [int] NULL,
	[REG_0204_ID] [int] NULL,
	[REG_0300_ID] [int] NULL
) ON [PRIMARY]
END
GO
