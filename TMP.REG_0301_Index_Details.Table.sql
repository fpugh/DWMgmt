USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0301_Index_Details]') AND type in (N'U'))
DROP TABLE [TMP].[REG_0301_Index_Details]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[REG_0301_Index_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[REG_0301_Index_Details](
	[REG_0301_ID] [int] NOT NULL,
	[Local_ID] [int] NOT NULL,
	[filter_definition] [nvarchar](max) NULL,
	[data_space_id] [int] NOT NULL,
	[fill_factor] [tinyint] NOT NULL,
	[is_unique] [bit] NOT NULL,
	[ignore_dup_key] [bit] NOT NULL,
	[is_primary_key] [bit] NOT NULL,
	[is_unique_constraint] [bit] NOT NULL,
	[is_padded] [bit] NOT NULL,
	[is_disabled] [bit] NOT NULL,
	[is_hypothetical] [bit] NOT NULL,
	[allow_row_locks] [bit] NOT NULL,
	[allow_page_locks] [bit] NOT NULL,
	[REG_Create_Date] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
