

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
	UPDATE TMP.XML_Process_Hash SET String = REPLACE(REPLACE(REPLACE(String, CHAR(13), '¶'), CHAR(9), ' '), CHAR(10), ' ')
END

IF @ExecuteStatus <> 2 SET NOCOUNT OFF


/* Apply clean indexes to map prior to shredding */

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'pk_XMLStringMap')
BEGIN
	ALTER TABLE [TMP].[XML_String_Map] ADD  CONSTRAINT [pk_XMLStringMap] PRIMARY KEY CLUSTERED 
	([Source_ID] ASC,[Char_Pos] ASC) 
	ON [PRIMARY]
END


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'tdx_nc_XMLStringMap_K4_I2_I3')
BEGIN
	CREATE NONCLUSTERED INDEX [tdx_nc_XMLStringMap_K4_I2_I3]
	ON [TMP].[XML_String_Map] ([ASCII_Char])
	INCLUDE ([Source_ID],[Char_Pos])
	ON [PRIMARY]
END



/* Drop extant indexes on process table */

IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'pk_XMLParsedSegments')
BEGIN
	ALTER TABLE [TMP].[XML_Parsed_Segments] DROP CONSTRAINT [pk_XMLParsedSegments]
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'tdx_nc_XMLParsedSegments_K3_I4_I6')
BEGIN
	DROP INDEX [tdx_nc_XMLParsedSegments_K3_I4_I6] ON [TMP].[XML_Parsed_Segments] 
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'tdx_nc_XMLParsedSegments_K2_I1_I3_I4_I6')
BEGIN
	DROP INDEX [tdx_nc_XMLParsedSegments_K2_I1_I3_I4_I6] ON [TMP].[XML_Parsed_Segments] 
END


IF NOT EXISTS (SELECT * FROM sys.all_objects WHERE name = N'XML_Property_Map')
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

IF NOT EXISTS (SELECT name FROM tempdb.sys.tables WHERE name like '#CodeBounds%')
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
, 'Nodes', '<>', cte.Line_Anchor, cte.Line_Bound
, substring(stk.String, cte.Line_Anchor, (cte.Line_Bound - cte.Line_Anchor) + 1 )
FROM Lines AS cte
JOIN TMP.XML_Process_Hash AS stk
ON stk.Source_ID = cte.Source_ID
ORDER BY cte.Source_ID, cte.Line_Anchor




IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'tdx_nc_XMLStringMap_K1_K4_I5')
BEGIN
	CREATE NONCLUSTERED INDEX [tdx_nc_XMLStringMap_K1_K4_I5]
	ON [TMP].[XML_Parsed_Segments] ([Source_ID],[Anchor])
	INCLUDE ([Bound])
END


/**	Identify Nodes w/ Sort - Check for pseudo-cardinality	
		Node_Class cast as nvarchar(65) as there may be use of the tag 
		as an identifier with standind id values for the # wildcard
		
		--TRUNCATE TABLE TMP.XML_Nodes
		
		CREATE TABLE TMP.XML_Nodes (Source_ID INT NOT NULL, Node_Name NVARCHAR(256) NOT NULL, Node_Level INT NOT NULL, Node_Class NVARCHAR(65) NOT NULL, Anchor BIGINT NOT NULL, Bound BIGINT NOT NULL)
		
		IF NOT EXISTS (SELECT Name FROM sys.indexes WHERE name = 'pk_XMLNodes')
		BEGIN
			ALTER TABLE TMP.XML_Nodes ADD CONSTRAINT pk_XMLNodes PRIMARY KEY CLUSTERED (Source_ID, Anchor)
		END
**/

; WITH Nodes (Source_ID, Node_Name, Node_Class, Anchor, Bound)
AS (
	SELECT Source_ID, REPLACE(REPLACE(Segment, '</',''),'>','') AS Node_Name
	, CAST('</#>' as NVARCHAR(65)) as Node_Class
	, Anchor, Bound
	FROM TMP.XML_Parsed_Segments WITH(NOLOCK)
	WHERE CHARINDEX('</',Segment) > 0
	UNION
	SELECT Source_ID, SUBSTRING(Segment, 2, CHARINDEX('¶',Segment)-2) as Node_Name
	, CAST('<#/>' as NVARCHAR(65)) as Node_Class
	, Anchor, Bound
	FROM TMP.XML_Parsed_Segments WITH(NOLOCK)
	WHERE CHARINDEX('/>',Segment) > 0
	AND CHARINDEX('¶', Segment) > 0
	UNION
	SELECT Source_ID, SUBSTRING(Segment, 2, CHARINDEX(CHAR(32),Segment)-2) as Node_Name
	, CAST('<#/>' as NVARCHAR(65)) as Node_Class
	, Anchor, Bound
	FROM TMP.XML_Parsed_Segments WITH(NOLOCK)
	WHERE CHARINDEX('/>',Segment) > 0
	AND CHARINDEX('¶', Segment) = 0
	)

INSERT INTO TMP.XML_Nodes (Source_ID, Node_Name, Node_Level, Node_Class, Anchor, Bound)

SELECT Source_ID, RTRIM(LTRIM(Node_Name)) as Node_Name, 0 as Node_Level, Node_Class, Anchor, Bound
FROM Nodes
UNION ALL
SELECT DISTINCT T1.Source_ID, R1.Node_Name as Node_Name, 0 as Node_Level
, CAST('<#>' as NVARCHAR(65)) as Node_Class
, T1.Anchor, T1.Bound
FROM TMP.XML_Parsed_Segments AS T1 WITH(NOLOCK)
CROSS APPLY Nodes AS R1
WHERE R1.Source_ID = T1.Source_ID
AND R1.Node_Name = SUBSTRING(T1.Segment,2,LEN(R1.Node_Name))
AND LEFT(T1.Segment,2) <> '</'
AND RIGHT(T1.Segment,2) <> '/>'
AND PATINDEX('<'+R1.Node_Name+'[a-zA-Z.:]%', T1.Segment) = 0
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
		AND Node_Class = '<#>' THEN @Node_Level + 1
		WHEN @Source_ID = Source_ID
		AND Node_Class = '<#/>' THEN @Node_Level
		WHEN @Source_ID = Source_ID
		AND Node_Class = '</#>' THEN @Node_Level - 1
		ELSE 1 END
, @Source_ID = Source_ID
FROM TMP.XML_Nodes AS tmp WITH(TABLOCKX)
OPTION (MAXDOP 1)

IF @ExecuteStatus <> 2 SET NOCOUNT OFF


/*** Self-Terminating nodes live one layer below their host ***/

UPDATE TMP.XML_Nodes SET Node_Level = Node_Level+1
WHERE Node_Class = '<#/>'


/** Identify and stage Namespaces 
	-- These can be parsed explicitly, and are necessary for latter shred steps
	-- They require the addition of a property value to fully log due to primary key constraints
**/

IF EXISTS (SELECT * FROM tempdb.sys.all_objects WHERE name like N'#Name_Space_Stage%')
DROP TABLE #Name_Space_Stage

SELECT DISTINCT Source_ID
, SUBSTRING(Segment
	, PATINDEX('%xmlns:%=%', Segment)+6
		, CHARINDEX('=', Segment
		, PATINDEX('%xmlns:%=%', Segment))-(CHARINDEX('xmlns:', Segment)+6)
		) as Name_Space
INTO #Name_Space_Stage
FROM TMP.XML_Parsed_Segments AS T1 WITH(NOLOCK)
WHERE PATINDEX('%xmlns:%=%', Segment) > 0


/** Insert Schema Nodes **/

INSERT INTO ECO.REG_1102_XML_Nodes (REG_Node_Name)

SELECT DISTINCT REPLACE(T1.Node_Name, ISNULL(S1.Name_Space,''),'') as Node_Name
FROM TMP.XML_Nodes AS T1 WITH(NOLOCK)
LEFT JOIN (
	SELECT Source_ID, Name_Space+':' as Name_Space
	FROM #Name_Space_Stage
	) AS S1
ON S1.Source_ID = T1.Source_ID
AND CHARINDEX(S1.Name_Space, T1.Node_Name) > 0
LEFT JOIN ECO.REG_1102_XML_Nodes AS T2 WITH(NOLOCK)
ON T2.REG_Node_Name = REPLACE(T1.Node_Name, ISNULL(S1.Name_Space,''),'')
WHERE T2.REG_1102_ID IS NULL



/** Finally insert namespaces with identified resource links 
	Insert links between namespaces and schemas
	Insert links between namespaces and properties
	Classify and insert links between property values and
	schemas.	**/

/* Namespaces */

INSERT INTO ECO.REG_1101_XML_Namespaces (REG_Namespace, REG_NS_Link)

SELECT DISTINCT TMP.Name_Space, XMP.Sub_Segment
FROM #Name_Space_Stage AS tmp
JOIN TMP.XML_Property_Map AS XMP WITH(NOLOCK)
ON LTRIM(XMP.Property) = 'xmlns:'+TMP.Name_Space
LEFT JOIN ECO.REG_1101_XML_Namespaces AS XNS WITH(NOLOCK)
ON XNS.REG_Namespace = Name_Space
AND XNS.REG_NS_Link = XMP.Sub_Segment
WHERE XNS.REG_1101_ID IS NULL


/* Schema namespace links */

INSERT INTO ECO.LNK_1100_1101_Schema_Namespaces (LNK_FK_1100_ID, LNK_FK_1101_ID)

SELECT DISTINCT XSR.REG_1100_ID, XNS.REG_1101_ID
FROM TMP.XML_Process_Hash AS T1 WITH(NOLOCK)
JOIN LIB.External_String_Intake_Stack AS T2 WITH(NOLOCK)
ON T2.Version_Stamp = T1.Version_Stamp
JOIN ECO.REG_1100_XML_Schema_Registry AS XSR WITH(NOLOCK)
ON XSR.REG_Schema_Name+'.'+XSR.REG_XML_Class = T2.File_Name
JOIN TMP.XML_Property_Map AS XPM WITH(NOLOCK)
ON XPM.Source_ID = T1.Source_ID
JOIN ECO.REG_1101_XML_Namespaces AS XNS WITH(NOLOCK)
ON XPM.Sub_Segment = XNS.REG_NS_Link
EXCEPT
SELECT LNK_FK_1100_ID, LNK_FK_1101_ID
FROM ECO.LNK_1100_1101_Schema_Namespaces


/* Schema Heirarchy */

INSERT INTO ECO.LNK_1100_1102_Schema_Heirarchy (LNK_FK_1100_ID, LNK_FK_1102_ID, LNK_Node_Tier)

SELECT XSR.REG_1100_ID, RXN.REG_1102_ID, SUB.Node_Level
FROM (
	SELECT T1.Source_ID, T1.Node_Level, T1.Node_Name
	FROM TMP.XML_Nodes AS T1 WITH(NOLOCK)
	JOIN TMP.XML_Nodes AS T2 WITH(NOLOCK)
	ON T1.Source_ID = T2.Source_ID
	AND T1.Node_Name = T2.Node_Name
	AND T2.Node_Level = T1.Node_Level - 1
	AND T2.Anchor > T1.Anchor
	AND T2.Node_Class = '</#>'
	WHERE T1.Node_Class IN ('<#>','<#/>')
	GROUP BY T1.Source_ID, T1.Node_Level, T1.Node_Name
	) AS SUB
JOIN ECO.REG_1102_XML_Nodes AS RXN WITH(NOLOCK)
ON RXN.REG_Node_Name = SUB.Node_Name
JOIN TMP.XML_Process_Hash AS XPH WITH(NOLOCK)
ON XPH.Source_ID = SUB.Source_ID
JOIN LIB.External_String_Intake_Stack AS CIS WITH(NOLOCK)
ON CIS.Version_Stamp = XPH.Version_Stamp
JOIN ECO.REG_1100_XML_Schema_Registry AS XSR WITH(NOLOCK)
ON XSR.REG_Schema_Name+'.'+XSR.REG_XML_Class = CIS.File_Name
LEFT JOIN (
	SELECT Source_ID, Name_Space+':' as Name_Space
	FROM #Name_Space_Stage
	) AS HSS
ON HSS.Source_ID = SUB.Source_ID
AND CHARINDEX(HSS.Name_Space, SUB.Node_Name) > 0
EXCEPT
SELECT LSH.LNK_FK_1100_ID, LSH.LNK_FK_1102_ID, LSH.LNK_Node_Tier
FROM ECO.LNK_1100_1102_Schema_Heirarchy AS LSH 
WHERE GETDATE() BETWEEN LNK_Post_Date AND LNK_Term_Date


/* Parse out unique property strings from the nodes 
	20150201 - This code is superceded by a string-map oriented version.
	
		SELECT DISTINCT T1.Node_Name, SUBSTRING(T2.Segment, LEN(T1.Node_Name)+2, LEN(T2.Segment) - (LEN(T1.Node_Name)+2)) as Segment
		--INTO TMP.ParsedProperties
		FROM TMP.XML_Nodes AS T1 WITH(NOLOCK)
		JOIN TMP.XML_Parsed_Segments AS T2 WITH(NOLOCK)
		ON T1.Source_ID = T2.Source_ID
		AND T1.Anchor = T2.Anchor
		WHERE T1.Node_Class = '<#>'
		AND (T2.Bound - T2.Anchor) > LEN(T1.Node_Name)+2
*/


----/** Shred Properties 
----	CREATE TABLE TMP.PropertyBounds (Source_ID INT NOT NULL, Node_Name NVARCHAR(256) NOT NULL, Anchor BIGINT NOT NULL, Map_Bound BIGINT NOT NULL)
----	ALTER TABLE TMP.PropertyBounds ADD CONSTRAINT pk_PropertyBounds PRIMARY KEY CLUSTERED (Source_ID, Anchor)
----	CREATE NONCLUSTERED INDEX nci_PropertyBounds ON TMP.PropertyBounds (Anchor) INCLUDE (Source_ID, Node_Name)
----**/
	
------INSERT INTO TMP.PropertyBounds (Source_ID, Node_Name, Anchor, Map_Bound)

----; WITH PropertyBounds (Source_ID, Node_Name, Char_Pos, Bound)
----AS (
----	SELECT t1.Source_ID, t3.Node_Name, t1.Char_Pos, T3.Bound
----	FROM TMP.XML_String_Map AS t1 with(nolock)
----	JOIN TMP.XML_String_Map AS t2 with(nolock)
----	ON t1.Source_ID = t2.Source_ID
----	AND t1.Char_Pos = t2.Char_Pos - 1
----	JOIN TMP.XML_Nodes AS t3 with(nolock)
----	ON t3.Source_ID = t1.Source_ID
----	AND t3.Anchor + LEN(t3.Node_Name) <= t1.Char_Pos
----	AND t3.Bound >= t2.Char_Pos
----	WHERE (t1.ASCII_Char = 32
----	AND t2.ASCII_Char <> 32)
----	)

------WITH Properties (Source_ID, Node_Name, Anchor, Bound)
------AS (
----	SELECT T1.Source_ID, T1.Node_Name, MAX(T1.Char_Pos) AS Anchor, ISNULL(MIN(T2.Char_Pos), T1.Bound) AS Bound
----	FROM PropertyBounds AS T1
----	LEFT JOIN PropertyBounds AS T2
----	ON T1.Source_ID = T2.Source_ID
----	AND T1.Node_Name = T2.Node_Name
----	AND T1.Char_Pos < T2.Char_Pos
----	GROUP BY T1.Source_ID, T1.Node_Name, T1.Bound


----/* Test Notes:
----	This query is overflowing the tempdb datafile allocation and filling up more than 41GB of space.
----	Identify parameters for this query using smallest values first to probe for scale of performance.

----	Build in-memory set of required support data for reference by query - reduce to the minimum required
----	fields after optimizing.

----	Use ranging method of min/maxing to slice string (currently produces HUGE load - seems fine in 
----	other scenarios, so is there a scale factor here (I've used this for much larger SQL shredding)?

----	Other option - Lexigrapher to chop strings into non-whitespace blocks.	*/

----	SELECT Segment, min(T1.Source_ID) as Source_ID, min(T1.Anchor) as Anchor, min(T1.Bound) as Bound, count(*) as Frequency
----	INTO #TrimmedSegments
----	FROM tmp.XML_Parsed_Segments AS T1 WITH(NOLOCK)
----	JOIN tmp.XML_Nodes AS T2 WITH(NOLOCK)
----	ON T2.Source_ID = T1.Source_ID
----	AND T2.Anchor = T1.Anchor
----	AND T2.Bound = T1.Bound
----	WHERE T2.Node_Class <> '</#>'
----	GROUP BY Segment
----	ORDER BY frequency DESC


------SELECT Source_ID, count(*)
------FROM Node_Texts
------GROUP BY Source_ID
------ORDER BY 2 DESC

------where t1.ASCII_Char not in (32,60,62)


------, Property_Map (Source_ID, Anchor, Bound)
------AS (
----	SELECT S1.Source_ID, S1.Anchor, MIN(S2.Bound) as Bound
----	FROM (
----		SELECT T1.Source_ID, T1.Char_Pos AS Anchor
----		FROM TMP.XML_String_Map AS T1 WITH(NOLOCK)
----		JOIN #TrimmedSegments AS c1 WITH(NOLOCK)
----		ON c1.Source_ID = T1.Source_ID
----		AND T1.Char_Pos BETWEEN C1.Anchor AND C1.Bound
----		WHERE T1.ASCII_Char = 32
----		) AS S1
----	JOIN (
----		SELECT T1.Source_ID, T1.Char_Pos AS Bound
----		FROM TMP.XML_String_Map AS T1 WITH(NOLOCK)
----		JOIN #TrimmedSegments AS c1 WITH(NOLOCK)
----		ON c1.Source_ID = T1.Source_ID
----		AND T1.Char_Pos BETWEEN C1.Anchor AND C1.Bound
----		WHERE T1.ASCII_Char = 32
----		) AS S2
----	ON S2.Source_ID = S1.Source_ID
----	GROUP BY S1.Source_ID, S1.Anchor
----	HAVING MIN(S2.Bound) > S1.Anchor

----	option (recompile)
----	--)



----/** Process and insert node properties **/

----/* Test: Parse only unique segments: Many XML segments are repetative
----	Reduce overall volume of data by minimizing to distinct minimum segments */

----IF EXISTS (SELECT * FROM tempdb.sys.all_objects WHERE name like N'#Property_Bridge%')
----DROP TABLE #Property_Bridge

----WITH UniProps (Source_ID, Anchor, Bound)
----AS (
----	SELECT prm.Source_ID, prm.Anchor, prm.Bound
----	FROM TMP.XML_Parsed_Segments AS prm WITH(NOLOCK)
----	JOIN (
----		SELECT mid.Source_ID, mid.Segment, MIN(Anchor) as Anchor
----		FROM TMP.XML_Parsed_Segments AS mid WITH(NOLOCK)
----		JOIN (
----			SELECT Segment, MIN(Source_ID) as Source_ID
----			FROM TMP.XML_Parsed_Segments WITH(NOLOCK)
----			WHERE CHARINDEX('="', Segment) > 0
----			GROUP BY Segment
----			) AS inn
----		ON inn.Source_ID = mid.Source_ID
----		AND inn.Segment = mid.Segment
----		GROUP BY mid.Source_ID, mid.Segment
----		) AS sub
----	ON sub.Source_ID = prm.Source_ID
----	AND sub.Anchor = prm.Anchor
----	)

----SELECT S1.Source_ID, S1.Value_Anchor, MIN(M3.Char_Pos) as Value_Bound, 0 as Property_Anchor
----INTO #Property_Bridge
----FROM (
----	SELECT M1.Source_ID, M2.Char_Pos as Value_Anchor, cte.Bound
----	FROM TMP.XML_String_Map AS M1 WITH(NOLOCK)
----	JOIN UniProps AS cte
----	ON cte.Source_ID = M1.Source_ID
----	AND M1.Char_Pos BETWEEN cte.Anchor AND cte.Bound
----	JOIN TMP.XML_String_Map AS M2 WITH(NOLOCK)
----	ON M2.Source_ID = M1.Source_ID
----	AND M2.Char_Pos = M1.Char_Pos + 1
----	WHERE M1.ASCII_Char = ASCII('=')
----	AND M2.ASCII_Char = ASCII('"')
----	) AS S1
----JOIN TMP.XML_String_Map AS M3 WITH(NOLOCK)
----ON M3.Source_ID = S1.Source_ID
----AND M3.ASCII_Char = ASCII('"')
----AND M3.Char_Pos BETWEEN S1.Value_Anchor AND S1.Bound
----GROUP BY S1.Source_ID, S1.Value_Anchor


----CREATE NONCLUSTERED INDEX tdx_nc_PropertyBridge ON #Property_Bridge ([Source_ID]) INCLUDE (Value_Anchor,Value_Bound,Property_Anchor)
----GO

----UPDATE T1 SET Property_Anchor = ISNULL((
----	SELECT MAX(T2.Value_Bound) + 1
----	FROM #Property_Bridge AS T2
----	WHERE T2.Source_ID = t1.Source_ID
----	AND T2.Value_Bound < t1.Value_Anchor),1)
----FROM #Property_Bridge AS T1


----/* Load Properties into map staging */

----INSERT INTO TMP.XML_Property_Map (Source_ID, Value_Anchor, Value_Bound, Property_Anchor, Node_Name, Property_Rank, Property, Sub_Segment)

----SELECT DISTINCT T1.Source_ID, Value_Anchor, Value_Bound, Property_Anchor
----, T2.Node_Name
----, DENSE_RANK() OVER(PARTITION BY T1.Source_ID, T2.Node_Name ORDER BY  M1.Value_Anchor) AS Property_Rank
----, REVERSE(SUBSTRING(REVERSE(SUBSTRING(T1.String, Property_Anchor, Value_Anchor - Property_Anchor)), 2
----, CHARINDEX(' ', REVERSE(SUBSTRING(T1.String, Property_Anchor, Value_Anchor - Property_Anchor)))-1)) AS Property
----, SUBSTRING(T1.String, Value_Anchor+1, Value_Bound - Value_Anchor - 1) AS Sub_Segment
----FROM #Property_Bridge AS M1 WITH(NOLOCK)
----JOIN TMP.XML_Process_Hash AS T1 WITH(NOLOCK)	-- Need a better constraint here - ALL nodes include ALL internal records: Need max/min segments between which the internals are counted.
----ON T1.Source_ID = M1.Source_ID
----JOIN TMP.XML_Nodes AS T2 WITH(NOLOCK)
----ON T2.Source_ID = M1.Source_ID
----AND T2.Anchor <= M1.Property_Anchor
----AND T2.Bound > M1.Value_Bound


----/* Unload #Property_Bridge from memory to free up resources needed below */

----DROP TABLE #Property_Bridge


----/* Insert Properties and property values for schema only */

----INSERT INTO ECO.REG_1103_XML_Node_Properties (REG_Property_Name)

----SELECT DISTINCT REPLACE(Property, ISNULL(S1.Name_Space,''),'')
----FROM TMP.XML_Property_Map AS C1 WITH(NOLOCK)
----LEFT JOIN (
----	SELECT Source_ID, Name_Space+':' as Name_Space
----	FROM #Name_Space_Stage
----	) AS S1
----ON S1.Source_ID = c1.Source_ID
----AND CHARINDEX(Name_Space, Property)>0
----LEFT JOIN ECO.REG_1103_XML_Node_Properties AS T1 WITH(NOLOCK)
----ON t1.REG_Property_Name = REPLACE(Property, ISNULL(S1.Name_Space,''),'')
----WHERE T1.REG_1103_ID IS NULL


----/* Are the property values here important? Not really package GUIDs - perhaps others?? */

----INSERT INTO ECO.REG_1104_XML_Property_Values (REG_Value_Hash, REG_Value)

----SELECT DISTINCT Sub_Segment
----FROM TMP.XML_Property_Map AS T1 WITH(NOLOCK)
----LEFT JOIN (
----	SELECT Source_ID, Name_Space+':' as Name_Space
----	FROM #Name_Space_Stage
----	) AS S1
----ON S1.Source_ID = T1.Source_ID
----AND CHARINDEX(S1.Name_Space, T1.Node_Name) > 0
----LEFT JOIN ECO.REG_1104_XML_Property_Values AS T2 WITH(NOLOCK)
----ON T1.Sub_Segment = T2.REG_Value
----WHERE T2.REG_1104_ID IS NULL