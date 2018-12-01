USE GeoRef_Master
GO


--truncate table dbo.GeospatialRelationalProbeHash
--truncate table dbo.GeospatialRelationalProbeStack
--truncate table dbo.GeospatialRelationalIntersectionTest

--CREATE TABLE ##RelationalProbeStack (stk_id INT IDENTITY(1,1), ObjectID INT, ColumnID INT, QualifiedObject NVARCHAR(255), ColumnName NVARCHAR(255), ColumnDefinition NVARCHAR(255))
--CREATE TABLE ##RelationalProbeHash (fk_stk_id INT, ColumnValue NVARCHAR(255), ValueCount INT)


DELETE FROM ##RelationalProbeStack
DELETE FROM ##RelationalProbeHash


DECLARE @ExecuteStatus INT = 1

INSERT INTO ##RelationalProbeStack (ObjectID, ColumnID, QualifiedObject, ColumnName, ColumnDefinition)
SELECT obj.object_id, col.column_id, scm.name +'.'+ obj.name as SchemaObject, col.name as ColumnName
, typ.name
+ CASE WHEN col.user_type_id IN (34,98,99,106,108,165,167,173,175,231,239,241,256)  THEN ' ('+CAST(col.max_length AS nvarchar) + ')'
	WHEN col.user_type_id IN (106,108) THEN ' ('+CAST(col.scale AS nvarchar) + ',' + CAST(col.precision as nvarchar)+')'
	ELSE '' END
FROM sys.schemas as scm
JOIN sys.all_objects AS obj
ON scm.schema_id = obj.schema_id
JOIN sys.columns AS col
ON obj.object_id = col.object_id
JOIN sys.types AS typ
ON col.user_type_id = typ.user_type_id
WHERE 1=1
AND scm.schema_id in (1,5)
and obj.type in ('U','V')
AND typ.user_type_id not in (129,130,165,173,241,99,128,34,98,256)
--and obj.name like 'mir_zip%'
and obj.name != 'mir_zip_demographics_with_headerInfo'
and obj.name not like 'TL_%'
and obj.name not in('GeospatialRelationalProbeHash','GeospatialRelationalProbeStack','GeospatialRelationalIntersectionTest')
ORDER BY col.name, col.column_id



DECLARE @SQL NVARCHAR(max)
, @SQLStatement NVARCHAR(max) = 'INSERT INTO ##RelationalProbeHash (fk_stk_id, ColumnValue, ValueCount)'
, @SQLLen BIGINT
, @Object NVARCHAR(255)
, @Column NVARCHAR(255)
, @ColumnDefinition NVARCHAR(255)
, @TblKey VARCHAR(10)

DECLARE RelationalProbeResolver CURSOR FOR
SELECT QualifiedObject, ColumnName, stk_id, ColumnDefinition
FROM ##RelationalProbeStack

OPEN RelationalProbeResolver

FETCH NEXT FROM RelationalProbeResolver
INTO @Object, @Column, @TblKey, @ColumnDefinition

WHILE @@FETCH_STATUS = 0

BEGIN

SET @SQL = '
SELECT '+@TblKey+', '+
	CASE WHEN CHARINDEX('CHAR', @ColumnDefinition) = 0 THEN 'CAST(['+@Column+'] AS VARCHAR)' ELSE '['+@Column+']' END	-- Cast non-char columns as generic varchar, then COLLATE any normal CHAR type columns with case and accent sensitivity as we will deal with characters outside of the english set.
		+ CASE WHEN CHARINDEX('CHAR', @ColumnDefinition) > 0 THEN 'COLLATE Latin1_General_CS_AS' ELSE '' END + ', COUNT(*) 
FROM '+@Object+'
GROUP BY ['+@Column+']
'

IF LEN(@SQLStatement) + LEN(@SQL) + 7 < 3400 AND LEN(@SQL) > 0
	BEGIN 
	
	--PRINT @SQL

	SET @SQLStatement = @SQLStatement 
	+ CASE WHEN CHARINDEX('FROM', @SQLStatement) = 0 THEN '' ELSE 'UNION' END
	+ @SQL
	
	END
ELSE
BEGIN
	IF @ExecuteStatus in (0,1)
	BEGIN
		PRINT @SQLStatement
	END
	IF @ExecuteStatus in (1,2)
	BEGIN
		EXECUTE sp_executeSQL @SQLStatement
	END

	SET @SQLStatement = 'INSERT INTO ##RelationalProbeHash (fk_stk_id, ColumnValue, ValueCount)'
	+ @SQL
END

FETCH NEXT FROM RelationalProbeResolver
INTO @Object, @Column, @TblKey, @ColumnDefinition

END

CLOSE RelationalProbeResolver
DEALLOCATE RelationalProbeResolver




-- Execution Batches
INSERT INTO dbo.GeospatialRelationalProbeStack
SELECT *
FROM ##RelationalProbeStack


INSERT INTO dbo.GeospatialRelationalProbeHash
SELECT *
FROM ##RelationalProbeHash


--select *
--from dbo.GeospatialRelationalProbeStack
--order by stk_id


CREATE CLUSTERED INDEX idx_ci_Geospat_Values ON dbo.GeospatialRelationalProbeHash (ValueCount DESC, fk_stk_id)



/* Strong Intersection Summary */

SELECT T.ColumnName, S.Intersection
, T.stk_id
FROM dbo.GeospatialRelationalProbeStack AS T WITH(NOLOCK)
JOIN (
	SELECT T1.ColumnName, COUNT(DISTINCT T2.QualifiedObject) as Intersection
	FROM dbo.GeospatialRelationalProbeStack AS T1 WITH(NOLOCK)
	JOIN dbo.GeospatialRelationalProbeStack AS T2 WITH(NOLOCK)
	ON T1.ColumnName = T2.ColumnName
	GROUP BY T1.ColumnName
	) as S
ON S.ColumnName = T.ColumnName
ORDER BY Intersection DESC



/* Strong Intersection Details */

SELECT T3.stk_id, S1.EstimateIntersection, T3.QualifiedObject, T3.ColumnName
INTO #ProbStackEstimateIntersection
FROM dbo.GeospatialRelationalProbeStack AS T3 WITH(NOLOCK)
JOIN (
	SELECT T1.ColumnName, COUNT(DISTINCT T2.fk_stk_id) as EstimateIntersection
	FROM dbo.GeospatialRelationalProbeStack AS T1 WITH(NOLOCK)
	JOIN dbo.GeospatialRelationalProbeHash AS T2 WITH(NOLOCK)
	ON T1.stk_id = T2.fk_stk_id
	WHERE ISNULL(T2.Value,'') <> ''
	--AND T2.ValueCount > 1
	GROUP BY T1.ColumnName
	--HAVING COUNT(DISTINCT T2.fk_stk_id) BETWEEN 2 and 30
	) as S1
ON S1.ColumnName = T3.ColumnName

SELECT Value
, SUM(ValueCount) as SumValueCount
, COUNT(DISTINCT fk_stk_id) as IntersectionActual
--INTO #ProbeStackActualIntersection
FROM dbo.GeospatialRelationalProbeHash WITH(NOLOCK)
WHERE ISNULL(Value,'') <> ''
GROUP BY Value
--HAVING COUNT(DISTINCT fk_stk_id) > 2

INSERT INTO dbo.GeospatialRelationalIntersectionTest (QualifiedObject, ColumnName, EstimateIntersection, fk_stk_id, Value, ValueCount, IntersectionActual, GlobalValueCount)
SELECT S2.QualifiedObject, S2.ColumnName, S2.EstimateIntersection
, T4.fk_stk_id, T4.Value, T4.ValueCount
, S3.IntersectionActual, S3.SumValueCount
FROM dbo.GeospatialRelationalProbeHash AS T4 WITH(NOLOCK)
JOIN #ProbStackEstimateIntersection as S2
ON S2.stk_id = T4.fk_stk_id
--AND S2.EstimateIntersection BETWEEN 2 AND 37
JOIN #ProbeStackActualIntersection AS S3
ON S3.Value = T4.Value
--WHERE T4.Value = '"El Campito"'
ORDER BY T4.Value, IntersectionActual DESC, ValueCount DESC


select *
from GeospatialRelationalIntersectionTest
where isnumeric(Value) = 0
and isdate(Value) = 0
and IntersectionActual > 1
--and Value = '"El Campito"'
order by Value, IntersectionActual, QualifiedObject


/* Referential Score Algorithm

Magnification Method:
% Match of Column Names and Data Types
*
% Match of Values DistinctValues = S1US2 and SumValueCount == S1US2

*/


select *
FROM dbo.GeospatialRelationalProbeHash AS T1 WITH(NOLOCK) -- epect 4, see 3?
JOIN dbo.GeospatialRelationalProbeStack AS T2 WITH(NOLOCK)
ON T2.stk_id = T1.fk_stk_id
WHERE T1.Value = '"El Campito"'





