USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0400_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0400_Column_registry] DROP CONSTRAINT [DF_REG_0400_CDate]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0400_Column_registry]') AND type in (N'U'))
DROP TABLE [CAT].[REG_0400_Column_registry]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[REG_0400_Column_registry]') AND type in (N'U'))
BEGIN
CREATE TABLE [CAT].[REG_0400_Column_registry](
	[REG_0400_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[REG_Column_Name] [nvarchar](256) NOT NULL,
	[REG_Column_Type] [nvarchar](25) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_REG_0400] PRIMARY KEY CLUSTERED 
(
	[REG_Column_Name] ASC,
	[REG_Column_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0400_ID] UNIQUE NONCLUSTERED 
(
	[REG_0400_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[CAT].[DF_REG_0400_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [CAT].[REG_0400_Column_registry] ADD  CONSTRAINT [DF_REG_0400_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
END

GO
