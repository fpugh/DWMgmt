
DECLARE @sql nvarchar(1000)
, @DropOrder tinyint
, @ObjectName  nvarchar(256)
, @ConstraintName nvarchar(256)

DECLARE cdropper CURSOR FOR
/* Foreign Keys should be dropped first; they can prevent other indexes and constraints from being dropped. */
SELECT 1 as DropOrder, '['+scm.name+'].['+tbl.name+']' as ObjectName, '['+fk.name+']' as ConstraintName
FROM sys.schemas as scm
JOIN sys.tables as tbl
ON scm.schema_id = tbl.schema_id
JOIN sys.foreign_keys as fk
ON fk.parent_object_id = tbl.object_id

UNION
SELECT 2, '['+scm.name+'].['+tbl.name+']', '['+ck.name+']'
FROM sys.schemas as scm
JOIN sys.tables as tbl
ON scm.schema_id = tbl.schema_id
JOIN sys.check_constraints as ck
ON ck.parent_object_id = tbl.object_id

UNION
SELECT 3, '['+scm.name+'].['+tbl.name+']', '['+df.name+']'
FROM sys.schemas as scm
JOIN sys.tables as tbl
ON scm.schema_id = tbl.schema_id
JOIN sys.default_constraints as df
ON df.parent_object_id = tbl.object_id

UNION
/* Primary Keys must be dropped as constraints AFTER Foreign Key links are eliminated 
	Other indexes may be dropped in normal sequence. */
SELECT CASE WHEN idx.is_primary_key = 1 
	OR idx.is_unique_constraint = 1	THEN 2 ELSE 4 END
, '['+scm.name+'].['+tbl.name+']', '['+idx.name+']'
FROM sys.schemas as scm
JOIN sys.tables as tbl
ON scm.schema_id = tbl.schema_id
JOIN sys.indexes as idx
ON idx.object_id = tbl.object_id
AND idx.type > 0

UNION
SELECT 5, '['+scm.name+'].['+tbl.name+']', '['++scm.name+'].['+tgr.name+']'
FROM sys.schemas as scm
JOIN sys.tables as tbl
ON scm.schema_id = tbl.schema_id
JOIN sys.triggers as tgr
ON tgr.parent_id = tbl.object_id
ORDER BY 1,2,3

OPEN cdropper

FETCH NEXT FROM cdropper
INTO @DropOrder, @ObjectName, @ConstraintName

WHILE @@FETCH_STATUS = 0

BEGIN

SET @sql = 
CASE WHEN @DropOrder IN (1,2,3) THEN 'ALTER TABLE '+@ObjectName+' DROP CONSTRAINT '+@ConstraintName
	WHEN @DropOrder = 4 THEN 'DROP INDEX '+@ConstraintName+' ON '+@ObjectName
	WHEN @DropOrder = 5 THEN 'DROP TRIGGER '+@ConstraintName END
	
EXEC sp_executeSQL @SQL
--PRINT @SQL

FETCH NEXT FROM cdropper
INTO @DropOrder, @ObjectName, @ConstraintName

END

CLOSE cdropper
DEALLOCATE cdropper


