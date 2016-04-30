USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[DOC_Version_Series]'))
DROP VIEW [LIB].[DOC_Version_Series]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[DOC_Version_Series]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [LIB].[DOC_Version_Series]
AS
SELECT dense_Rank() OVER (ORDER BY count(Version_Stamp) - 1 DESC, min(Source_ID)) AS tbl_ID
, ''substring(Version_Stamp,3,9)+''''::''''+substring(Version_Stamp, 24, 14)'' as Lens
, substring(Version_Stamp,3,9)+''::''+substring(Version_Stamp, 24, 14) as Version_Series
, min(Source_ID) as MajorSource
, count(Version_Stamp) - 1 as MinorVersions
FROM LIB.REG_Sources
GROUP BY substring(Version_Stamp,3,9)+''::''+substring(Version_Stamp, 24, 14)
' 
GO
