USE DWMgmt
GO




DECLARE @BatchLimit BIGINT = 260000
, @Blades INT = 6 -- the estimated number of processors allowed to perform this task.

SELECT 'ALL' as KeyAttribute
, count(file_path) as Batch_Items
, sum(cast(file_size as bigint)) as Batch_Size
, @BatchLimit as Maximum_Batch_Size
, @BatchLimit - sum(cast(file_size as bigint)) as Batch_Capacity
, SUM(CAST(File_Size as bigint))/@BatchLimit
+ CASE WHEN @BatchLimit - SUM(CAST(File_Size as bigint)) < 0 
	THEN 1 ELSE 0 END AS Batches_Required
, (SUM(CAST(File_Size as bigint))/(@BatchLimit
		+ (CASE WHEN @BatchLimit - SUM(CAST(File_Size as bigint)) < 0 
			THEN 1 ELSE 0 END)) 
		 / @Blades
	) AS Batch_Cycles_Required
INTO #BulkBatches
FROM LIB.External_String_Intake_Stack
--WHERE 1=1
--AND LEFT(Batch_ID, 3) NOT IN ('SQL','XML','ARC')
--AND RTRIM(Batch_ID) NOT LIKE '%L'


/* Get oversized items into a special set -
	TXTB002 - TXTB999: Upto 999 seperate batches can be used on a file - which is extreme: 
	Its Probably breakup the file manually outside of the process in cases like this 
	*/

SELECT stk.File_Path
, 1 as Batch_Items
, stk.File_Size as Batch_Size
, @BatchLimit as Maximum_Batch_Size
, @BatchLimit - stk.File_Size as Batch_Capacity
, stk.File_Size/@BatchLimit
+ CASE WHEN @BatchLimit - stk.File_Size < 0 
	THEN 1 ELSE 0 END AS Batches_Required
, (stk.File_Size/@BatchLimit
+ CASE WHEN @BatchLimit - stk.File_Size < 0 
	THEN 1 ELSE 0 END)
	/ @Blades AS Batch_Cycles_Required
INTO #OversizeFileBatches
FROM LIB.External_String_Intake_Stack AS stk
WHERE @BatchLimit < stk.File_Size
ORDER BY Batches_Required DESC


SELECT 'Raw_Batches' as KeyAttribute
, count(stk.file_path) as Batch_Items
, sum(cast(stk.file_size as bigint)) as Batch_Size
, @BatchLimit as Maximum_Batch_Size
, @BatchLimit - sum(cast(stk.file_size as bigint)) as Batch_Capacity
, sum(cast(stk.file_size as bigint))/@BatchLimit
+ CASE WHEN @BatchLimit - sum(cast(stk.file_size as bigint)) < 0 
	THEN 1 ELSE 0 END AS Batches_Required
, (SUM(CAST(File_Size as bigint))/(@BatchLimit
		+ (CASE WHEN @BatchLimit - SUM(CAST(File_Size as bigint)) < 0 
			THEN 1 ELSE 0 END)) 
		 / @Blades
	) AS Batch_Cycles_Required
INTO #RawTextBatches
FROM LIB.External_String_Intake_Stack AS stk
LEFT JOIN #OversizeFileBatches AS tmp
ON tmp.File_Path = stk.File_Path
WHERE tmp.Batches_Required IS NULL


SELECT DISTINCT stk.File_Type
, COUNT(DISTINCT stk.File_Path) as Batch_Items
, SUM(stk.File_Size) as Batch_Size
, @BatchLimit as Maximum_Batch_Size
, @BatchLimit - SUM(stk.File_Size) as Batch_Capacity
, CASE WHEN @BatchLimit - SUM(stk.File_Size) < 0 THEN SUM(stk.File_Size)/@BatchLimit
	ELSE 1 END
+ CASE WHEN @BatchLimit - SUM(stk.File_Size) < 0
	THEN 1 ELSE 0 END AS Batches_Required
, (SUM(CAST(File_Size as bigint))/(@BatchLimit
		+ (CASE WHEN @BatchLimit - SUM(CAST(File_Size as bigint)) < 0 
			THEN 1 ELSE 0 END)) 
		 / @Blades
	) AS Batch_Cycles_Required
INTO #BatchesByType
FROM LIB.External_String_Intake_Stack AS stk
LEFT JOIN #OversizeFileBatches AS tmp
ON tmp.File_Path = stk.File_Path
WHERE tmp.Batches_Required IS NULL
GROUP BY stk.File_Type


select *
from #BulkBatches

select *
from #RawTextBatches

select *
from #OversizeFileBatches

select *
from #BatchesByType


--drop table #Batcher


 DECLARE @BatchLimit bigint = 260000
, @RawBatches int = 15

SELECT TOP (@RawBatches) stk.STK_ID
, stk.File_Size as Current_Batch
, DENSE_RANK() OVER(ORDER BY stk.File_Size DESC) AS BinRank
INTO #Batcher
FROM LIB.External_String_Intake_Stack AS stk
LEFT JOIN #OversizeFileBatches AS tmp
ON tmp.File_Path = stk.File_Path
WHERE tmp.Batches_Required IS NULL


WHILE @@RowCount > 0
BEGIN
	INSERT INTO #Batcher

	SELECT dom.STK_ID
	, dom.File_Size + crp.Current_Batch AS Current_Batch
	, crp.BinRank
	FROM (
		SELECT TOP (@RawBatches) stk.STK_ID
		, stk.File_Size
		, DENSE_RANK() OVER(ORDER BY stk.File_Size DESC) AS BinRank
		FROM LIB.External_String_Intake_Stack AS stk
		LEFT JOIN #OversizeFileBatches AS ofb
		ON ofb.File_Path = stk.File_Path
		LEFT JOIN #Batcher AS bat WITH(NOLOCK)
		ON bat.STK_ID = stk.STK_ID
		WHERE 1=1
		AND ofb.Batch_Items IS NULL
		AND bat.STK_ID IS NULL
	) AS dom
	CROSS APPLY (
		SELECT BinRank, MAX(Current_Batch) AS Current_Batch
		FROM #Batcher WITH(NOLOCK)
		GROUP BY BinRank
	) AS crp
	WHERE crp.BinRank + dom.BinRank = (@RawBatches + 1)
	AND crp.Current_Batch + dom.File_Size < @BatchLimit
END





select Batch_ID, BinRank
,'TXTL' + RIGHT('000'+cast(BinRank as varchar),3)
--update stk set Batch_ID = 'TXTL' + RIGHT('000'+cast(BinRank as varchar),3)
from LIB.External_String_Intake_Stack AS stk
join #Batcher as bat
on bat.STK_ID = stk.STK_ID




select *
from tmp.TXT_Process_Hash

select count(*)
from tmp.TXT_String_Map




		SELECT BinRank
		, MAX(Current_Batch) AS Current_Batch
		, MAX(Current_Batch) / 4000 as segments
		, MAX(Current_Batch) / 260000.000
		FROM #Batcher WITH(NOLOCK)
		GROUP BY BinRank



/* Assign primary Batch_ID code
	- Assign by file type, and size
	-- Objective: Quickly seperate out files with quick/special parsing rules
	-- Considerations: Filter out archives, XML files, SQL scripts, etc. These have special rules that allow for faster analysis.
	--- Identify very long strings and assing to linear (One long-running background process) or slice-and-dice processing (sparate a single string into segments)
*/

SELECT *,
--UPDATE stk SET Batch_ID =
CASE WHEN viw.Parent_Collection IN ('Archives') THEN 'ARCZ999'
	WHEN viw.Parent_Collection IS NULL AND stk.File_Size < 2600000 THEN 'TXTF'
	WHEN viw.Parent_Collection IS NOT NULL THEN UPPER(LEFT(viw.Parent_Collection,3))
	+ CASE WHEN qps.Collection_Key IS NOT NULL THEN 'Q'
		WHEN qps.Collection_Key IS NULL AND stk.File_Size < 2600000 THEN 'F' 
		ELSE 'L' END
	ELSE UPPER(LEFT(REPLACE(File_Type,'.',''),3)) + 'L' END
FROM LIB.External_String_Intake_Stack AS stk WITH(NOLOCK)
LEFT JOIN LIB.VI_2119_Simple_Collection_List AS viw WITH(NOLOCK)
ON viw.Subordinate_Collection = stk.File_Type
AND viw.Parent_Collection NOT IN ('File Types','Quick Parse')
LEFT JOIN LIB.VI_2119_Simple_Collection_List AS qps WITH(NOLOCK)
ON qps.Subordinate_Collection = stk.File_Type
AND	qps.Parent_Collection IN ('Quick Parse')




; IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = N'BatchEstimates')
	CREATE TABLE TMP.BatchEstimates (Batch_ID VARCHAR(7), Items INT, Total_File_Size BIGINT, Avg_Unit_Size BIGINT, StdDev_Unit_Size BIGINT, Estimate_Batches BIGINT, Target_Batch_Units BIGINT)
ELSE
	TRUNCATE TABLE TMP.BatchEstimates

INSERT INTO TMP.BatchEstimates (Batch_ID, items, Total_File_Size, Avg_Unit_Size, StdDev_Unit_Size, Estimate_Batches, Target_Batch_Units)

SELECT ags.Batch_ID, ags.Items, ags.Total_File_Size, ags.Avg_Unit_Size, ags.StdDev_Unit_Size

, CASE WHEN sum(cast(file_size as bigint)) / 2600000.0000 
- sum(cast(file_size as bigint)) / 2600000 > 0 
	THEN sum(cast(file_size as bigint)) / 2600000 + 1 
	ELSE sum(cast(file_size as bigint)) / 2600000 END AS Estimate_Batches

, CASE WHEN sum(cast(file_size as bigint)) = 0 OR avg(cast(file_size as bigint)) = 0 THEN 0
	ELSE sum(cast(file_size as bigint))
	/ (CASE WHEN sum(cast(file_size as bigint)) / 2600000.0000 
		- sum(cast(file_size as bigint)) / 2600000 > 0 
		THEN sum(cast(file_size as bigint)) / 2600000 + 1 
		ELSE sum(cast(file_size as bigint)) / 2600000 END)
	/ avg(cast(file_size as bigint)) END AS Target_Batch_Units

FROM LIB.External_String_Intake_Stack AS stk WITH(NOLOCK)
CROSS APPLY (
	SELECT Batch_ID
	, count(distinct Version_Stamp) as Items
	, sum(cast(file_size as bigint)) as Total_File_Size
	, avg(cast(file_size as bigint)) as Avg_Unit_Size
	, stdev(cast(file_size as bigint)) as StdDev_Unit_Size
	FROM LIB.External_String_Intake_Stack WITH(NOLOCK)
	WHERE LEFT(Batch_ID, 3) NOT IN ('ARC')
	AND RTRIM(Batch_ID) NOT LIKE '%L'
	GROUP BY Batch_ID
	) AS Ags
WHERE Ags.Batch_ID = stk.Batch_ID
GROUP BY ags.Batch_ID, ags.Items, ags.Total_File_Size, ags.Avg_Unit_Size, ags.StdDev_Unit_Size




; IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = N'BatchSort')
	CREATE TABLE TMP.BatchSort (Batch_ID CHAR(7), File_Size BIGINT, Version_Stamp CHAR(40))
ELSE 
	TRUNCATE TABLE TMP.BatchSort


DECLARE @SQL NVARCHAR(4000)
, @Batch_ID NVARCHAR(7)
, @Batch_Count NVARCHAR(16)

DECLARE BatchPacker CURSOR FOR
SELECT Estimate_Batches, Batch_ID
FROM TMP.BatchEstimates

OPEN BatchPacker

FETCH NEXT FROM BatchPacker
INTO @Batch_Count, @Batch_ID

WHILE @@FETCH_STATUS = 0

BEGIN
SET @SQL = '
DECLARE @I INT = 0

WHILE (
	SELECT COUNT(*)
	FROM LIB.External_String_Intake_Stack AS stk
	LEFT JOIN TMP.BatchSort AS flt WITH(NOLOCK)
	ON flt.Version_Stamp = stk.Version_Stamp
	WHERE flt.Version_Stamp IS NULL
	AND left(stk.Batch_ID,4) = '''+@Batch_ID+'''
	AND RTRIM(stk.Batch_ID) NOT LIKE ''%L''
	) > 0

BEGIN
	IF @I % 2 = 1 OR (
		SELECT CASE WHEN ISNULL(STDEV(Batch_Size),0) = 0 THEN 1
			ELSE est.StdDev_Unit_Size / STDEV(Batch_Size) END AS Result
		FROM (
			SELECT Batch_ID, SUM(File_Size) as Batch_Size
			FROM TMP.BatchSort WITH(NOLOCK)
			WHERE LEFT(Batch_ID,4) = '''+@Batch_ID+'''
			GROUP BY Batch_ID
			) as sub
		LEFT JOIN TMP.BatchEstimates AS est WITH(NOLOCK)
		ON est.Batch_ID = left(sub.Batch_ID,4)
		GROUP BY est.Batch_ID, est.StdDev_Unit_Size
		) < .5
	BEGIN
		INSERT INTO TMP.BatchSort (Batch_ID, File_Size, Version_Stamp)

		SELECT DISTINCT TOP '+@Batch_Count+' RTRIM(stk.Batch_ID) + RIGHT(''000'' + CAST(DENSE_RANK() OVER (ORDER BY stk.File_Size DESC) AS VARCHAR(3)), 3) as Batch_ID
		, stk.File_Size, stk.Version_Stamp
		FROM LIB.External_String_Intake_Stack AS stk
		LEFT JOIN TMP.BatchSort AS flt WITH(NOLOCK)
		ON flt.Version_Stamp = stk.Version_Stamp
		LEFT JOIN (
			SELECT Batch_ID, 2600000 - SUM(File_Size) AS Batch_Cap
			FROM TMP.BatchSort WITH(NOLOCK)
			GROUP BY Batch_ID
			) AS vol
			ON stk.Batch_ID = vol.Batch_ID
		CROSS APPLY TMP.BatchEstimates AS crp
		WHERE crp.Batch_ID = stk.Batch_ID
		AND left(stk.Batch_ID,4) = '''+@Batch_ID+'''
		AND flt.Version_Stamp IS NULL
		AND ISNULL(vol.Batch_Cap,0) >= 0
		ORDER BY 2 DESC, 1, 3
	END

	IF @I % 2 = 0
	OR (
		SELECT CASE WHEN ISNULL(STDEV(Batch_Size),0) = 0 THEN 1
			ELSE est.StdDev_Unit_Size / STDEV(Batch_Size) END AS Result
		FROM (
			SELECT Batch_ID, SUM(File_Size) as Batch_Size
			FROM TMP.BatchSort WITH(NOLOCK)
			WHERE LEFT(Batch_ID,4) = '''+@Batch_ID+'''
			GROUP BY Batch_ID
			) as sub
		LEFT JOIN TMP.BatchEstimates AS est WITH(NOLOCK)
		ON est.Batch_ID = left(sub.Batch_ID,4)
		GROUP BY est.Batch_ID, est.StdDev_Unit_Size
		) >= .5
	BEGIN
		INSERT INTO TMP.BatchSort (Batch_ID, File_Size, Version_Stamp)

		SELECT RTRIM(sub.Batch_ID) + RIGHT(''000'' + CAST(DENSE_RANK() OVER (ORDER BY sub.File_Size, sub.Version_Stamp DESC) AS VARCHAR(3)), 3) as Batch_ID
		, sub.File_Size, sub.Version_Stamp
		FROM (
			SELECT DISTINCT TOP '+@Batch_Count+' stk.Batch_ID
			, stk.File_Size, stk.Version_Stamp
			FROM LIB.External_String_Intake_Stack AS stk
			LEFT JOIN TMP.BatchSort AS flt WITH(NOLOCK)
			ON flt.Version_Stamp = stk.Version_Stamp
			LEFT JOIN (
				SELECT Batch_ID, 2600000 - SUM(File_Size) AS Batch_Cap
				FROM TMP.BatchSort WITH(NOLOCK)
				GROUP BY Batch_ID
				) AS vol
			ON stk.Batch_ID = vol.Batch_ID
			CROSS APPLY TMP.BatchEstimates AS crp
			WHERE crp.Batch_ID = stk.Batch_ID
			AND left(stk.Batch_ID,4) = '''+@Batch_ID+'''
			AND flt.Version_Stamp IS NULL
			AND ISNULL(vol.Batch_Cap,0) >= 0
			ORDER BY 2, 1, 3
			) AS sub
	END

	SET @I = @I + 1
END
'
PRINT @SQL
EXEC sp_executeSQL @SQL

FETCH NEXT FROM BatchPacker
INTO @Batch_Count, @Batch_ID

END

CLOSE BatchPacker
DEALLOCATE BatchPacker




SELECT Batch_ID, SUM(File_Size) as Batch_Size, count(*) as Batch_Units
, STDEV(File_Size) as Variation
FROM TMP.BatchSort
GROUP BY Batch_ID
ORDER BY Batch_ID, Batch_Size




select *
from TMP.TXT_String_Map

select *
from TMP.TXT_Process_Hash


