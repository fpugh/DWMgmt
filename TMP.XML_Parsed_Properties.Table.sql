USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[XML_Parsed_Properties]') AND type in (N'U'))
DROP TABLE [TMP].[XML_Parsed_Properties]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[XML_Parsed_Properties]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[XML_Parsed_Properties](
	[Node_Name] [nvarchar](256) NOT NULL,
	[Segment] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
