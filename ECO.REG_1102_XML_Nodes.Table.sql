USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[ECO].[DF_R1102_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [ECO].[REG_1102_XML_Nodes] DROP CONSTRAINT [DF_R1102_CDate]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ECO].[REG_1102_XML_Nodes]') AND type in (N'U'))
DROP TABLE [ECO].[REG_1102_XML_Nodes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ECO].[REG_1102_XML_Nodes]') AND type in (N'U'))
BEGIN
CREATE TABLE [ECO].[REG_1102_XML_Nodes](
	[REG_1102_ID] [int] IDENTITY(1,1) NOT NULL,
	[REG_Node_Name] [nvarchar](256) NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_REG_1102] PRIMARY KEY CLUSTERED 
(
	[REG_Node_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_R1102_ID] UNIQUE NONCLUSTERED 
(
	[REG_1102_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[ECO].[DF_R1102_CDate]') AND type = 'D')
BEGIN
ALTER TABLE [ECO].[REG_1102_XML_Nodes] ADD  CONSTRAINT [DF_R1102_CDate]  DEFAULT (getdate()) FOR [REG_Create_Date]
END

GO