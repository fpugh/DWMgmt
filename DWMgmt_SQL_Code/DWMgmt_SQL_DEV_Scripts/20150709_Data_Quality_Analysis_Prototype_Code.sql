
--SELECT *
--FROM TMP.TRK_0354_Value_Hash AS T1
--WHERE Schema_Bound_Name = 'dbo.V_RGCNSEQ4_GCNSEQNO_WITH_GCN'


SELECT REG_Object_Name, REG_Column_Name, Column_Value
, COUNT(DISTINCT Schema_Bound_Name) as Shared_Sources
, SUM(Value_Count) as Total_Frequency
/* Value Counts - Reveals the range of value utilization */
, MIN(Value_Count) as Minimal_Frequency -- This is probably a lookup source - cross reference the column density.
, AVG(Value_Count) as Average_Source_Frequency
, MAX(Value_Count) as Maximal_Frequency -- This is probably a fact table, or similarly denormalized source.
/* Density Counts - Reveals the data quality range for the value */
, MIN(TRK_Density) as Minimal_Density
, AVG(TRK_Density) as Average_Density
, MAX(TRK_Density) as Maximal_Density
FROM TMP.TRK_0354_Value_Hash AS T1
JOIN CAT.VI_0354_Object_Data_Profile AS T2
ON T2.LNK_T4_ID = T1.LNK_T4_ID
WHERE ISNULL(Column_Value,'') <> ''
AND TRK_Density > 0
--and REG_Object_Name = 'v_MDDB_Drug_Classification_Reference'
GROUP BY REG_Object_Name, REG_Column_Name, Column_Value
ORDER BY REG_COlumn_Name, Total_Frequency DESC





