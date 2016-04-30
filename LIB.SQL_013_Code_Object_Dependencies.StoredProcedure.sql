USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[SQL_013_Code_Object_Dependencies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [LIB].[SQL_013_Code_Object_Dependencies]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[SQL_013_Code_Object_Dependencies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [LIB].[SQL_013_Code_Object_Dependencies]
@ExecuteStatus INT = 2

AS

DECLARE @SQL NVARCHAR(max) = ''''

SET @SQL = ''
IF NOT EXISTS (SELECT name FROM tempdb.sys.tables WHERE name = N''''##CodeObjectLinks'''')
BEGIN
	CREATE TABLE ##CodeObjectLinks (Qualified_Object_Name NVARCHAR(512), REG_Object_Type NVARCHAR(5), LNK_FK_T3P_ID INT, LNK_FK_0300_Prm_ID INT, REG_0600_ID INT, REG_Code_Content NVARCHAR(MAX))
END''


IF @ExecuteStatus IN (0,1)
BEGIN
	PRINT @SQL
END

IF @ExecuteStatus IN (1,2)
BEGIN
	EXECUTE sys.sp_executeSQL @SQL
END


DECLARE @QualifiedOBject NVARCHAR(512)
, @REG_Object_Type NVARCHAR(5)
, @LNK_FK_T3P_ID NVARCHAR(10)
, @LNK_FK_0300_Prm_ID NVARCHAR(10)


DECLARE ObjectList CURSOR FOR
SELECT DISTINCT Schema_Bound_Qualifier, REG_Object_Type
, LNK_T3_ID, REG_0300_ID
FROM CAT.VI_0300_Full_Object_Map
WHERE Schema_Bound_Qualifier IS NOT NULL
AND REG_Object_Type IN (''U'',''V'',''FN'',''IF'',''P'',''TF'',''TR'')
UNION
SELECT DISTINCT REG_Object_Name, REG_Object_Type
, LNK_T3_ID, REG_0300_ID
FROM CAT.VI_0300_Full_Object_Map
WHERE Schema_Bound_Qualifier IS NOT NULL
AND REG_Schema_Name = ''dbo''	-- Schema binding is optional for ''dbo'' objects.
AND REG_Object_Type IN (''U'',''V'',''FN'',''IF'',''P'',''TF'',''TR'')


OPEN ObjectList

FETCH NEXT FROM ObjectList
INTO @QualifiedObject, @REG_Object_Type, @LNK_FK_T3P_ID, @LNK_FK_0300_Prm_ID

WHILE @@FETCH_STATUS = 0


BEGIN
SET @SQL = ''

INSERT INTO ##CodeObjectLinks (Qualified_Object_Name, REG_Object_Type, LNK_FK_T3P_ID, LNK_FK_0300_Prm_ID, REG_0600_ID)

SELECT ''''''+@QualifiedObject+'''''', ''''''+@REG_Object_Type+''+1'''', ''+@LNK_FK_T3P_ID+'', ''+@LNK_FK_0300_Prm_ID+'', REG_0600_ID
FROM DWMgmt.CAT.REG_0600_Object_Code_Library WITH(NOLOCK)
WHERE CONTAINS(REG_Code_Content, ''''''+@QualifiedObject+'''''')
AND (CONTAINS(REG_Code_Content, ''''FROM'''')
OR CONTAINS(REG_Code_Content, ''''JOIN'''')
OR CONTAINS(REG_Code_Content, ''''APPLY''''))
UNION
SELECT ''''''+@QualifiedObject+'''''', ''''''+@REG_Object_Type+''+2'''', ''+@LNK_FK_T3P_ID+'', ''+@LNK_FK_0300_Prm_ID+'', REG_0600_ID
FROM DWMgmt.CAT.REG_0600_Object_Code_Library WITH(NOLOCK)
WHERE CONTAINS(REG_Code_Content, ''''''+@QualifiedObject+'''''')
AND (CONTAINS(REG_Code_Content, ''''INTO'''')
OR CONTAINS(REG_Code_Content, ''''MERGE''''))
UNION
SELECT ''''''+@QualifiedObject+'''''', ''''''+@REG_Object_Type+''+3'''', ''+@LNK_FK_T3P_ID+'', ''+@LNK_FK_0300_Prm_ID+'', REG_0600_ID
FROM DWMgmt.CAT.REG_0600_Object_Code_Library WITH(NOLOCK)
WHERE CONTAINS(REG_Code_Content, ''''''+@QualifiedObject+'''''')
AND CONTAINS(REG_Code_Content, ''''UPDATE'''')
UNION
SELECT ''''''+@QualifiedObject+'''''', ''''''+@REG_Object_Type+''+4'''', ''+@LNK_FK_T3P_ID+'', ''+@LNK_FK_0300_Prm_ID+'', REG_0600_ID
FROM DWMgmt.CAT.REG_0600_Object_Code_Library WITH(NOLOCK)
WHERE CONTAINS(REG_Code_Content, ''''''+@QualifiedObject+'''''')
AND CONTAINS(REG_Code_Content, ''''EXEC'''')
''
IF @ExecuteStatus IN (0,1)
BEGIN
	PRINT @SQL
END

IF @ExecuteStatus IN (1,2)
BEGIN
	EXECUTE sys.sp_executeSQL @SQL
END

FETCH NEXT FROM ObjectList
INTO @QualifiedObject, @REG_Object_Type, @LNK_FK_T3P_ID, @LNK_FK_0300_Prm_ID

END

CLOSE ObjectList
DEALLOCATE ObjectList


/* Insert Dependencies for procedural objects */
IF @ExecuteStatus IN (0,1)
BEGIN
	SET @SQL = CASE WHEN @ExecuteStatus = 0
	THEN ''
	SELECT DISTINCT ocr.LNK_T3_ID, tmp.LNK_FK_T3P_ID, ocr.REG_Object_Type, ocr.LNK_FK_0300_ID, tmp.LNK_FK_0300_Prm_ID, DENSE_RANK() OVER (PARTITION BY LNK_T3_ID ORDER BY LNK_FK_T3P_ID)
	FROM ##CodeObjectLinks AS tmp
	JOIN CAT.VI_0360_Object_Code_Reference AS ocr
	ON ocr.LNK_FK_0600_id = tmp.REG_0600_ID
	''
	WHEN @ExecuteStatus = 1
	THEN ''
	INSERT INTO CAT.LNK_0300_0300_Object_Dependencies (LNK_FK_T3P_ID, LNK_FK_T3R_ID, LNK_Latch_Type, LNK_FK_0300_Prm_ID, LNK_FK_0300_Ref_ID, LNK_Rank)

	SELECT DISTINCT ocr.LNK_T3_ID, tmp.LNK_FK_T3P_ID, ocr.REG_Object_Type, ocr.LNK_FK_0300_ID, tmp.LNK_FK_0300_Prm_ID, DENSE_RANK() OVER (PARTITION BY LNK_T3_ID ORDER BY LNK_FK_T3P_ID)
	FROM ##CodeObjectLinks AS tmp
	JOIN CAT.VI_0360_Object_Code_Reference AS ocr
	ON ocr.LNK_FK_0600_id = tmp.REG_0600_ID
	'' END

	PRINT @SQL
END

IF @ExecuteStatus IN (1,2)
BEGIN
	EXECUTE sys.sp_executeSQL @SQL
END



/* ToDo:
	Create a stoplist for "noise" objects such as "Catalog", "Roles", etc. 
	These are often control words or are simply too common to be useful. Such objects should be renamed or bound to a custom schema.
*/
' 
END
GO
