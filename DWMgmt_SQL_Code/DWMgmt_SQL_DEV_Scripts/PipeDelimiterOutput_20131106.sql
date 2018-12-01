
/* ToDo:
	Is there a better way to apply this? Can the cursor be made dynamic? Can the asynchronous method be applied?
*/

DECLARE @FieldList NVARCHAR(4000) = ''
, @SQL NVARCHAR(MAX)
, @ColumName NVARCHAR(255)
, @Delimiter NVARCHAR(65)

SET @Delimiter = ' AS NVARCHAR (255)), '''') +''|''+ ISNULL(CAST('
--SET @Delimiter = ', '

DECLARE FieldStringer CURSOR FOR
SELECT col.name + case when typ.collation_name is not null then ' COLLATE Database_Default' else '' end
FROM sys.all_objects AS obj
JOIN sys.all_columns AS col
ON col.object_id = obj.object_id
JOIN sys.types as typ
ON typ.user_type_id = col.user_type_id
WHERE obj.name = 'all_objects'
GROUP BY col.name, col.column_id, typ.collation_name
ORDER BY col.column_id

OPEN FieldStringer

FETCH NEXT FROM FieldStringer
INTO @ColumName

WHILE @@FETCH_STATUS = 0 
BEGIN

SET @FieldList = CASE WHEN @FieldList = '' THEN 'ISNULL(CAST('+@ColumName ELSE @FieldList+@Delimiter+@ColumName END

FETCH NEXT FROM FieldStringer
INTO @ColumName

END

SET @FieldList = @FieldList +' AS NVARCHAR (255)), '''')'

CLOSE FieldStringer
DEALLOCATE FieldStringer


SET @SQL = '
SELECT '+@FieldList+'
FROM sys.all_objects
WHERE type = ''U''
'

PRINT @SQL
EXECUTE sp_executeSQL @SQL