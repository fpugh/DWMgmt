USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CAT].[REG_0302_Foreign_Key_Details](
	[REG_0302_ID] [int] IDENTITY(1,1) NOT NULL,
	[Is_ms_shipped] [bit] NOT NULL,
	[Is_hypothetical] [bit] NOT NULL,
	[Is_Published] [bit] NOT NULL,
	[Is_Schema_Published] [bit] NOT NULL,
	[Is_Disabled] [bit] NOT NULL,
	[Is_not_trusted] [bit] NOT NULL,
	[Is_not_for_replication] [bit] NOT NULL,
	[Is_System_Named] [bit] NOT NULL,
	[delete_referential_action] [tinyint] NOT NULL,
	[update_referential_action] [tinyint] NOT NULL,
	[Key_Index_ID] [int] NOT NULL,
	[principal_ID] [int] NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_REG_0302] PRIMARY KEY CLUSTERED 
(
	[Is_ms_shipped] ASC,
	[Is_hypothetical] ASC,
	[Is_Published] ASC,
	[Is_Schema_Published] ASC,
	[Is_Disabled] ASC,
	[Is_not_trusted] ASC,
	[Is_not_for_replication] ASC,
	[Is_System_Named] ASC,
	[delete_referential_action] ASC,
	[update_referential_action] ASC,
	[Key_Index_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0302_ID] UNIQUE NONCLUSTERED 
(
	[REG_0302_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_msshipped]  DEFAULT ('false') FOR [Is_ms_shipped]
GO
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_hypothetical]  DEFAULT ('false') FOR [Is_hypothetical]
GO
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_Published]  DEFAULT ('false') FOR [Is_Published]
GO
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_schmpub]  DEFAULT ('false') FOR [Is_Schema_Published]
GO
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_Disabled]  DEFAULT ('false') FOR [Is_Disabled]
GO
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_nottrust]  DEFAULT ('false') FOR [Is_not_trusted]
GO
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_notreplicate]  DEFAULT ('true') FOR [Is_not_for_replication]
GO
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_sysnamed]  DEFAULT ('true') FOR [Is_System_Named]
GO
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_delref]  DEFAULT ((0)) FOR [delete_referential_action]
GO
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_updtref]  DEFAULT ((0)) FOR [update_referential_action]
GO
ALTER TABLE [CAT].[REG_0302_Foreign_Key_Details] ADD  CONSTRAINT [DF_REG_0302_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
GO
