USE [DWMgmt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TMP].[REG_0500_0501_Insert](
	[LNK_T2_ID] [int] NULL,
	[LNK_T3_ID] [int] NULL,
	[REG_0300_ID] [int] NULL,
	[REG_0500_ID] [int] NULL,
	[REG_0501_ID] [int] NULL,
	[Server_ID] [int] NOT NULL,
	[Database_ID] [int] NULL,
	[Object_ID] [int] NULL,
	[Parameter_name] [nvarchar](256) NULL,
	[Parameter_Type] [int] NULL,
	[rank] [int] NULL,
	[size] [int] NULL,
	[scale] [int] NULL,
	[is_input] [bit] NULL,
	[is_output] [bit] NULL,
	[is_cursor_ref] [bit] NULL,
	[has_default_value] [bit] NULL,
	[is_xml_document] [bit] NULL,
	[is_readonly] [bit] NULL,
	[default_value] [nvarchar](max) NULL,
	[xml_collection_ID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [TMP].[REG_0500_0501_Insert] ADD  CONSTRAINT [DF_0500_0501_Server_ID]  DEFAULT ((0)) FOR [Server_ID]
GO
