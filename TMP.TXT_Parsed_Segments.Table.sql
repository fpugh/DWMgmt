USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TXT_Parsed_Segments]') AND type in (N'U'))
DROP TABLE [TMP].[TXT_Parsed_Segments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[TXT_Parsed_Segments]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[TXT_Parsed_Segments](
	[Source_ID] [int] NOT NULL,
	[Category] [nvarchar](256) NULL,
	[Word] [nvarchar](256) NULL,
	[Anchor] [int] NOT NULL,
	[Bound] [int] NOT NULL,
	[Segment] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
