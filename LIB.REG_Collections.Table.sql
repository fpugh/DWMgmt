USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Collections_Post]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[REG_Collections] DROP CONSTRAINT [DF_Collections_Post]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[REG_Collections]') AND type in (N'U'))
DROP TABLE [LIB].[REG_Collections]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[REG_Collections]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[REG_Collections](
	[Collection_ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[Description] [nvarchar](4000) NULL,
	[Curator] [nvarchar](256) NULL,
	[Post_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_LIB_Collections] PRIMARY KEY CLUSTERED 
(
	[Collection_ID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Collections_IDKey] UNIQUE NONCLUSTERED 
(
	[Collection_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Collections_Post]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[REG_Collections] ADD  CONSTRAINT [DF_Collections_Post]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
