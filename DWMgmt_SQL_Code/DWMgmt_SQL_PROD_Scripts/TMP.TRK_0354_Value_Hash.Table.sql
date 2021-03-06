USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TMP].[TRK_0354_Value_Hash](
	[LNK_T4_ID] [int] NOT NULL,
	[Column_Value] [nvarchar](4000) NULL,
	[Value_Count] [bigint] NULL,
	[Post_Date] [datetime] NOT NULL
) ON [PRIMARY]

GO
ALTER TABLE [TMP].[TRK_0354_Value_Hash] ADD  CONSTRAINT [DF_VH_PostDate]  DEFAULT (getdate()) FOR [Post_Date]
GO
