USE [DWMgmt]
GO


CREATE PROCEDURE [LIB].[SQL_012_Shredder]
 @ExecuteStatus INT = 2

AS

IF @ExecuteStatus IN (0,2) SET NOCOUNT ON


/* Clear unprintable characters from SQL_Process_Hash before shredding */ 

SET NOCOUNT ON

WHILE (
	SELECT MAX(CHARINDEX(CHAR(13)+CHAR(10), String))
	FROM TMP.SQL_Process_Hash
	) > 0
OR (
	SELECT MAX(CHARINDEX(CHAR(9), String))
	FROM TMP.SQL_Process_Hash
	) > 0
BEGIN
	UPDATE TMP.SQL_Process_Hash SET String = REPLACE(REPLACE(REPLACE(String, CHAR(13), '¶'), CHAR(9), ' '), CHAR(10), ' ')
END

IF @ExecuteStatus <> 2 SET NOCOUNT OFF


/* Apply clean indexes to map prior to shredding */

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'pk_SQLStringMap')
BEGIN
	ALTER TABLE [TMP].[SQL_String_Map] ADD  CONSTRAINT [pk_SQLStringMap] PRIMARY KEY CLUSTERED 
	([Source_ID] ASC,[Char_Pos] ASC) 
	ON [PRIMARY]
END


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'tdx_nc_SQLStringMap_K3_I4')
BEGIN
	CREATE NONCLUSTERED INDEX [tdx_nc_SQLStringMap_K3_I4] ON [TMP].[SQL_String_Map] 
	([Char_Pos] ASC)
	INCLUDE ([ASCII_Char]) 
	ON [PRIMARY]
END


/* Drop extant indexes on process table */
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'pk_ParsedSegments')
BEGIN
	ALTER TABLE [TMP].[SQL_Parsed_Segments] DROP CONSTRAINT [pk_ParsedSegments]
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'tdx_nc_ParsedSegments_K3_I4_I6')
BEGIN
	DROP INDEX [tdx_nc_ParsedSegments_K3_I4_I6] ON [TMP].[SQL_Parsed_Segments] 
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'tdx_nc_ParsedSegments_K2_I1_I3_I4_I6')
BEGIN
	DROP INDEX [tdx_nc_ParsedSegments_K2_I1_I3_I4_I6] ON [TMP].[SQL_Parsed_Segments] 
END



/* #CodeBounds
	This boundry table is used to delineate the absolute limits of each
	body of code within the SQL_String_Map table. */

SELECT Source_ID, min(Char_Pos) as Map_Anchor, max(Char_Pos) as Map_Bound
INTO #CodeBounds
FROM TMP.SQL_String_Map AS map with(nolock)
GROUP BY Source_ID


/* Setup segments as line delimited slices and insert into SQL_ParsedSegment as initial framwork.
	Additional segments will be derived from 'Lines' Slices. */

; WITH Lines (Source_ID, Line_Rank, Line_Anchor, Line_Bound)
AS (
	SELECT t1.Source_ID, t1.Line_Rank, t1.Char_Pos as Line_Anchor
	, min(isnull(t2.Char_Pos, TMP.Map_Bound)) as Line_Bound
	FROM (
		SELECT t1.Source_ID, t1.Char_Pos, DENSE_Rank() over (partition by t1.Source_ID order by t1.Char_Pos) as Line_Rank
		FROM TMP.SQL_String_Map AS t1 with(nolock)
		WHERE t1.ASCII_Char = 10
		OR t1.Char_Pos = 1	
		) AS t1
	JOIN #CodeBounds AS tmp
	ON TMP.Source_ID = t1.Source_ID
	OUTER APPLY (
		SELECT t2.Source_ID, t2.Char_Pos - 1 as Char_Pos, DENSE_Rank() over (partition by t2.Source_ID order by t2.Char_Pos) as Line_Rank
		FROM TMP.SQL_String_Map AS t2 with(nolock)
		WHERE t2.ASCII_Char = 10
		) AS t2
	WHERE t2.Source_ID = t1.Source_ID
	AND t2.Char_Pos > t1.Char_Pos
	GROUP BY t1.Source_ID, t1.Line_Rank, t1.Char_Pos
	)

INSERT INTO TMP.SQL_Parsed_Segments (Source_ID, Category, Word, Anchor, Bound, Segment)

SELECT DISTINCT cte.Source_ID
, 'Lines', '¶', cte.Line_Anchor, cte.Line_Bound
, substring(stk.String, cte.Line_Anchor, (cte.Line_Bound - cte.Line_Anchor) + 1 )
FROM Lines AS cte
JOIN TMP.SQL_Process_Hash AS stk
ON stk.Source_ID = cte.Source_ID
ORDER BY cte.Source_ID, cte.Line_Anchor


/* Create Primary Key and functional indexes on SQL_Process_Hash */
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'pk_SQLParsedSegments')
BEGIN
	ALTER TABLE [TMP].[SQL_Parsed_Segments] ADD CONSTRAINT [pk_SQLParsedSegments] PRIMARY KEY CLUSTERED 
	([Source_ID] ASC,[Anchor] ASC,[Bound] ASC)
	ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'tdx_nc_ParsedSegments_K3_I4_I6')
BEGIN
	CREATE NONCLUSTERED INDEX [tdx_nc_ParsedSegments_K3_I4_I6] ON [TMP].[SQL_Parsed_Segments] 
	([Word] ASC)
	INCLUDE ([Anchor],[Segment])
	ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'tdx_nc_ParsedSegments_K2_I1_I3_I4_I6')
BEGIN
	CREATE NONCLUSTERED INDEX [tdx_nc_ParsedSegments_K2_I1_I3_I4_I6] ON [TMP].[SQL_Parsed_Segments] 
	([Category] ASC)
	INCLUDE ([Source_ID],[Word],[Anchor],[Segment]) 
	ON [PRIMARY]
END


/* Insert Base Query lines into the catalog code table. */

INSERT INTO CAT.REG_0600_Object_Code_Library (REG_Code_Base, REG_Code_Content)

SELECT DISTINCT 'TSQL'
, T2.Segment COLLATE SQL_Latin1_General_PRef_CP1_CI_AS
FROM TMP.SQL_Process_Hash AS T1 with(nolock)
JOIN TMP.SQL_Parsed_Segments AS T2 with(nolock)
ON T2.Source_ID = T1.Source_ID
JOIN CAT.REG_0300_Object_registry AS ROR with(nolock)
ON ROR.REG_0300_ID = T1.Catalog_ID
LEFT JOIN CAT.REG_0600_Object_Code_Library AS r1 with(nolock)
ON r1.REG_Code_Content COLLATE Latin1_General_CS_AS = T2.Segment
WHERE r1.REG_0600_ID IS NULL


/* Insert line code to catalog object/code link table */

INSERT INTO CAT.LNK_0300_0600_Object_Code_Sections (LNK_fk_T3_ID, LNK_fk_0300_ID, LNK_fk_0600_ID, LNK_Rank)

SELECT sub.LNK_T3_ID
, sub.Catalog_ID
, sub.REG_0600_ID
, sub.LNK_Rank
FROM (
	SELECT DISTINCT T1.LNK_T3_ID
	, T1.Catalog_ID
	, CAT.REG_0600_ID
	, DENSE_RANK() OVER (PARTITION BY T1.Source_ID, T2.Category ORDER BY T2.Anchor) as LNK_Rank
	FROM TMP.SQL_Process_Hash AS T1 with(nolock)
	JOIN TMP.SQL_Parsed_Segments AS T2 with(nolock)
	ON T2.Source_ID = T1.Source_ID
	JOIN CAT.REG_0600_Object_Code_Library AS cat
	ON CAT.REG_Code_Base = 'TSQL'
	AND CAT.REG_Code_Content COLLATE Latin1_General_CS_AS = T2.Segment
	) AS sub


/* Clear out working tables 
This probably should not happen here. There should be a seperate cleanup process
to ensure accidental loss of data during testing does not occur. */

IF @ExecuteStatus = 2
BEGIN

	DELETE T1
	FROM LIB.Internal_String_Intake_Stack AS T1
	JOIN TMP.SQL_Process_Hash AS T2
	ON T2.Version_Stamp = T1.Version_Stamp

	TRUNCATE TABLE TMP.SQL_Parsed_Segments

	TRUNCATE TABLE TMP.SQL_Process_Hash

	TRUNCATE TABLE TMP.SQL_String_Map

END




GO
