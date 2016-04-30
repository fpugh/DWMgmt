USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0600_Post]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0600_Object_Code_Library] DROP CONSTRAINT [DF_REG_0600_Post]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0600_Object_Code_Library]') AND type in (N'U'))
DROP TABLE [CAT].[REG_0600_Object_Code_Library]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0600_Object_Code_Library]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[REG_0600_Object_Code_Library](
	[REG_0600_ID] [int] IDENTITY(1,1) NOT NULL,
	[REG_Code_Base] [nvarchar](25) NOT NULL,
	[REG_Code_Content] [nvarchar](4000) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [UQ_REG_0600_ID] UNIQUE NONCLUSTERED 
(
	[REG_0600_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0600_Post]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0600_Object_Code_Library] ADD  CONSTRAINT [DF_REG_0600_Post]  DEFAULT (getdate()) FOR [REG_Create_Date]
END

GO
