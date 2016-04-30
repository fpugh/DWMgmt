USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[DOC_Version_Editions]'))
DROP VIEW [LIB].[DOC_Version_Editions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[DOC_Version_Editions]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [LIB].[DOC_Version_Editions]
AS
SELECT dense_Rank() OVER (ORDER BY count(Version_Stamp) - 1 DESC, min(Source_ID)) AS tbl_ID
, ''left(Version_Stamp,22)'' as Lens
, left(Version_Stamp,22) as Version_Edition
, min(Source_ID) as Major_Source
, count(Version_Stamp) - 1 as Minor_Versions
FROM LIB.REG_Sources
GROUP BY left(Version_Stamp,22)
' 
GO
