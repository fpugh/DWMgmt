USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CAT].[REG_0301_Index_Details](
	[REG_0301_ID] [int] IDENTITY(1,1) NOT NULL,
	[Filter_Definition] [nvarchar](max) NULL,
	[data_space_ID] [int] NOT NULL,
	[Fill_Factor] [tinyint] NOT NULL,
	[Is_Unique] [bit] NOT NULL,
	[Ignore_Dup_Key] [bit] NOT NULL,
	[Is_Primary_Key] [bit] NOT NULL,
	[Is_Unique_Constraint] [bit] NOT NULL,
	[Is_padded] [bit] NOT NULL,
	[Is_Disabled] [bit] NOT NULL,
	[Is_hypothetical] [bit] NOT NULL,
	[Allow_Row_Locks] [bit] NOT NULL,
	[Allow_Page_Locks] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_REG_0301] PRIMARY KEY CLUSTERED 
(
	[data_space_ID] ASC,
	[Fill_Factor] ASC,
	[Is_Unique] ASC,
	[Ignore_Dup_Key] ASC,
	[Is_Primary_Key] ASC,
	[Is_Unique_Constraint] ASC,
	[Is_padded] ASC,
	[Is_Disabled] ASC,
	[Is_hypothetical] ASC,
	[Allow_Row_Locks] ASC,
	[Allow_Page_Locks] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0301_ID] UNIQUE NONCLUSTERED 
(
	[REG_0301_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [CAT].[REG_0301_Index_Details] ADD  CONSTRAINT [DF_REG_0301_Unique]  DEFAULT ('false') FOR [Is_Unique]
GO
ALTER TABLE [CAT].[REG_0301_Index_Details] ADD  CONSTRAINT [DF_REG_0301_igndup]  DEFAULT ('false') FOR [Ignore_Dup_Key]
GO
ALTER TABLE [CAT].[REG_0301_Index_Details] ADD  CONSTRAINT [DF_REG_0301_primkey]  DEFAULT ('false') FOR [Is_Primary_Key]
GO
ALTER TABLE [CAT].[REG_0301_Index_Details] ADD  CONSTRAINT [DF_REG_0301_unqcnsrt]  DEFAULT ('false') FOR [Is_Unique_Constraint]
GO
ALTER TABLE [CAT].[REG_0301_Index_Details] ADD  CONSTRAINT [DF_REG_0301_padded]  DEFAULT ('false') FOR [Is_padded]
GO
ALTER TABLE [CAT].[REG_0301_Index_Details] ADD  CONSTRAINT [DF_REG_0301_Disabled]  DEFAULT ('false') FOR [Is_Disabled]
GO
ALTER TABLE [CAT].[REG_0301_Index_Details] ADD  CONSTRAINT [DF_REG_0301_hypothetical]  DEFAULT ('false') FOR [Is_hypothetical]
GO
ALTER TABLE [CAT].[REG_0301_Index_Details] ADD  CONSTRAINT [DF_REG_0301_rolox]  DEFAULT ('true') FOR [Allow_Row_Locks]
GO
ALTER TABLE [CAT].[REG_0301_Index_Details] ADD  CONSTRAINT [DF_REG_0301_paglox]  DEFAULT ('true') FOR [Allow_Page_Locks]
GO
ALTER TABLE [CAT].[REG_0301_Index_Details] ADD  CONSTRAINT [DF_REG_0301_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
GO
