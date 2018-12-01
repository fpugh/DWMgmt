USE DWMgmt
GO


--CREATE TABLE CAT.WFT_0454_Profile_Assessor (
--SERVER_NAME NVARCHAR(256) NOT NULL
--, FULLY_QUALIFIED_NAME NVARCHAR(512) NOT NULL 
--, SCAN_MODE NVARCHAR(65) NOT NULL
--, FCST_DURATION TIME NULL
--, POST_DATE DATETIME NOT NULL DEFAULT GETDATE()
--, CONSTRAINT CK_FQN_Format_Valid CHECK (PATINDEX('%.%.%', FULLY_QUALIFIED_NAME) > 0)
--)
--GO


--CREATE PROCEDURE CAT.WFT_3454_Profile_Assessor_Manager
--AS

DECLARE @TARGET_SERVER NVARCHAR(256) = 'ALL'


--What we want to know:
--1. Total Rows - fundamental volume measurement. Useful when calculating index-step cost, or recursive costs.
--2. Distinct Values, NULL Records, Density, Cardinality(Uniqueness). Determines the category of the table:
--	a. Low total records, high density, and high uniqueness = lookup table 
--	b. Low total records, high density, and moderate to high uniqueness = dimension table
--	c. Low total records, low densisty, and low to moderate uniquness = secondary dimension table
--	d. High total records, high density, and low uniqueness = fact table
--	c. High total records, moderate to high densisty, and low to moderate uniquness = denormalized fact table
--3. Theoretical Max Size - sum potential row bytes * total rows. Determines maximum capacity requirements for storage.
--4. Hypothetical Max Size - row-density modified row bytes * total rows. Estimated capacity requirement for storage.
--	a. Requires a density measurement from a detailed scan.
--	b. sum([density * avg_row_size_bytes])
--	c. Most functional measurements are made on this value.
--5. Read/Write ratio: How often does the data churn? Higher churn rates should be monitored more frequently.
--	a. The closer this is to 1 the more frequently indexes for this table should be scanned at a high level to detect overall fragmentation.
--	b. Cross check sources with very high read rates Lim->0; against index performance; 
--		1. How frequently the index fragments indicates the need to build in more padding - determine this by identifing link between padding and growth rate.
--		2. How many lookup events occur on the field; this may indicate bad index coverage over-all. Identify idexes related to this. 
--			a. Create filtered indexes for high use/high volume seek or single value lookups, (SQL 2008 +??)
--			b. create covering indexes for the most expensive predicates (SQL 2005 +)
--			c. create simple non-clustered indexes on columns with high lookup ratios, but not covered by an existing index.
--			d. allow lookup or scan actions for any other low frequency/low volume entries
--6. Elapsed Write bounds: 
--	a. Average time between writes. Determine minimum bound between profiling
--	b. Average overwrite time. The elapsed time between when data could be considered 100% chaged as a sum of write percentage * writes. Determine maximum bound between profiling.


/* Create Working dataset
	This requires distinct, objects may be dropped, recreated, and rescanned within minutes and (legitimately) produce two or more rows with the same values.
	*/

IF EXISTS (SELECT name FROM tempdb.sys.tables WHERE name LIKE N'#RawVals%')
DROP TABLE #RawVals


SELECT vh200.REG_Server_Name, vh200.Fully_Qualified_Name, vh200.Column_Definition, vh200.LNK_T4_ID
, t300.TRK_Last_Action_Date, t300.TRK_Post_Date, t300.Total_Seeks, t300.Total_Lookups, t300.Total_Scans, t300.Total_Updates
, v355.VID as Profile_ID, v355.TRK_total_values, v355.TRK_distinct_values, v355.TRK_uniqueness, v355.TRK_Column_nulls
--INTO #RawVals
FROM CAT.VH_0200_Column_Tier_Latches AS vh200 -- want to lookback on all instances of an object.
LEFT JOIN CAT.TRK_0300_Object_Utiliztion_Metrics AS t300
ON vh200.LNK_T3_ID = t300.TRK_FK_T3_ID
LEFT JOIN CAT.VH_0354_Object_Data_Profile AS v355 -- want the current profiles, or indication that no recent profile exists.
ON v355.LNK_T3_ID = vh200.LNK_T3_ID
AND v355.LNK_T4_ID = vh200.LNK_T4_ID
--WHERE (@TARGET_SERVER = 'ALL' OR CHARINDEX(@TARGET_SERVER, vh200.REG_Server_Name) > 0)
ORDER BY 1,2,3


/* Summary values:
	Identify the range of monitoring, number of scans and profiles performed
	*/

SELECT REG_Server_Name, Fully_Qualified_Name, Column_Definition
, MIN(TRK_Last_Action_Date) as MIN_ACTION_DATE
, MAX(TRK_Last_Action_Date) as MAX_ACTION_DATE
--, ISNULL(AVG(DATEDIFF(SECOND, TRK_Last_Action_Date, GETDATE())),0) as AVG_SCAN_ACCUITY
--, ISNULL(STDEV(DATEDIFF(SECOND, TRK_Last_Action_Date, GETDATE())),0) as STDV_SCAN_ACCUITY
, ISNULL(AVG(DATEDIFF(DAY, TRK_Last_Action_Date, GETDATE())),0) as AVG_SCAN_ACCUITY
, ISNULL(STDEV(DATEDIFF(DAY, TRK_Last_Action_Date, GETDATE())),0) as STDV_SCAN_ACCUITY
, COUNT(*) as COUNT_OF_SCANS
, COUNT(Profile_ID) as COUNT_OF_PROFILES
FROM #RawVals
GROUP BY REG_Server_Name, Fully_Qualified_Name, Column_Definition
HAVING COUNT(Profile_ID) > 0
ORDER BY 1,2,3


/* Earliest Values:
	Establish the first scan, profile, and base record sizes.
	*/

SELECT DSet.*
FROM #RawVals as DSet
JOIN (
	SELECT REG_Server_Name, Fully_Qualified_Name, Column_Definition
	, MIN(TRK_POST_DATE) AS First_Post
	FROM #RawVals
	GROUP BY REG_Server_Name, Fully_Qualified_Name, Column_Definition
	--ORDER BY 1,2,3
	) as Mins
ON Mins.First_Post = DSet.TRK_Post_Date
AND Mins.Column_Definition = DSet.Column_Definition
AND Mins.Fully_Qualified_Name = DSet.Fully_Qualified_Name
AND Mins.REG_Server_Name = DSet.REG_Server_Name
ORDER BY 1,2,3


/* Latest Values:
	Establish the most recent scan, profile, and base record sizes.
	*/

SELECT DSet.*
FROM #RawVals as DSet
JOIN (
	SELECT REG_Server_Name, Fully_Qualified_Name, Column_Definition
	, MAX(TRK_POST_DATE) AS Last_Post
	FROM #RawVals
	GROUP BY REG_Server_Name, Fully_Qualified_Name, Column_Definition
	) as Mins
ON Mins.Last_Post = DSet.TRK_Post_Date
AND Mins.Column_Definition = DSet.Column_Definition
AND Mins.Fully_Qualified_Name = DSet.Fully_Qualified_Name
AND Mins.REG_Server_Name = DSet.REG_Server_Name
ORDER BY 1,2,3





/* Tables and views in multiple locations. */
	-- Compare with object similarity and value hash analysis for more accurate assessment of conformance.

  select [REG_Object_Name],[REG_Object_Type]
  ,count(distinct [LNK_FK_0200_ID])AS DBCount
  ,count(*) AS RowsReturned
  from [DWMgmt].[CAT].[VI_0300_Full_Object_Map]
  where [REG_Schema_Name] NOT IN ('sys','INFORMATION_SCHEMA')
  AND [REG_Object_Type] IN ('U','V')
  group by [REG_Object_Name],[REG_Object_Type]
  having count(distinct [LNK_FK_0200_ID]) > 1
  order by 2,1


/* Object Similarity */
	-- Compare objects with similar column and datatype distributions.
	-- Compare use and data statistics to identify relationships in activity patterns.
	-- Regex and Levenshtein scoring of column names
	-- USE WFT_0454_Profile_Assessor






