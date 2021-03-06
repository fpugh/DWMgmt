USE [DWMgmt]
GO


CREATE TABLE [CAT].[REG_0205_Database_Maintenance_Properties](
	[REG_0205_ID] [int] IDENTITY(1,1) NOT NULL,
	[REG_Task_Type] [nvarchar](256) NOT NULL,
	[REG_Task_Group] [nvarchar](256) NOT NULL,
	[REG_Task_Name] [nvarchar](256) NOT NULL,
	[REG_Task_Proc] [nvarchar](256) NOT NULL,
	[REG_Task_Desc] [nvarchar](256) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
	[REG_Exec_Template] [nvarchar](4000) NULL,
 CONSTRAINT [PK_REG_0205] PRIMARY KEY CLUSTERED 
(
	[REG_Task_Type] ASC,
	[REG_Task_Group] ASC,
	[REG_Task_Name] ASC,
	[REG_Task_Proc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0205_ID] UNIQUE NONCLUSTERED 
(
	[REG_0205_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [CAT].[REG_0205_Database_Maintenance_Properties] ADD  CONSTRAINT [DF_REG_0205_Type]  DEFAULT ('Maintenance') FOR [REG_Task_Type]
GO

ALTER TABLE [CAT].[REG_0205_Database_Maintenance_Properties] ADD  CONSTRAINT [DF_REG_0205_Group]  DEFAULT ('Unspecified') FOR [REG_Task_Group]
GO

ALTER TABLE [CAT].[REG_0205_Database_Maintenance_Properties] ADD  CONSTRAINT [DF_REG_0205_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
GO

