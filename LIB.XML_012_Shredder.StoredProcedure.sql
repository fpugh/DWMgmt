USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[XML_012_Shredder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [LIB].[XML_012_Shredder]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[XML_012_Shredder]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [LIB].[XML_012_Shredder]
  --DECLARE
 @ExecuteStatus INT = 2


AS


/* Replace CRLF place holder characters */

SET NOCOUNT ON

WHILE (
	SELECT MAX(CHARINDEX(CHAR(13)+CHAR(10), String))
	FROM TMP.XML_Process_Hash
	) > 0
OR (
	SELECT MAX(CHARINDEX(CHAR(9), String))
	FROM TMP.XML_Process_Hash
	) > 0
BEGIN
	UPDATE TMP.XML_Process_Hash SET String = REPLACE(REPLACE(REPLACE(String, CHAR(13), ''�''), CHAR(9), '' ''), CHAR(10), '' '')
END

IF @ExecuteStatus <> 2 SET NOCOUNT OFF


/* Apply clean indexes to map prior to shredding */

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = ''pk_XMLStringMap'')
BEGIN
	ALTER TABLE [TMP].[XML_String_Map] ADD  CONSTRAINT [pk_XMLStringMap] PRIMARY KEY CLUSTERED 
	([Source_ID] ASC,[Char_Pos] ASC) 
	ON [PRIMARY]
END


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = ''tdx_nc_XMLStringMap_K3_I4'')
BEGIN
	CREATE NONCLUSTERED INDEX [tdx_nc_XMLStringMap_K3_I4] ON [TMP].[XML_String_Map] 
	([Char_Pos] ASC)
	INCLUDE ([ASCII_Char]) 
	ON [PRIMARY]
END


/* Drop extant indexes on process table */

IF EXISTS (SELECT * FROM sys.indexes WHERE name = N''pk_XMLParsedSegments'')
BEGIN
	ALTER TABLE [TMP].[XML_Parsed_Segments] DROP CONSTRAINT [pk_XMLParsedSegments]
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = N''tdx_nc_XMLParsedSegments_K3_I4_I6'')
BEGIN
	DROP INDEX [tdx_nc_XMLParsedSegments_K3_I4_I6] ON [TMP].[XML_Parsed_Segments] 
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = N''tdx_nc_XMLParsedSegments_K2_I1_I3_I4_I6'')
BEGIN
	DROP INDEX [tdx_nc_XMLParsedSegments_K2_I1_I3_I4_I6] ON [TMP].[XML_Parsed_Segments] 
END


IF NOT EXISTS (SELECT * FROM sys.all_objects WHERE name = N''XML_Property_Map'')
BEGIN
	CREATE TABLE TMP.XML_Property_Map (Source_ID INT NOT NULL, Value_Anchor INT NOT NULL, Value_Bound INT NOT NULL
		, Property_Anchor INT NOT NULL, Node_Name NVARCHAR(256) NOT NULL, Property_Rank INT NOT NULL
		, Property NVARCHAR(256) NOT NULL, Sub_Segment NVARCHAR(4000))
END
ELSE
BEGIN
	TRUNCATE TABLE TMP.XML_Property_Map
END


/* This is the procedure prototype for XML document shredding
	This should successfully shred ANY XML document into manageable
	content for analysis. The primary objective is to create
	a registry of XML content suffiencient to generate SSIS based ETL
	routines, and/or XPath style queries programatically. */

--	TRUNCATE TABLE TMP.XML_Parsed_Segments
--  TRUNCATE TABLE TMP.XML_Property_Map
--  TRUNCATE TABLE TMP.XML_String_Map

/** #CodeBounds is a paraclete useful in discretizing sources within a workstack **/

IF NOT EXISTS (SELECT name FROM tempdb.sys.tables WHERE name like ''#CodeBounds%'')
BEGIN
	CREATE TABLE #CodeBounds (Source_ID int, Map_Anchor int, Map_Bound int)
END

INSERT INTO #CodeBounds (Source_ID, Map_Anchor, Map_Bound)
SELECT Source_ID, min(Char_Pos), max(Char_Pos)
FROM TMP.XML_String_Map AS map with(nolock)
GROUP BY Source_ID


/** Load node code into generic TMP_ParsedSegments for work stack processing **/

; WITH Lines (Source_ID, Line_Rank, Line_Anchor, Line_Bound)
AS (
	SELECT t1.Source_ID, t1.Line_Rank, t1.Char_Pos as Line_Anchor
	, min(isnull(t2.Char_Pos, TMP.Map_Bound+1)) as Line_Bound
	FROM (
		SELECT t1.Source_ID, t1.Char_Pos, DENSE_RANK() over (partition by t1.Source_ID order by t1.Char_Pos) as Line_Rank
		FROM TMP.XML_String_Map AS t1 with(nolock)
		WHERE (t1.ASCII_Char = 60
		OR t1.Char_Pos = 1)
		) AS t1
	LEFT JOIN (
		SELECT t2.Source_ID, t2.Char_Pos, DENSE_RANK() over (partition by t2.Source_ID order by t2.Char_Pos) as Line_Rank
		FROM TMP.XML_String_Map AS t2 with(nolock)
		WHERE t2.ASCII_Char = 62
		) AS t2
	ON t2.Source_ID = t1.Source_ID
	AND t2.Char_Pos > t1.Char_Pos
	JOIN #CodeBounds AS tmp
	ON TMP.Source_ID = t1.Source_ID
	GROUP BY t1.Source_ID, t1.Line_Rank, t1.Char_Pos
	)

INSERT INTO TMP.XML_Parsed_Segments (Source_ID, Category, Word, Anchor, Bound, Segment)

SELECT DISTINCT cte.Source_ID
, ''Nodes'', ''<>'', cte.Line_Anchor, cte.Line_Bound
, substring(stk.String, cte.Line_Anchor, (cte.Line_Bound - cte.Line_Anchor) + 1 )
FROM Lines AS cte
JOIN TMP.XML_Process_Hash AS stk
ON stk.Source_ID = cte.Source_ID
ORDER BY cte.Source_ID, cte.Line_Anchor


/**	Identify Nodes w/ Sort - Check for pseudo-cardinality	
		Node_Class cast as nvarchar(65) as there may be use of the tag 
		as an identifier with standind id values for the # wildcard
		
		--TRUNCATE TABLE TMP.XML_Nodes
		
		CREATE TABLE TMP.XML_Nodes (Source_ID INT NOT NULL, Node_Name NVARCHAR(256) NOT NULL, Node_Level INT NOT NULL, Node_Class NVARCHAR(65) NOT NULL, Anchor BIGINT NOT NULL, Bound BIGINT NOT NULL)
		
		IF NOT EXISTS (SELECT Name FROM sys.indexes WHERE name = ''pk_XMLNodes'')
		BEGIN
			ALTER TABLE TMP.XML_Nodes ADD CONSTRAINT pk_XMLNodes PRIMARY KEY CLUSTERED (Source_ID, Anchor)
		END
**/

; WITH Nodes (Source_ID, Node_Name, Node_Class, Anchor, Bound)
AS (
	SELECT Source_ID, REPLACE(REPLACE(Segment, ''</'',''''),''>'','''') AS Node_Name
	, CAST(''</#>'' as NVARCHAR(65)) as Node_Class
	, Anchor, Bound
	FROM TMP.XML_Parsed_Segments WITH(NOLOCK)
	WHERE CHARINDEX(''</'',Segment) > 0
	UNION
	SELECT Source_ID, SUBSTRING(Segment, 2, CHARINDEX(''�'',Segment)-2) as Node_Name
	, CAST(''<#/>'' as NVARCHAR(65)) as Node_Class
	, Anchor, Bound
	FROM TMP.XML_Parsed_Segments WITH(NOLOCK)
	WHERE CHARINDEX(''/>'',Segment) > 0
	AND CHARINDEX(''�'', Segment) > 0
	UNION
	SELECT Source_ID, SUBSTRING(Segment, 2, CHARINDEX(CHAR(32),Segment)-2) as Node_Name
	, CAST(''<#/>'' as NVARCHAR(65)) as Node_Class
	, Anchor, Bound
	FROM TMP.XML_Parsed_Segments WITH(NOLOCK)
	WHERE CHARINDEX(''/>'',Segment) > 0
	AND CHARINDEX(''�'', Segment) = 0
	)

INSERT INTO TMP.XML_Nodes (Source_ID, Node_Name, Node_Level, Node_Class, Anchor, Bound)

SELECT Source_ID, RTRIM(LTRIM(Node_Name)) as Node_Name, 0 as Node_Level, Node_Class, Anchor, Bound
FROM Nodes
UNION ALL
SELECT DISTINCT T1.Source_ID, R1.Node_Name as Node_Name, 0 as Node_Level
, CAST(''<#>'' as NVARCHAR(65)) as Node_Class
, T1.Anchor, T1.Bound
FROM TMP.XML_Parsed_Segments AS T1 WITH(NOLOCK)
CROSS APPLY Nodes AS R1
WHERE R1.Source_ID = T1.Source_ID
AND R1.Node_Name = SUBSTRING(T1.Segment,2,LEN(R1.Node_Name))
AND LEFT(T1.Segment,2) <> ''</''
AND RIGHT(T1.Segment,2) <> ''/>''
AND PATINDEX(''<''+R1.Node_Name+''[a-zA-Z.:]%'', T1.Segment) = 0
ORDER BY Source_ID, Anchor, Bound


/** Assign node levels to derive heirarchy
	- Create a clustered primary key on the Source_ID and Anchor
	- Use Asynchronous Updated Query to provision node level
	- XPath Query can be built from this structure
**/

SET NOCOUNT ON

DECLARE @Source_ID INT
, @Node_Level INT

UPDATE tmp SET @Node_Level = Node_Level = 
	CASE WHEN @Source_ID = Source_ID
		AND Node_Class = ''<#>'' THEN @Node_Level + 1
		WHEN @Source_ID = Source_ID
		AND Node_Class = ''<#/>'' THEN @Node_Level
		WHEN @Source_ID = Source_ID
		AND Node_Class = ''</#>'' THEN @Node_Level - 1
		ELSE 1 END
, @Source_ID = Source_ID
FROM TMP.XML_Nodes AS tmp WITH(TABLOCKX)
OPTION (MAXDOP 1)

IF @ExecuteStatus <> 2 SET NOCOUNT OFF


/*** Self-Terminating nodes live one layer below their host ***/

UPDATE TMP.XML_Nodes SET Node_Level = Node_Level+1
WHERE Node_Class = ''<#/>''


/** Identify and stage Namespaces 
	-- These can be parsed explicitly, and are necessary for latter shred steps
	-- They require the addition of a property value to fully log due to primary key constraints
**/

IF EXISTS (SELECT * FROM tempdb.sys.all_objects WHERE name like N''#Name_Space_Stage%'')
DROP TABLE #Name_Space_Stage

SELECT DISTINCT Source_ID
, SUBSTRING(Segment
	, PATINDEX(''%xmlns:%=%'', Segment)+6
		, CHARINDEX(''='', Segment
		, PATINDEX(''%xmlns:%=%'', Segment))-(CHARINDEX(''xmlns:'', Segment)+6)
		) as Name_Space
INTO #Name_Space_Stage
FROM TMP.XML_Parsed_Segments AS T1 WITH(NOLOCK)
WHERE PATINDEX(''%xmlns:%=%'', Segment) > 0


/** Insert Schema Nodes **/

INSERT INTO ECO.REG_1102_XML_Nodes (REG_Node_Name)

SELECT DISTINCT REPLACE(T1.Node_Name, ISNULL(S1.Name_Space,''''),'''') as Node_Name
FROM TMP.XML_Nodes AS T1 WITH(NOLOCK)
LEFT JOIN (
	SELECT Source_ID, Name_Space+'':'' as Name_Space
	FROM #Name_Space_Stage
	) AS S1
ON S1.Source_ID = T1.Source_ID
AND CHARINDEX(S1.Name_Space, T1.Node_Name) > 0
LEFT JOIN ECO.REG_1102_XML_Nodes AS T2 WITH(NOLOCK)
ON T2.REG_Node_Name = REPLACE(T1.Node_Name, ISNULL(S1.Name_Space,''''),'''')
WHERE T2.REG_1102_ID IS NULL


/** Process and insert node properties **/

IF EXISTS (SELECT * FROM tempdb.sys.all_objects WHERE name like N''#Property_Bridge%'')
DROP TABLE #Property_Bridge

SELECT S1.Source_ID, S1.Value_Anchor, MIN(M3.Char_Pos) as Value_Bound, 0 as Property_Anchor
INTO #Property_Bridge
FROM (
	SELECT M1.Source_ID, M2.Char_Pos as Value_Anchor
	FROM TMP.XML_String_Map AS M1 WITH(NOLOCK)
	JOIN TMP.XML_String_Map AS M2 WITH(NOLOCK)
	ON M2.Source_ID = M1.Source_ID
	AND M2.Char_Pos = M1.Char_Pos + 1
	WHERE M1.ASCII_Char = ASCII(''='')
	AND M2.ASCII_Char = ASCII(''"'')
	) AS S1
JOIN TMP.XML_String_Map AS M3 WITH(NOLOCK)
ON M3.Source_ID = S1.Source_ID
AND M3.Char_Pos > S1.Value_Anchor
WHERE M3.ASCII_Char = ASCII(''"'')
GROUP BY S1.Source_ID, S1.Value_Anchor


CREATE NONCLUSTERED INDEX tdx_nc_PropertyBridge ON #Property_Bridge ([Source_ID]) INCLUDE (Value_Anchor,Value_Bound,Property_Anchor)
' 
END
GO
