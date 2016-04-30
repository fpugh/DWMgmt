USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_TRK_0440_Colum_Statistics]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[TRK_0440_Column_Statistics] DROP CONSTRAINT [DF_TRK_0440_Colum_Statistics]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0440_Column_Statistics]') AND type in (N'U'))
DROP TABLE [TMP].[TRK_0440_Column_Statistics]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0440_Column_Statistics]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[TRK_0440_Column_Statistics](
	[TRK_TBL_ID] [int] IDENTITY(1,1) NOT NULL,
	[TRK_Post_Date] [datetime] NOT NULL,
	[TRK_Server_ID] [int] NOT NULL,
	[TRK_Server_Name] [nvarchar](256) NULL,
	[TRK_Database_ID] [int] NOT NULL,
	[TRK_Database_Name] [nvarchar](256) NULL,
	[TRK_Schema_ID] [int] NOT NULL,
	[TRK_Schema_Name] [nvarchar](256) NULL,
	[TRK_Object_ID] [int] NOT NULL,
	[TRK_Object_Name] [nvarchar](256) NOT NULL,
	[TRK_Column_ID] [int] NOT NULL,
	[TRK_Column_Name] [nvarchar](256) NOT NULL,
	[TRK_Stats_ID] [int] NOT NULL,
	[TRK_Stats_Column_ID] [int] NOT NULL,
	[TRK_Stats_Name] [nvarchar](256) NOT NULL,
	[TRK_Auto_Created] [bit] NOT NULL,
	[TRK_User_Created] [bit] NOT NULL,
	[TRK_No_Recompute] [bit] NOT NULL,
	[TRK_Has_Filter] [bit] NOT NULL,
	[TRK_Filter_Definition] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[TMP].[DF_TRK_0440_Colum_Statistics]') AND type = 'D')
BEGIN
ALTER TABLE [TMP].[TRK_0440_Column_Statistics] ADD  CONSTRAINT [DF_TRK_0440_Colum_Statistics]  DEFAULT (getdate()) FOR [TRK_Post_Date]
END

GO
