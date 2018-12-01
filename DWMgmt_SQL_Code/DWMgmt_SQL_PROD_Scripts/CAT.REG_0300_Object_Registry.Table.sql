USE [DWMgmt]
GO

CREATE TABLE [CAT].[REG_0300_Object_Registry](
	[REG_0300_ID] [int] IDENTITY(1,1) NOT NULL,
	[REG_Object_Name] [nvarchar](256) NOT NULL,
	[REG_Object_Type] [nvarchar](25) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_REG_0300] PRIMARY KEY CLUSTERED 
(
	[REG_Object_Name] ASC,
	[REG_Object_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

, CONSTRAINT [UQ_REG_0300_ID] UNIQUE NONCLUSTERED 
(
	[REG_0300_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [CAT].[REG_0300_Object_Registry] ADD  CONSTRAINT [DF_REG_0300_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
GO

CREATE NONCLUSTERED INDEX [idx_nc_REG_0300_K3_I1_2]
ON [CAT].[REG_0300_Object_Registry] ([REG_Object_Type])
INCLUDE ([REG_0300_ID],[REG_Object_Name])
GO