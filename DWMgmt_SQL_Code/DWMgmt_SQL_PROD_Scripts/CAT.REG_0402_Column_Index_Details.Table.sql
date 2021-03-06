USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CAT].[REG_0402_Column_Index_Details](
	[REG_0402_ID] [int] IDENTITY(1,1) NOT NULL,
	[Index_Column_ID] [int] NOT NULL,
	[Partition_Ordinal] [int] NOT NULL,
	[Is_Descending_Key] [bit] NOT NULL,
	[Is_Included_Column] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_REG_0402] PRIMARY KEY CLUSTERED 
(
	[Index_Column_ID] ASC,
	[Partition_Ordinal] ASC,
	[Is_Descending_Key] ASC,
	[Is_Included_Column] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0402_ID] UNIQUE NONCLUSTERED 
(
	[REG_0402_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [CAT].[REG_0402_Column_Index_Details] ADD  CONSTRAINT [DF_REG_0402_Columnid]  DEFAULT ((0)) FOR [Index_Column_ID]
GO
ALTER TABLE [CAT].[REG_0402_Column_Index_Details] ADD  CONSTRAINT [DF_REG_0402_partitionid]  DEFAULT ((0)) FOR [Partition_Ordinal]
GO
ALTER TABLE [CAT].[REG_0402_Column_Index_Details] ADD  CONSTRAINT [DF_REG_0402_Descending]  DEFAULT ('false') FOR [Is_Descending_Key]
GO
ALTER TABLE [CAT].[REG_0402_Column_Index_Details] ADD  CONSTRAINT [DF_REG_0402_Included]  DEFAULT ('false') FOR [Is_Included_Column]
GO
ALTER TABLE [CAT].[REG_0402_Column_Index_Details] ADD  CONSTRAINT [DF_REG_0402_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
GO
