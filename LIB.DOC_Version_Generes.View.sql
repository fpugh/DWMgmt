USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[DOC_Version_Generes]'))
DROP VIEW [LIB].[DOC_Version_Generes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[DOC_Version_Generes]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [LIB].[DOC_Version_Generes]
AS
SELECT dense_Rank() OVER (ORDER BY count(Version_Stamp) - 1 DESC, min(Source_ID)) AS tbl_ID
, ''substring(Version_Stamp,3,9)'' as Lens
, substring(Version_Stamp,3,9) as Version_Genere
, min(Source_ID) as Major_Source
, count(Version_Stamp) - 1 as Minor_Versions
FROM LIB.REG_Sources
GROUP BY substring(Version_Stamp,3,9)
' 
GO
