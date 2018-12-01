USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LIB].[REG_Graphemes](
	[Graph_ID] [int] IDENTITY(1,1) NOT NULL,
	[ASCII_Char1] [tinyint] NOT NULL,
	[ASCII_Char2] [tinyint] NOT NULL,
	[Post_Date] [datetime] NOT NULL,
	[Use_Class] [nchar](2) NOT NULL,
 CONSTRAINT [PK_LIB_Graphemes] PRIMARY KEY NONCLUSTERED 
(
	[ASCII_Char1] ASC,
	[ASCII_Char2] ASC,
	[Use_Class] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Morphemes_IDKey] UNIQUE NONCLUSTERED 
(
	[Graph_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [LIB].[REG_Graphemes] ADD  CONSTRAINT [DF_Morphemes_Post]  DEFAULT (getdate()) FOR [Post_Date]
GO
ALTER TABLE [LIB].[REG_Graphemes] ADD  DEFAULT ('FS') FOR [Use_Class]
GO
ALTER TABLE [LIB].[REG_Graphemes]  WITH CHECK ADD  CONSTRAINT [FK_Morphemes_Alphabet1] FOREIGN KEY([ASCII_Char1])
REFERENCES [LIB].[REG_Alphabet] ([ASCII_Char])
GO
ALTER TABLE [LIB].[REG_Graphemes] CHECK CONSTRAINT [FK_Morphemes_Alphabet1]
GO
ALTER TABLE [LIB].[REG_Graphemes]  WITH CHECK ADD  CONSTRAINT [FK_Morphemes_Alphabet2] FOREIGN KEY([ASCII_Char2])
REFERENCES [LIB].[REG_Alphabet] ([ASCII_Char])
GO
ALTER TABLE [LIB].[REG_Graphemes] CHECK CONSTRAINT [FK_Morphemes_Alphabet2]
GO
