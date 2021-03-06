USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CAT].[REG_0501_Parameter_Properties](
	[REG_0501_ID] [int] IDENTITY(1,1) NOT NULL,
	[REG_Size] [int] NOT NULL,
	[REG_Scale] [int] NOT NULL,
	[Is_Input] [bit] NOT NULL,
	[Is_Output] [bit] NOT NULL,
	[Is_cursor_ref] [bit] NOT NULL,
	[has_Default_Value] [bit] NOT NULL,
	[Is_XML_document] [bit] NOT NULL,
	[Is_readonly] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_REG_0501] PRIMARY KEY CLUSTERED 
(
	[REG_Size] ASC,
	[REG_Scale] ASC,
	[Is_Input] ASC,
	[Is_Output] ASC,
	[Is_cursor_ref] ASC,
	[has_Default_Value] ASC,
	[Is_XML_document] ASC,
	[Is_readonly] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0501_ID] UNIQUE NONCLUSTERED 
(
	[REG_0501_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DF0_0501_Size]  DEFAULT ((0)) FOR [REG_Size]
GO
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DFm1_0501_Scale]  DEFAULT ((-1)) FOR [REG_Scale]
GO
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DF0_0501_glbl]  DEFAULT ((0)) FOR [Is_Input]
GO
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DF0_0501_otpt]  DEFAULT ((0)) FOR [Is_Output]
GO
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DF0_0501_csrf]  DEFAULT ((0)) FOR [Is_cursor_ref]
GO
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DF0_0501_dfvl]  DEFAULT ((0)) FOR [has_Default_Value]
GO
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DF0_0501_xmld]  DEFAULT ((0)) FOR [Is_XML_document]
GO
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DF0_0501_read]  DEFAULT ((0)) FOR [Is_readonly]
GO
ALTER TABLE [CAT].[REG_0501_Parameter_Properties] ADD  CONSTRAINT [DFgd_0501_cdate]  DEFAULT (getdate()) FOR [REG_Create_Date]
GO
