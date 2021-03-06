USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LIB].[REG_Alphabet](
	[ASCII_Char] [tinyint] NOT NULL,
	[Char_Val] [nchar](1) NOT NULL,
	[Printable] [bit] NOT NULL,
	[Post_Date] [datetime] NOT NULL,
	[Class_VCNS] [nchar](1) NULL,
 CONSTRAINT [PK_Alphabet] PRIMARY KEY CLUSTERED 
(
	[ASCII_Char] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [LIB].[REG_Alphabet] ADD  CONSTRAINT [DF_Alphabet_Print]  DEFAULT ((0)) FOR [Printable]
GO
ALTER TABLE [LIB].[REG_Alphabet] ADD  CONSTRAINT [DF_Alphabet_Post]  DEFAULT (getdate()) FOR [Post_Date]
GO
ALTER TABLE [LIB].[REG_Alphabet] ADD  DEFAULT ('C') FOR [Class_VCNS]
GO
