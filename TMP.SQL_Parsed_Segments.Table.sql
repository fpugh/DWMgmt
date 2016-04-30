USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[SQL_Parsed_Segments]') AND name = N'tdx_nc_ParsedSegments_K3_I4_I6')
DROP INDEX [tdx_nc_ParsedSegments_K3_I4_I6] ON [TMP].[SQL_Parsed_Segments]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[SQL_Parsed_Segments]') AND name = N'tdx_nc_ParsedSegments_K2_I1_I3_I4_I6')
DROP INDEX [tdx_nc_ParsedSegments_K2_I1_I3_I4_I6] ON [TMP].[SQL_Parsed_Segments]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[SQL_Parsed_Segments]') AND type in (N'U'))
DROP TABLE [TMP].[SQL_Parsed_Segments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TMP].[SQL_Parsed_Segments]') AND type in (N'U'))
BEGIN
CREATE TABLE [TMP].[SQL_Parsed_Segments](
	[Source_ID] [int] NOT NULL,
	[Category] [nvarchar](256) NULL,
	[Word] [nvarchar](256) NULL,
	[Anchor] [int] NOT NULL,
	[Bound] [int] NOT NULL,
	[Segment] [nvarchar](max) NULL,
 CONSTRAINT [pk_SQLParsedSegments] PRIMARY KEY CLUSTERED 
(
	[Source_ID] ASC,
	[Anchor] ASC,
	[Bound] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING ON

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[SQL_Parsed_Segments]') AND name = N'tdx_nc_ParsedSegments_K2_I1_I3_I4_I6')
CREATE NONCLUSTERED INDEX [tdx_nc_ParsedSegments_K2_I1_I3_I4_I6] ON [TMP].[SQL_Parsed_Segments]
(
	[Category] ASC
)
INCLUDE ( 	[Source_ID],
	[Word],
	[Anchor],
	[Segment]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TMP].[SQL_Parsed_Segments]') AND name = N'tdx_nc_ParsedSegments_K3_I4_I6')
CREATE NONCLUSTERED INDEX [tdx_nc_ParsedSegments_K3_I4_I6] ON [TMP].[SQL_Parsed_Segments]
(
	[Word] ASC
)
INCLUDE ( 	[Anchor],
	[Segment]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
