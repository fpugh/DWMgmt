USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ECO].[LNK_1100_1101_Schema_Namespaces](
	[LNK_1100_1101_ID] [int] IDENTITY(1,1) NOT NULL,
	[LNK_FK_1100_ID] [int] NOT NULL,
	[LNK_FK_1101_ID] [int] NOT NULL,
	[LNK_Post_Date] [datetime] NULL,
	[LNK_Term_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_LNK_1100_1101] PRIMARY KEY CLUSTERED 
(
	[LNK_FK_1100_ID] ASC,
	[LNK_FK_1101_ID] ASC,
	[LNK_Term_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_L1100_1101_ID] UNIQUE NONCLUSTERED 
(
	[LNK_1100_1101_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [ECO].[LNK_1100_1101_Schema_Namespaces] ADD  CONSTRAINT [DF_L1100_1101_Post]  DEFAULT (getdate()) FOR [LNK_Post_Date]
GO
ALTER TABLE [ECO].[LNK_1100_1101_Schema_Namespaces] ADD  CONSTRAINT [DF_L1100_1101_Term]  DEFAULT ('12/31/2099') FOR [LNK_Term_Date]
GO
ALTER TABLE [ECO].[LNK_1100_1101_Schema_Namespaces]  WITH CHECK ADD  CONSTRAINT [FK_SN_LNK_1100] FOREIGN KEY([LNK_FK_1100_ID])
REFERENCES [ECO].[REG_1100_XML_Schema_Registry] ([REG_1100_ID])
GO
ALTER TABLE [ECO].[LNK_1100_1101_Schema_Namespaces] CHECK CONSTRAINT [FK_SN_LNK_1100]
GO
