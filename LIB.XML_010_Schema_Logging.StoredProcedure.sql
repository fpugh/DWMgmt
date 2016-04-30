USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[XML_010_Schema_Logging]') AND type in (N'P', N'PC'))
DROP PROCEDURE [LIB].[XML_010_Schema_Logging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[XML_010_Schema_Logging]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [LIB].[XML_010_Schema_Logging]
@ExecuteStatus TINYINT = 2

AS

------------------------------------------------------------------------------------------
-- Author Notes: This procedure is distinct from the SQL Module version due to unique	--
-- parsing rules between the two languages. At this time logging must remain seperate.	--
-- String Mapping and Shredding will be merged with ALL text based content analyis.		--
--																						--
------------------------------------------------------------------------------------------


/* Keep only the most recent post of each item in case multiple scans have
	transpired between code analysis. */
DELETE T1
FROM LIB.External_String_Intake_Stack AS T1 WITH(NOLOCK)
LEFT JOIN (
	SELECT T1.Version_Stamp, T1.Post_Date
	FROM LIB.External_String_Intake_Stack AS T1
	JOIN (
		SELECT Version_Stamp, MAX(Post_Date) as Post_Date
		FROM LIB.External_String_Intake_Stack WITH(NOLOCK)
		GROUP BY Version_Stamp
		HAVING COUNT(*) > 1
		) as S1
	ON S1.Version_Stamp = T1.Version_Stamp
	AND S1.Post_Date = T1.Post_Date
	) AS S2
ON T1.Version_Stamp = S2.Version_Stamp
AND T1.Post_Date = S2.Post_Date
WHERE S2.Post_Date IS NULL



/* Log or update collections and catalogs */
INSERT INTO LIB.REG_Sources (Version_Stamp, Create_Date)
SELECT DISTINCT T1.Version_Stamp, T1.Post_Date
FROM LIB.External_String_Intake_Stack AS T1 WITH(NOLOCK)
LEFT JOIN LIB.REG_Sources AS T2 WITH(NOLOCK)
ON T2.Version_Stamp = T1.Version_Stamp
AND T2.Create_Date = T1.Post_Date
WHERE T2.Source_ID IS NULL




/* Drop primary key index on table for insert */
IF EXISTS (SELECT * FROM sys.indexes WHERE name = ''pk_XMLProcessHash'')
BEGIN
	ALTER TABLE [TMP].[XML_Process_Hash] DROP CONSTRAINT [pk_XMLProcessHash]
END


/* Insert new entries to the Schema File Registry */
INSERT INTO ECO.REG_1100_XML_Schema_Registry (REG_XML_Class, REG_Schema_Name, REG_Schema_Path)

SELECT DISTINCT REPLACE(File_Type,''.'',''''), REPLACE(File_Name,File_Type,''''), File_Path
FROM LIB.External_String_Intake_Stack AS stk WITH(NOLOCK)
JOIN LIB.VI_2019_Simple_Collection_List AS vew 
ON File_Type = Subordinate_Collection
AND Parent_Collection = ''XML''
EXCEPT
SELECT REG_XML_Class, REG_Schema_Name, REG_Schema_Path
FROM ECO.REG_1100_XML_Schema_Registry WITH(NOLOCK)



/* Load entries to the Document Collection 
	ToDo: Test table trigger to identify if early-version logic is in place to enter/closeout 
	older files.
*/
INSERT INTO LIB.HSH_Collection_XML_Documents (Collection_ID, Source_ID, hsh_fk_1100_ID)

SELECT DISTINCT crap.Collection_ID, src.Source_ID, reg.REG_1100_ID
FROM LIB.External_String_Intake_Stack AS stk WITH(NOLOCK)
JOIN ECO.REG_1100_XML_Schema_Registry AS reg WITH(NOLOCK)
ON REPLACE(File_Name,stk.File_Type,'''') = reg.REG_Schema_Name
JOIN LIB.REG_Sources AS src WITH(NOLOCK)
ON stk.Version_Stamp = src.Version_Stamp
CROSS APPLY (
	SELECT Collection_ID, Name
	FROM LIB.REG_Collections WITH(NOLOCK)
	) AS crap
WHERE CHARINDEX(stk.File_Type, crap.Name) > 0
order by REG_1100_ID


/* File sources under appropriate collection(s) - Code should be filed
	directly under the TSQL collection, as well as the topic specific collection */
INSERT INTO TMP.XML_Process_Hash (Collection_ID, Source_ID, REG_1100_ID, Version_Stamp, Post_Date, String_Length, String)

SELECT DISTINCT RIGHT(vew.Collection_Code, CHARINDEX(''.'',REVERSE(Collection_Code))-1)
, src.Source_ID
, xsr.REG_1100_ID
, stk.Version_Stamp
, stk.Post_Date
, CASE WHEN LEFT(stk.File_Content,2) = ''ÿþ'' THEN (stk.File_Size)/2 
	ELSE stk.File_Size END as String_Length
, CASE WHEN LEFT(stk.File_Content,2) = ''ÿþ'' THEN CAST(stk.File_Content AS NVARCHAR(MAX))
	ELSE CAST(CAST(stk.File_Content AS VARCHAR(MAX)) AS NVARCHAR(MAX)) END as String_Convert
FROM LIB.External_String_Intake_Stack AS stk
LEFT JOIN LIB.VI_2019_Simple_Collection_List AS vew 
ON File_Type = Subordinate_Collection
AND Parent_Collection = ''XML''
LEFT JOIN LIB.REG_Sources AS src
ON src.Version_Stamp = stk.Version_Stamp
LEFT JOIN ECO.REG_1100_XML_Schema_Registry AS xsr
ON xsr.REG_Schema_Path = stk.File_Path
ORDER BY stk.Version_Stamp


/* Create Primary Key on XML_Process_Hash */
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = ''pk_XMLProcessHash'')
BEGIN
	ALTER TABLE [TMP].[XML_Process_Hash] ADD CONSTRAINT [pk_XMLProcessHash] PRIMARY KEY CLUSTERED 
	([Version_Stamp] ASC) 
	ON [PRIMARY]
END


/* 20150820:4est - Create specialist XML_String_Map for this process
	This is not the most efficient way to call this process,
	but allows for inline calls to be made during debugging cycles 
	
	This section is a patch and should not be retained indefinitely.
	*/
	
IF @ExecuteStatus = 1
BEGIN 
	DECLARE	@return_value int
	, @MaxLen INT =  (
		SELECT MAX(String_Length)
		FROM TMP.XML_Process_Hash
		)

	EXEC	@return_value = LIB.TXT_011_String_Mapper
			@Source = ''TMP.XML_Process_Hash'',
			@MaxLen = @MaxLen
			
			INSERT INTO TMP.XML_String_Map
			SELECT map.Source_ID, map.Char_Pos, map.ASCII_Char
			FROM TMP.TXT_String_Map AS map
			JOIN TMP.XML_Process_Hash AS hsh
			ON map.Source_ID = hsh.Source_ID
			ORDER BY Source_ID, Char_Pos
			
			DELETE map
			FROM TMP.TXT_String_Map AS map
			JOIN TMP.XML_Process_Hash AS hsh
			ON map.Source_ID = hsh.Source_ID
			
	SELECT ''Return Value:''+CASE WHEN @return_value = 0 THEN '' SUCCESS'' ELSE '' ERROR/FAILURE'' END
END




-- Debug Note: Key Violation - ''A:D200-N000:0000000341:1133963116:067.00''
-- select * from XML_Process_Hash where Version_Stamp = ''A:D200-N000:0000000341:1133963116:067.00''
-- Resolution: DISTINCT required. CAT.VI_Column_Tier_Latches contains all column information for each object. Unambiguous join not possible.



/** Do this after deriving content queries from template statement
	The because this document format can impact many to one relationships between different
	collection and catalog items, it is possible to derive a functional map of operations and 
	logic conducted on an environment.
	
	Convert the statement below to include the Source and Collection IDs of any catalog items 
	addressed as values in nodes of schemas of a given type.

	/* Insert new collection items */
	INSERT INTO LIB.HSH_Collection_Source_Catalog (Collection_ID, Source_ID, Catalog_ID, Post_Date)

	SELECT DISTINCT T1.Collection_ID, T1.Source_ID, T1.Catalog_ID, T1.Post_Date
	FROM TMP.XML_Process_Hash AS t1
	JOIN LIB.HSH_Collection_XML_Documents AS T2
	ON T2.Source_ID = T1.Source_ID
	LEFT JOIN LIB.HSH_Collection_Source_Catalog AS T3
	ON T2.Collection_ID = T3.Collection_ID 
	AND T1.Source_ID = T3.Source_ID 
	AND T1.Catalog_ID = T3.Catalog_ID 
	AND T1.Post_Date BETWEEN T3.Post_Date AND T3.Term_Date
	WHERE T3.Hash_ID IS NULL

**/

' 
END
GO
