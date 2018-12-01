USE [DWMgmt]
GO


CREATE TABLE [TMP].[TRK_0354_Long_String_Values](
	[TBL_LSV_ID] [int] IDENTITY(1,1) NOT NULL,
	[LNK_T4_ID] [int] NULL,
	[Value_Count] [int] NULL,
	[String] [nvarchar](max) NULL,
	[Source_ID] [int] NULL,
	[Batch_ID] [varchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

