USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0102_Publication_Replication_Server_Settings]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0102_Publication_Replication_Server_Settings]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0102_Publication_Replication_Server_Settings]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0102_Publication_Replication_Server_Settings](
	[REG_0102_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[REG_Lazy_Schema_Flag] [bit] NOT NULL,
	[REG_Publisher_Flag] [bit] NOT NULL,
	[REG_Subscriber_Flag] [bit] NOT NULL,
	[REG_Distributor_Flag] [bit] NOT NULL,
	[REG_NonSQL_Subcriber_Flag] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
