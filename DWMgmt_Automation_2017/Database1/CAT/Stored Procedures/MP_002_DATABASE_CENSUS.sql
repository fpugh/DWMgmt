

CREATE PROCEDURE [CAT].[MP_002_DATABASE_CENSUS]
@TargetDBLocation NVARCHAR(200)
, @SourceDBLocation NVARCHAR(200) = N'DWMgmt'
, @SourceCollation NVARCHAR(60) = N'SQL_Latin1_General_CP1_CI_AS'
, @ExecuteStatus TINYINT = 2

AS

IF @ExecuteStatus IN (0,2) SET NOCOUNT ON

DECLARE @SQL NVARCHAR(max)
, @ServerID NVARCHAR(16) 
, @SQL1 NVARCHAR(4000)
, @SQL2 NVARCHAR(4000)
, @SQL3 NVARCHAR(4000)
, @SQL4 NVARCHAR(4000)
, @SQL5 NVARCHAR(4000)
, @SQL6 NVARCHAR(4000)
, @SQL7 NVARCHAR(4000)
, @SQL8 NVARCHAR(4000)
, @SQL9 NVARCHAR(4000)
, @SQL10 NVARCHAR(4000)
, @SQL11 NVARCHAR(4000)
, @ExecuteSQL NVARCHAR(500)


/* This sets the @ServerID variable = the REG_0100_ID for the target server */

SELECT @ServerID = ISNULL(REG_0100_ID,0)
FROM CAT.REG_0100_Server_Registry
WHERE @@SERVERNAME = REG_Server_name


/* Padding 0s everywhere may seem silly, but is effective as and far less code than setting up a table default or isnull() transformations. */


/* Register database file information */

SET @SQL1 = '
SELECT 0, '+@ServerID+', DB_ID() as Database_ID, dbf.size, dbf.max_Size, dbf.Growth, dbf.physical_Name, dbf.File_ID, dbf.type, dbf.name as Database_File_Name
FROM ['+@TargetDBLocation+'].sys.database_files AS dbf
' 

IF @ExecuteStatus <> 3 SET @SQL1 = '
INSERT INTO ['+@SourceDBLocation+'].TMP.REG_0203_Insert (REG_0203_ID, Server_ID, Database_ID, size, max_Size, growth, physical_Name
, File_ID, type, Database_File_Name)
' + @SQL1


/* Enlist all primary objects */

SET @SQL2 = '
SELECT DISTINCT 0, 0, 0, 0, '+@ServerID+', DB_ID() as Database_ID, scm.Schema_ID, scm.name, obj.Object_ID, 0 as Object_Rank
, obj.name as Object_Name, obj.type as Object_Type, obj.Create_Date
FROM ['+@TargetDBLocation+'].sys.schemas AS scm
JOIN ['+@TargetDBLocation+'].sys.all_objects AS obj
ON obj.Schema_ID = scm.Schema_ID
WHERE obj.Parent_Object_ID = 0
AND obj.type <> ''IT''
'

IF @ExecuteStatus <> 3 SET @SQL2 = '
INSERT INTO ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert (LNK_T2_ID, LNK_T3_ID, REG_0204_ID, REG_0300_ID, Server_ID
, Database_ID, Schema_ID, Schema_Name, Object_ID, Sub_Object_Rank, Object_Name, Object_Type, Create_Date)
' + @SQL2


SET @SQL3 = '
SELECT DISTINCT 0, 0, 0, 0, 0, 0, 0, 0, 0, '+@ServerID+', DB_ID(), scm.Schema_ID, obj.Object_ID as Parent_Object_ID
, obj.name as Parent_Object_Name
, obj.type as Parent_Object_Type
, idx.name as Index_Name
, CASE WHEN idx.Is_Primary_Key = 1 THEN ''PK''
	WHEN idx.Is_Primary_Key = 0 AND Is_Unique_Constraint = 1 THEN ''UQ''
	WHEN idx.type = 1 THEN ''CI''
	WHEN idx.type = 2 THEN ''NC'' 
	WHEN idx.type = 3 THEN ''XI'' 
	WHEN idx.type = 4 THEN ''SI'' 
	ELSE ''NA''
	END AS Index_Type
, idx.Index_ID as Index_Rank, idx.Is_Unique, idx.data_space_ID, idx.Ignore_Dup_Key
, idx.Is_Primary_Key, idx.Is_Unique_Constraint, idx.Fill_Factor, idx.Is_padded, idx.Is_Disabled, idx.Is_hypothetical
, idx.Allow_Row_Locks, idx.Allow_Page_Locks, col.name as Parent_Column_Name, col.user_Type_ID as Parent_Column_Type
, idc.Index_Column_ID, idc.Column_ID, idc.Is_Descending_Key, idc.Is_Included_Column, idc.Key_ordinal, idc.Partition_Ordinal
FROM ['+@TargetDBLocation+'].sys.schemas AS scm
JOIN ['+@TargetDBLocation+'].sys.all_objects AS obj
ON obj.Schema_ID = scm.Schema_ID
AND obj.type <> ''IT''
JOIN ['+@TargetDBLocation+'].sys.indexes AS idx
ON idx.Object_ID = obj.Object_ID
AND idx.type <> 0
JOIN ['+@TargetDBLocation+'].sys.Index_Columns AS idc
ON idc.Object_ID = obj.Object_ID
AND idc.Object_ID = idx.Object_ID
AND idc.Index_ID = idx.Index_ID
JOIN ['+@TargetDBLocation+'].sys.all_Columns AS col
ON col.Object_ID = obj.Object_ID
AND col.Column_ID = idc.Column_ID
WHERE idx.type IS NOT NULL
'

IF @ExecuteStatus <> 3 SET @SQL3 = '
INSERT INTO ['+@SourceDBLocation+'].TMP.REG_Index_Insert (LNK_T2_ID, LNK_T3_ID, LNK_T4_ID, REG_0204_ID, REG_0300_Ref_ID, REG_0300_Prm_ID, REG_0301_ID, REG_0400_ID
, REG_0402_ID, Server_ID, Database_ID, Schema_ID, Parent_Object_ID, Parent_Object_Name, Parent_Object_Type, Index_Name, Index_Type, Index_Rank, Is_Unique, data_space_ID
, Ignore_Dup_Key, Is_Primary_Key, Is_Unique_Constraint, Fill_Factor, Is_padded, Is_Disabled, Is_hypothetical, Allow_Row_Locks, Allow_Page_Locks, Parent_Column_Name
, Parent_Column_Type, Index_Column_ID, Column_ID, Is_Descending_Key, Is_Included_Column, Key_ordinal, Partition_Ordinal)
' + @SQL3


SET @SQL4 = '
SELECT DISTINCT scm.Schema_ID, fk.Object_ID, 1 AS Reference_Type, ao.name AS Object_Name
, keyc.Constraint_Object_ID, keyc.Constraint_Column_ID
, col.name as Ref_Column_Name
, col.user_Type_ID as Ref_Column_Type
INTO #Object_References
FROM ['+@TargetDBLocation+'].sys.schemas AS scm
JOIN ['+@TargetDBLocation+'].sys.all_objects AS ao
ON ao.Schema_ID = scm.Schema_ID
JOIN ['+@TargetDBLocation+'].sys.foreign_Keys AS fk
ON fk.Object_ID = ao.Object_ID
JOIN ['+@TargetDBLocation+'].sys.foreign_Key_Columns AS keyc
ON keyc.Constraint_Object_ID = fk.Object_ID
JOIN ['+@TargetDBLocation+'].sys.all_Columns AS col
ON col.Object_ID = fk.Parent_Object_ID
AND col.Column_ID = keyc.Parent_Column_ID
UNION
SELECT DISTINCT scm.Schema_ID, fk.Object_ID, 2, ao.name
, keyc.Parent_Object_ID
, keyc.Parent_Column_ID
, col.name
, col.user_Type_ID
FROM ['+@TargetDBLocation+'].sys.schemas AS scm
JOIN ['+@TargetDBLocation+'].sys.all_objects AS ao
ON ao.Schema_ID = scm.Schema_ID
JOIN ['+@TargetDBLocation+'].sys.foreign_Keys AS fk
ON fk.Parent_Object_ID = ao.Object_ID
JOIN ['+@TargetDBLocation+'].sys.foreign_Key_Columns AS keyc
ON keyc.Constraint_Object_ID = fk.Object_ID
AND keyc.Parent_Object_ID = fk.Parent_Object_ID
JOIN ['+@TargetDBLocation+'].sys.all_Columns AS col
ON col.Object_ID = fk.Parent_Object_ID
AND col.Column_ID = keyc.Parent_Column_ID
UNION
SELECT DISTINCT scm.Schema_ID, fk.Object_ID, 3, ao.name
, keyc.Referenced_Object_ID
, keyc.Referenced_Column_ID
, col.name
, col.user_Type_ID
FROM ['+@TargetDBLocation+'].sys.schemas AS scm
JOIN ['+@TargetDBLocation+'].sys.all_objects AS ao
ON ao.Schema_ID = scm.Schema_ID
JOIN ['+@TargetDBLocation+'].sys.foreign_Keys AS fk
ON fk.Referenced_Object_ID = ao.Object_ID
JOIN ['+@TargetDBLocation+'].sys.foreign_Key_Columns AS keyc
ON keyc.Constraint_Object_ID = fk.Object_ID
AND keyc.Referenced_Object_ID = fk.Referenced_Object_ID
JOIN ['+@TargetDBLocation+'].sys.all_Columns AS col
ON col.Object_ID = fk.Referenced_Object_ID
AND col.Column_ID = keyc.Referenced_Column_ID
'

SET @SQL5 = '
SELECT DISTINCT 0, 0, 0, 0, 0, 0, 0, 0, 0, '+@ServerID+', DB_ID() as Database_ID, cte1.Schema_ID, cte1.Object_ID
, DENSE_Rank() OVER (PARTITION BY keys.Parent_Object_ID ORDER BY keys.name) as Sub_Object_Rank
, cte1.Object_Name COLLATE Database_Default as Key_Name, cast(keys.type as nvarchar) COLLATE Database_Default as Key_Type
, 1 as Key_Column_ID, cte2.Object_Name COLLATE Database_Default as Referenced_Object_Name
, cte2.Constraint_Object_ID as Referenced_Object_ID, cte2.Ref_Column_Name as Referenced_Column_Name
, cte2.Ref_Column_Type as Referenced_Column_Type, cte2.Constraint_Column_ID as Parent_Column_ID, keys.Create_Date as Create_Date
, keys.Is_ms_Shipped, keys.Is_Published, keys.Is_Schema_Published, keys.Key_Index_ID, keys.Is_Disabled
, keys.Is_not_for_Replication, keys.Is_not_trusted, keys.delete_referential_action, keys.delete_referential_action_Desc
, keys.update_referential_action, keys.update_referential_action_Desc, keys.Is_System_Named
FROM ['+@TargetDBLocation+'].sys.foreign_Keys AS keys
JOIN ['+@TargetDBLocation+'].sys.foreign_Key_Columns AS keyc
ON keyc.Constraint_Object_ID = keys.Object_ID
JOIN #Object_References AS cte1
ON cte1.Schema_ID = keys.Schema_ID
AND cte1.Constraint_Object_ID = keys.Object_ID
AND cte1.Constraint_Column_ID = keyc.Constraint_Column_ID
AND cte1.Reference_Type = 1
JOIN #Object_References AS cte2
ON cte2.Schema_ID = keys.Schema_ID
AND cte2.Constraint_Object_ID = keys.Parent_Object_ID
AND cte2.Constraint_Column_ID = keyc.Parent_Column_ID
AND cte2.Reference_Type = 2
UNION
SELECT DISTINCT 0, 0, 0, 0, 0, 0, 0, 0, 0, '+@ServerID+', DB_ID() as Database_ID, cte1.Schema_ID, cte1.Object_ID
, DENSE_Rank() OVER (PARTITION BY keys.Parent_Object_ID ORDER BY keys.name), cte1.Object_Name COLLATE Database_Default
, cast(keys.type as nvarchar) COLLATE Database_Default, 2, cte3.Object_Name COLLATE Database_Default
, cte3.Constraint_Object_ID, cte3.Ref_Column_Name, cte3.Ref_Column_Type, cte3.Constraint_Column_ID
, keys.Create_Date, keys.Is_ms_Shipped, keys.Is_Published, keys.Is_Schema_Published, keys.Key_Index_ID, keys.Is_Disabled
, keys.Is_not_for_Replication, keys.Is_not_trusted, keys.delete_referential_action, keys.delete_referential_action_Desc
, keys.update_referential_action, keys.update_referential_action_Desc, keys.Is_System_Named
FROM ['+@TargetDBLocation+'].sys.foreign_Keys AS keys
JOIN ['+@TargetDBLocation+'].sys.foreign_Key_Columns AS keyc
ON keyc.Constraint_Object_ID = keys.Object_ID
JOIN #Object_References AS cte1
ON cte1.Reference_Type = 1
AND cte1.Schema_ID = keys.Schema_ID
AND cte1.Constraint_Object_ID = keys.Object_ID
AND cte1.Constraint_Column_ID = keyc.Constraint_Column_ID
JOIN #Object_References AS cte3
ON cte3.Reference_Type = 3
AND cte3.Schema_ID = keys.Schema_ID
AND cte3.Constraint_Object_ID = keys.Referenced_Object_ID
AND cte3.Constraint_Column_ID = keyc.Referenced_Column_ID
'

IF @ExecuteStatus <> 3 SET @SQL5 = '
INSERT INTO ['+@SourceDBLocation+'].TMP.REG_Foreign_Key_Insert (LNK_T2_ID, LNK_T3_ID, LNK_T4_ID, REG_0204_ID, REG_0300_Prm_ID, REG_0300_Ref_ID, REG_0302_ID
, REG_0400_ID, REG_0403_ID, Server_ID, Database_ID, Schema_ID, Key_Object_ID, Sub_Object_Rank, Key_Name, Key_Type, Key_Column_ID, Referenced_Object_Name
,  Referenced_Object_ID,  Referenced_Column_Name,  Referenced_Column_Type,  Referenced_Column_ID, Create_Date, Is_ms_Shipped, Is_Published
, Is_Schema_Published, Key_Index_ID, Is_Disabled, Is_not_for_Replication, Is_not_trusted, delete_referential_action, delete_referential_action_Desc
, update_referential_action, update_referential_action_Desc, Is_System_Named)
' + @SQL5



SET @SQL6 = '
SELECT DISTINCT 0, 0, 0, 0, 0, 0, 0, 0, '+@ServerID+', DB_ID(), scm.Schema_ID, obj.Object_ID
, obj.name as Parent_Object_Name
, obj.type as Parent_Object_Type
, dfx.Object_ID, dfx.name, dfx.type, col.name, col.user_Type_ID
, dfx.Parent_Column_ID, dfx.definition, dfx.Is_ms_Shipped, dfx.Is_Published
, dfx.Is_Schema_Published, dfx.Is_System_Named
FROM ['+@TargetDBLocation+'].sys.schemas AS scm
JOIN ['+@TargetDBLocation+'].sys.all_objects AS obj
ON obj.Schema_ID = scm.Schema_ID
JOIN ['+@TargetDBLocation+'].sys.default_Constraints AS dfx
ON dfx.Parent_Object_ID = obj.Object_ID
JOIN ['+@TargetDBLocation+'].sys.all_Columns AS col
ON col.Object_ID = dfx.Parent_Object_ID
AND col.Column_ID = dfx.Parent_Column_ID
UNION
SELECT DISTINCT 0, 0, 0, 0, 0, 0, 0, 0, '+@ServerID+', DB_ID(), scm.Schema_ID, obj.Object_ID
, obj.name as Parent_Object_Name
, obj.type as Parent_Object_Type
, dfx.Object_ID, dfx.name, dfx.type, col.name, col.user_Type_ID
, dfx.Parent_Column_ID, dfx.definition, dfx.Is_ms_Shipped, dfx.Is_Published
, dfx.Is_Schema_Published, dfx.Is_System_Named
FROM ['+@TargetDBLocation+'].sys.schemas AS scm
JOIN ['+@TargetDBLocation+'].sys.all_objects AS obj
ON obj.Schema_ID = scm.Schema_ID
JOIN ['+@TargetDBLocation+'].sys.check_Constraints AS dfx
ON dfx.Parent_Object_ID = obj.Object_ID
JOIN ['+@TargetDBLocation+'].sys.all_Columns AS col
ON col.Object_ID = dfx.Parent_Object_ID
AND col.Column_ID = dfx.Parent_Column_ID
'

IF @ExecuteStatus <> 3 SET @SQL6 = '
INSERT INTO ['+@SourceDBLocation+'].TMP.REG_Constraint_Insert (LNK_T2_ID, LNK_T3_ID, LNK_T4_ID, REG_0204_ID, REG_0300_Ref_ID, REG_0300_Prm_ID, REG_0302_ID, REG_0400_ID
, Server_ID, Database_ID, Schema_ID, Parent_Object_ID, Parent_Object_Name, Parent_Object_Type, Constraint_Object_ID, Constraint_Name, Constraint_Type
, Parent_Column_Name, Parent_Column_Type, Parent_Column_ID, Constraint_Definition, Is_ms_Shipped, Is_Published, Is_Schema_Published, Is_System_Named)
' + @SQL6


SET @SQL7 = '
SELECT DISTINCT '+@ServerID+', DB_ID() as Database_ID, scm.Schema_ID, scm.name, obj.Object_ID, obj.name
, DENSE_Rank() OVER (PARTITION BY trg.Parent_ID ORDER BY trg.name) as Sub_Object_Rank
, trg.Object_ID, trg.name, trg.type, trg.Is_ms_Shipped, trg.Is_Disabled
, trg.Is_not_for_Replication, trg.Is_instead_of_trigger, trg.Create_Date
FROM ['+@TargetDBLocation+'].sys.schemas AS scm
JOIN ['+@TargetDBLocation+'].sys.all_objects AS obj
ON obj.Schema_ID = scm.Schema_ID
JOIN ['+@TargetDBLocation+'].sys.triggers AS trg
ON obj.Object_ID = trg.Parent_ID
'

IF @ExecuteStatus <> 3 SET @SQL7 = '
INSERT INTO ['+@SourceDBLocation+'].TMP.REG_Trigger_Insert (Server_ID, Database_ID, Schema_ID, Schema_Name, Parent_Object_ID, Parent_Object_Name, Sub_Object_Rank
, Trigger_Object_ID, Trigger_Name, Trigger_Type, Is_ms_Shipped, Is_Disabled, Is_not_for_Replication, Is_instead_of_trigger, Create_Date)
' + @SQL7


SET @SQL8 = '
SELECT DISTINCT 0, 0, map.Schema_Name, map.Object_Name, map.Object_ID
, DENSE_Rank() OVER(PARTITION BY map.LNK_T3_ID, map.REG_0300_ID ORDER BY crap.referencing_ID)
, crap.referencing_Schema_Name, crap.referencing_entity_Name, crap.referencing_ID, crap.Is_caller_dependent
FROM ['+@SourceDBLocation+'].TMP.REG_0204_0300_Insert as map WITH(NOLOCK)
CROSS APPLY ['+@TargetDBLocation+'].sys.dm_sql_referencing_entities(map.Schema_Name+''.''+map.Object_Name, ''OBJECT'') as crap
WHERE crap.referencing_class = 1
AND crap.referencing_ID IS NOT NULL
'

IF @ExecuteStatus <> 3 SET @SQL8 = '
INSERT INTO ['+@SourceDBLocation+'].TMP.REG_0300_0300_Insert (LNK_T3R_ID, LNK_0300_Ref_ID, LNK_Prm_Schema_Name, LNK_Prm_Object_Name
, LNK_Prm_Object_ID, LNK_Rank, LNK_Ref_Schema_Name, LNK_Ref_Object_Name, LNK_Ref_Object_ID, LNK_Ref_Caller_Dependent)
' + @SQL8


SET @SQL9 = '
SELECT DISTINCT 0, 0, 0, 0, 0, 0, '+@ServerID+', DB_ID(), scm.Schema_ID, obj.Object_ID, obj.type, col.name COLLATE '+@SourceCollation+'
, cast(col.user_Type_ID as nvarchar), col.Column_ID, col.Is_Identity, col.Is_Nullable
, CASE WHEN col.collation_Name <> '''+@SourceCollation+''' THEN 1 ELSE 0 END
, CASE WHEN idc.Column_ID IS NULL THEN 0 ELSE 1 END
, CASE WHEN col.precision = 0 AND col.scale = 0 THEN col.max_length
    WHEN col.Is_Identity = 1 THEN isnull(convert(int, idc.seed_Value),0) 
    ELSE col.precision END
, CASE WHEN col.Is_Identity = 1 THEN isnull(convert(int, idc.increment_Value),0) 
    ELSE col.scale END
FROM ['+@TargetDBLocation+'].sys.schemas AS scm
JOIN ['+@TargetDBLocation+'].sys.all_objects AS obj
ON obj.Schema_ID = scm.Schema_ID
AND obj.Parent_Object_ID = 0		-- Added 20140301:4est - Trying to eliminate mis-application of constraint and integrity keys.
AND obj.type <> ''IT''
JOIN ['+@TargetDBLocation+'].sys.all_Columns AS col
ON col.Object_ID = obj.Object_ID
LEFT JOIN ['+@TargetDBLocation+'].sys.identity_Columns AS idc
ON idc.Object_ID = col.Object_ID
AND idc.Column_ID = col.Column_ID
'

IF @ExecuteStatus <> 3 SET @SQL9 = '
/* '''' clause seems sufficient to constrain at primary table level of tier, and causes syntax errors without text parsing content for local specific values. */
INSERT INTO ['+@SourceDBLocation+'].TMP.REG_0300_0401_Insert (LNK_T2_ID, LNK_T3_ID, LNK_T4_ID, REG_0300_ID, REG_0400_ID, REG_0401_ID, Server_ID, Database_ID, Schema_ID
, Object_ID, Object_Type, Column_Name, Column_Type, Column_Rank, Is_Identity, Is_Nullable, Is_Default_Collation, Is_Primary_Key, Column_Size, Column_Scale)
' + @SQL9


SET @SQL10 = '
SELECT 0, 0, 0, 0, 0, '+@ServerID+', DB_ID(), Object_ID, name, user_Type_ID, parameter_ID
, CASE WHEN precision = 0 AND scale = 0 THEN max_length
    ELSE precision END
, scale, 0, Is_Output, Is_cursor_ref, has_Default_Value, Is_xml_document, Is_readonly, CONVERT(NVARCHAR(max), default_Value), xml_collection_ID
FROM ['+@TargetDBLocation+'].sys.all_parameters as par
WHERE isnull(par.name,'''') <> ''''
'

IF @ExecuteStatus <> 3 SET @SQL10 = '
INSERT INTO ['+@SourceDBLocation+'].TMP.REG_0500_0501_Insert (LNK_T2_ID, LNK_T3_ID, REG_0300_ID, REG_0500_ID, REG_0501_ID, Server_ID, Database_ID, Object_ID, Parameter_Name
, Parameter_Type, rank, size, scale, Is_Input, Is_Output, Is_cursor_ref, has_Default_Value, Is_xml_document, Is_readonly, default_Value, xml_collection_ID)
' + @SQL10


SET @SQL11 = '
SELECT DISTINCT 0, 0, 0, '+@ServerID+', DB_ID(), '''+@TargetDBLocation+''', scm.Schema_ID, scm.name, obj.Object_ID, obj.name, obj.type, obj.Type_Desc
, smod.uses_ANSI_nulls, smod.uses_quoted_Identifier, smod.uses_Database_Collation, smod.Is_Schema_bound
, smod.Is_recompiled, smod.null_on_null_Input, smod.execute_as_principal_ID, obj.Create_Date, smod.definition
FROM ['+@TargetDBLocation+'].sys.schemas AS scm
JOIN ['+@TargetDBLocation+'].sys.all_objects AS obj
ON scm.Schema_ID = obj.Schema_ID
JOIN ['+@TargetDBLocation+'].sys.sql_modules AS smod
ON obj.Object_ID = smod.Object_ID
'

IF @ExecuteStatus <> 3 SET @SQL11 = '
INSERT INTO ['+@SourceDBLocation+'].TMP.REG_0600_Insert (LNK_T3_ID, REG_0300_ID, REG_0600_ID, Server_ID, Database_ID, Database_Name, Schema_ID, Schema_Name, Object_ID
, Object_Name, Object_Type, Type_Desc, uses_ANSI_nulls, uses_quoted_Identifier, uses_Database_Collation, Is_Schema_bound, Is_recompiled
, null_on_null_Input, execute_as_principal_ID, Create_Date, Code_Content)
' + @SQL11



IF @ExecuteStatus in (0,3)
BEGIN
	SELECT 'REG_0203_Insert' AS SQL_Object_Name, @SQL1
	SELECT 'REG_0204_0300_Insert' AS SQL_Object_Name, @SQL2
	SELECT 'REG_Index_Insert' AS SQL_Object_Name, @SQL3
	SELECT 'CTE_Object_References' AS SQL_Object_Name, @SQL4
	SELECT 'REG_Foreign_Key_Insert' AS SQL_Object_Name, @SQL5
	SELECT 'REG_Constraint_Insert' AS SQL_Object_Name, @SQL6
	SELECT 'REG_Trigger_Insert' AS SQL_Object_Name, @SQL7
	SELECT 'REG_0300_0300_Insert' AS SQL_Object_Name, @SQL8
	SELECT 'REG_0300_0401_Insert' AS SQL_Object_Name, @SQL9
	SELECT 'REG_0500_0501_Insert' AS SQL_Object_Name, @SQL10
	SELECT 'REG_0600_Insert' AS SQL_Object_Name, @SQL11
END


IF @ExecuteStatus in (1)
BEGIN
	PRINT @SQL1
	PRINT @SQL2
	PRINT @SQL3
	PRINT @SQL4
	PRINT @SQL5
	PRINT @SQL6
	PRINT @SQL7
	PRINT @SQL8
	PRINT @SQL9
	PRINT @SQL10
	PRINT @SQL11
END


IF @ExecuteStatus in (1,2)
BEGIN
	SET @SQL = cast(@SQL1 as nvarchar(max))+cast(@SQL2 as nvarchar(max))+cast(@SQL3 as nvarchar(max))
	+cast(@SQL4 as nvarchar(max))+cast(@SQL5 as nvarchar(max))+cast(@SQL6 as nvarchar(max))
	+cast(@SQL7 as nvarchar(max))+cast(@SQL8 as nvarchar(max))+cast(@SQL9 as nvarchar(max))
	+cast(@SQL10 as nvarchar(max))+cast(@SQL11 as nvarchar(max))
	SET @ExecuteSQL = @TargetDBLocation+'..sp_executesql' 
	EXEC @ExecuteSQL @SQL
END