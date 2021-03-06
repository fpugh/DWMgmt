USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings](
	[REG_0102_ID] [int] IDENTITY(1,1) NOT NULL,
	[REG_Lazy_Schema_Flag] [bit] NOT NULL,
	[REG_Publisher_Flag] [bit] NOT NULL,
	[REG_Subscriber_Flag] [bit] NOT NULL,
	[REG_Distributor_Flag] [bit] NOT NULL,
	[REG_NonSQL_Subcriber_Flag] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_REG_0102] PRIMARY KEY CLUSTERED 
(
	[REG_Lazy_Schema_Flag] ASC,
	[REG_Publisher_Flag] ASC,
	[REG_Subscriber_Flag] ASC,
	[REG_Distributor_Flag] ASC,
	[REG_NonSQL_Subcriber_Flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0102_ID] UNIQUE NONCLUSTERED 
(
	[REG_0102_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] ADD  CONSTRAINT [DF_REG_0102_K2]  DEFAULT ((0)) FOR [REG_Lazy_Schema_Flag]
GO
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] ADD  CONSTRAINT [DF_REG_0102_K3]  DEFAULT ((0)) FOR [REG_Publisher_Flag]
GO
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] ADD  CONSTRAINT [DF_REG_0102_K4]  DEFAULT ((0)) FOR [REG_Subscriber_Flag]
GO
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] ADD  CONSTRAINT [DF_REG_0102_K5]  DEFAULT ((0)) FOR [REG_Distributor_Flag]
GO
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] ADD  CONSTRAINT [DF_REG_0102_K6]  DEFAULT ((0)) FOR [REG_NonSQL_Subcriber_Flag]
GO
ALTER TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] ADD  CONSTRAINT [DF_REG_0102_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
GO
