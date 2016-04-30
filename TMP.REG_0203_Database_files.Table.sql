USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0203_Database_files]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0203_Database_files]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0203_Database_files]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0203_Database_files](
	[REG_0203_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[REG_File_ID] [int] NOT NULL,
	[REG_File_Type] [nvarchar](50) NOT NULL,
	[REG_File_Name] [nvarchar](512) NOT NULL,
	[REG_File_Location] [nvarchar](512) NOT NULL,
	[reg_File_Max_Size] [int] NOT NULL,
	[REG_File_Growth] [int] NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
