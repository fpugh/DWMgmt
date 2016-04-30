USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Categories_Post]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[REG_Categories] DROP CONSTRAINT [DF_Categories_Post]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[REG_Categories]') AND type in (N'U'))
DROP TABLE [LIB].[REG_Categories]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[REG_Categories]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[REG_Categories](
	[Category_ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[Description] [nvarchar](2000) NOT NULL,
	[Post_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Category_IDKey] UNIQUE NONCLUSTERED 
(
	[Category_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Categories_Post]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[REG_Categories] ADD  CONSTRAINT [DF_Categories_Post]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
