USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ECO].[REG_1103_XML_Node_Properties](
	[REG_1103_ID] [int] IDENTITY(1,1) NOT NULL,
	[REG_Property_Name] [nvarchar](256) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [pk_REG_1103] PRIMARY KEY CLUSTERED 
(
	[REG_Property_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_R1103_ID] UNIQUE NONCLUSTERED 
(
	[REG_1103_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [ECO].[REG_1103_XML_Node_Properties] ADD  CONSTRAINT [DF_R1103_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
GO
