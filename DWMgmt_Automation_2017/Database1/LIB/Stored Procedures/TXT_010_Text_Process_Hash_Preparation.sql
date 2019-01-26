

CREATE PROCEDURE [LIB].[TXT_010_Text_Process_Hash_Preparation]

--DECLARE
 @BatchID NVARCHAR(7) = 'ALL'
, @BatchCapacity BIGINT = 2600000
, @ForceTextParse TINYINT = 1
, @ForceLongParse TINYINT = 1

AS

/* File sources under appropriate collection(s) 
	Use/Modify case statement below until reliable tag from file import script task can be compiled
	This case statement will currently detect ASCII and UTF8 encoding types.

	-- TRUNCATE TABLE TMP.TXT_Process_Hash
*/

INSERT INTO TMP.TXT_Process_Hash (Batch_ID, Collection_ID, Source_ID, Version_Stamp, Post_Date, File_Type, String_Length, String)

SELECT stk.Batch_ID, C1.Collection_ID, S1.Source_ID, stk.Version_Stamp, min(stk.Post_Date), stk.File_Type
, CASE WHEN LEFT(stk.File_Content,2) = 'ÿþ' THEN (stk.File_Size)/2 
	ELSE stk.File_Size END as String_Length
, CASE WHEN LEFT(stk.File_Content,2) = 'ÿþ' THEN CAST(stk.File_Content AS NVARCHAR(MAX))
	ELSE CAST(CAST(stk.File_Content AS VARCHAR(MAX)) AS NVARCHAR(MAX)) END as String_Convert
FROM LIB.External_String_Intake_Stack AS stk
JOIN LIB.REG_Sources AS S1
ON S1.Version_Stamp = stk.Version_Stamp
CROSS APPLY LIB.REG_Collections AS C1
WHERE (stk.File_Size-2)/2 > 0
AND c1.Name = stk.File_Type
AND (@BatchID = 'ALL'
OR @BatchID = stk.Batch_ID)
GROUP BY stk.Batch_ID, C1.Collection_ID, S1.Source_ID, stk.Version_Stamp, stk.File_Type, stk.File_Size, stk.File_Content
ORDER BY stk.Version_Stamp


/* Create Primary Key on SQL_Process_Hash */

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'pk_TXT_Process_Hash')
BEGIN
	ALTER TABLE [TMP].[TXT_Process_Hash] ADD CONSTRAINT [pk_TXT_Process_Hash] PRIMARY KEY CLUSTERED 
	(Version_Stamp ASC) 
	ON [PRIMARY]
END




/* Bypass specialized processing of known file types
	-- For debugging, or research: Avoid in production.
	-- Allows all file types to be presented to the full text analysis battery.
	---- Do this periodically for known file types to maintain statistical integrity, and update automated rules.
*/

IF @ForceTextParse = 0
BEGIN

	/* XML Insert
		-- TRUNCATE TABLE TMP.XML_Process_Hash
	*/

	INSERT INTO TMP.XML_Process_Hash (Collection_ID, Source_ID, Version_Stamp, Post_Date, String_Length, String)

	SELECT Collection_ID, Source_ID, Version_Stamp, Post_Date, String_Length, String
	FROM TMP.TXT_Process_Hash AS hsh
	JOIN LIB.VI_2119_Simple_Collection_List AS vew 
	ON hsh.File_Type = Subordinate_Collection
	WHERE vew.Parent_Collection = 'XML'
	EXCEPT
	SELECT Collection_ID, Source_ID, Version_Stamp, Post_Date, String_Length, String
	FROM TMP.XML_Process_Hash

	DELETE hsh
	FROM TMP.TXT_Process_Hash AS hsh
	JOIN LIB.VI_2119_Simple_Collection_List AS vew 
	ON hsh.File_Type = Subordinate_Collection
	WHERE vew.Parent_Collection = 'XML'


	/* SQL Insert
		-- TRUNCATE TABLE TMP.SQL_Process_Hash
	*/

	INSERT INTO TMP.SQL_Process_Hash (Collection_ID, Catalog_ID, Source_ID, Version_Stamp, Post_Date, String_Length, String)

	SELECT Collection_ID, 0, Source_ID, Version_Stamp, Post_Date, String_Length, String
	FROM TMP.TXT_Process_Hash AS hsh
	JOIN LIB.VI_2119_Simple_Collection_List AS vew 
	ON hsh.File_Type = Subordinate_Collection
	WHERE vew.Subordinate_Collection = '.sql'
	EXCEPT
	SELECT Collection_ID, Catalog_ID, Source_ID, Version_Stamp, Post_Date, String_Length, String
	FROM TMP.SQL_Process_Hash

	DELETE hsh
	FROM TMP.TXT_Process_Hash AS hsh
	JOIN LIB.VI_2119_Simple_Collection_List AS vew 
	ON hsh.File_Type = Subordinate_Collection
	WHERE vew.Subordinate_Collection = '.sql'

END