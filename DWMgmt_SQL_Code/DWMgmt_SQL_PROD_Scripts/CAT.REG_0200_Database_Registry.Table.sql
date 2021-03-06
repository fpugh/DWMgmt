USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CAT].[REG_0200_Database_Registry](
	[REG_0200_ID] [int] IDENTITY(1,1) NOT NULL,
	[REG_Database_Name] [nvarchar](256) NOT NULL,
	[REG_Compatibility] [tinyint] NOT NULL,
	[REG_Collation] [nvarchar](65) NOT NULL,
	[REG_Recovery_Model] [nvarchar](65) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
	[REG_Managed] [bit] NOT NULL,
 CONSTRAINT [PK_REG_0200] PRIMARY KEY CLUSTERED 
(
	[REG_Database_Name] ASC,
	[REG_Compatibility] ASC,
	[REG_Collation] ASC,
	[REG_Recovery_Model] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_REG_0200_KeyID] UNIQUE NONCLUSTERED 
(
	[REG_0200_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [CAT].[REG_0200_Database_Registry] ADD  CONSTRAINT [DF_REG_0200_Collate]  DEFAULT ('database default') FOR [REG_Collation]
GO
ALTER TABLE [CAT].[REG_0200_Database_Registry] ADD  CONSTRAINT [DF_REG_0200_Recovery]  DEFAULT ('simple') FOR [REG_Recovery_Model]
GO
ALTER TABLE [CAT].[REG_0200_Database_Registry] ADD  CONSTRAINT [DF_REG_0200_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
GO
ALTER TABLE [CAT].[REG_0200_Database_Registry] ADD  CONSTRAINT [DF_REG_0200_Managed]  DEFAULT ((0)) FOR [REG_Managed]
GO
