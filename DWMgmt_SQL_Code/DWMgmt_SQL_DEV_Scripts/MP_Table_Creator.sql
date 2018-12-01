CREATE PROCEDURE MP_Create_Table
@NamePart NVARCHAR(4000) = 'ALL'
, @Debug TINYINT = 2

AS

DECLARE @SQLStatement nvarchar(max) = ''
, @SQLSegmentIn nvarchar(4000)
, @SQLParamOut nvarchar(4000) = N'@SQLOutput nvarchar(4000) OUTPUT'
, @SQLSegmentOut nvarchar(4000)
, @Schema nvarchar(256)
, @Object nvarchar(256)
, @ObjectLast nvarchar(256) = ''
, @Column nvarchar(256)
, @Length nvarchar(16)

DECLARE TableMaker cursor for
SELECT scm.name
, obj.name
, col.name
FROM sys.schemas as scm
JOIN sys.all_objects as obj
ON obj.schema_id = scm.schema_id
JOIN sys.all_columns as col
ON col.object_id = obj.object_id
WHERE 1=1
AND  (@NamePart = 'ALL' OR charindex(@NamePart, '['+scm.name+'].['+obj.name+']') > 0 OR charindex('['+scm.name+'].['+obj.name+']', @NamePart) > 0)
ORDER BY 1,2, col.column_id

OPEN TableMaker

SET NOCOUNT ON

FETCH NEXT FROM TableMaker
INTO @Schema, @Object, @Column

WHILE @@FETCH_STATUS = 0

BEGIN

IF @Object != @ObjectLast AND @SQLStatement != ''
BEGIN
	SET @SQLStatement = @SQLStatement+CHAR(10)+')'
	
	IF @Debug IN (0,1)
	BEGIN
		PRINT @SQLStatement
	END

	IF @Debug IN (1,2)
	BEGIN	
		EXEC sp_EXECuteSQL @SQLStatement
	END
END

-- Pieces of Eight Algorithm
-- Need to test this with 4 cases: NULL, [0-9] value, [^0-9] value, [0-9a-z] values
SET @SQLSegmentIn = '
SELECT @SQLOutPut = ''['+@Column+'] ''
+ CASE WHEN MIN(ISNULL(['+@Column+'],'''')) != '''' AND MIN(PATINDEX(''%[^0-9]%'', CAST(ISNULL(['+@Column+'],'''') as varchar))) = 0 THEN ''FLOAT''
	ELSE ''NVARCHAR (''+
		CASE WHEN MAX(LEN(ISNULL(['+@Column+'],''''))) <= 8 THEN ''8''
		WHEN MAX(LEN(ISNULL(['+@Column+'],''''))) > 8 AND MAX(LEN(ISNULL(['+@Column+'],''''))) < 17 THEN ''16''
		WHEN MAX(LEN(ISNULL(['+@Column+'],''''))) > 16 AND MAX(LEN(ISNULL(['+@Column+'],''''))) < 25 THEN ''24''
		WHEN MAX(LEN(ISNULL(['+@Column+'],''''))) > 24 AND MAX(LEN(ISNULL(['+@Column+'],''''))) < 65 THEN ''64''
		WHEN MAX(LEN(ISNULL(['+@Column+'],''''))) > 64 AND MAX(LEN(ISNULL(['+@Column+'],''''))) < 129 THEN ''128''
		WHEN MAX(LEN(ISNULL(['+@Column+'],''''))) > 128 AND MAX(LEN(ISNULL(['+@Column+'],''''))) < 257 THEN ''256''
		WHEN MAX(LEN(ISNULL(['+@Column+'],''''))) > 256 AND MAX(LEN(ISNULL(['+@Column+'],''''))) < 513 THEN ''512''
		WHEN MAX(LEN(ISNULL(['+@Column+'],''''))) > 512 AND MAX(LEN(ISNULL(['+@Column+'],''''))) < 1001 THEN ''1000''
		WHEN MAX(LEN(ISNULL(['+@Column+'],''''))) > 1000 AND MAX(LEN(ISNULL(['+@Column+'],''''))) < 2001 THEN ''2000''
		WHEN MAX(LEN(ISNULL(['+@Column+'],''''))) > 2000 AND MAX(LEN(ISNULL(['+@Column+'],''''))) < 4001 THEN ''4000''
		ELSE ''MAX'' END
	+'')'' END
FROM ['+@Schema+'].['+@Object+']
'

/* Create the proper length of the column by testing the data */
EXEC sp_EXECuteSQL @SQLSegmentIn, @SQLParamOut, @SQLOutput = @SQLSegmentOut OUTPUT

IF @Debug in (0,1)
BEGIN
	SELECT @Schema+'.'+@Object as SchemaQualifiedObject, replace(@SQLSegmentIn,'@SQLOutPut = ','') as SegmentIn, @SQLSegmentOut as SegmentOut
END

SET @SQLStatement = CASE WHEN @Object != @ObjectLast THEN 'CREATE TABLE structured.['+@Object+'] (' + CHAR(10) + @SQLSegmentOut
	ELSE @SQLStatement + CHAR(10) + ', '+@SQLSegmentOut END

SET @ObjectLast = @Object

FETCH NEXT FROM TableMaker
INTO @Schema, @Object, @Column

END

	SET @SQLStatement = @SQLStatement+CHAR(10)+')'
	
	IF @Debug IN (0,1)
	BEGIN
		PRINT @SQLStatement
	END

	IF @Debug IN (1,2)
	BEGIN
		EXEC sp_EXECuteSQL @SQLStatement
	END

SET NOCOUNT OFF

CLOSE TableMaker
DEALLOCATE TableMaker