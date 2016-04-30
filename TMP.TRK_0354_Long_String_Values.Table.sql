USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0354_Long_String_Values]') AND type in (N'U'))
DROP TABLE [TMP].[TRK_0354_Long_String_Values]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0354_Long_String_Values]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[TRK_0354_Long_String_Values](
	[TBL_ID] [int] IDENTITY(1,1) NOT NULL,
	[LNK_T4_ID] [int] NULL,
	[Value_Count] [int] NULL,
	[String] [nvarchar](max) NULL,
	[Source_ID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
