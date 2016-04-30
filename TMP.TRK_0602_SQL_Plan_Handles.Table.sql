USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0602_SQL_Plan_Handles]') AND type in (N'U'))
DROP TABLE [TMP].[TRK_0602_SQL_Plan_Handles]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TRK_0602_SQL_Plan_Handles]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[TRK_0602_SQL_Plan_Handles](
	[TRK_FK_T3_ID] [int] NULL,
	[Exec_Target_DBId] [sql_variant] NULL,
	[Exec_Source_DBId] [sql_variant] NULL,
	[Object_ID] [sql_variant] NULL,
	[Object_Name] [nvarchar](256) NULL,
	[Object_Type] [nvarchar](25) NULL,
	[REG_SQL_Compatibility] [sql_variant] NULL,
	[REG_SQL_Handle] [sql_variant] NULL,
	[REG_Plan_Handle] [varbinary](64) NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
