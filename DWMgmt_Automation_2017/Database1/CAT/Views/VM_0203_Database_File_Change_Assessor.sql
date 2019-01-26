

CREATE VIEW [CAT].[VM_0203_Database_File_Change_Assessor]
AS
SELECT t2p.LNK_FK_T2_ID
, rsr.REG_Server_Name
, rdr.REG_Database_Name
, t2p.LNK_Post_Date 
, t2p.LNK_Term_Date
, MIN(TRK_Growth_Factor) as MIN_Growth_Factor
, AVG(TRK_Growth_Factor) as AVG_Growth_Factor
, MAX(TRK_Growth_Factor) as MAX_Growth_Factor
, COUNT(DISTINCT TRK_Growth_Factor) as CDE_Growth_Factor
, MIN(TRK_File_Size) as MIN_File_Size
, AVG(TRK_File_Size) as AVG_File_Size
, MAX(TRK_File_Size) as MAX_File_Size
, COUNT(DISTINCT TRK_File_Size) as CDE_File_Size
, MIN(TRK_Schema_Count) as MIN_Schema_Count
, AVG(TRK_Schema_Count) as AVG_Schema_Count
, MAX(TRK_Schema_Count) as MAX_Schema_Count
, COUNT(DISTINCT TRK_Schema_Count) as CDE_Schema_Count
, MIN(TRK_Object_Count) as MIN_Object_Count
, AVG(TRK_Object_Count) as AVG_Object_Count
, MAX(TRK_Object_Count) as MAX_Object_Count
, COUNT(DISTINCT TRK_Object_Count) as CDE_Object_Count
, MIN(TRK_Post_Date) as MIN_Post_Date
, MAX(TRK_Post_Date) as MAX_Post_Date
, DATEDIFF(SS, MIN(TRK_Post_Date), MAX(TRK_Post_Date)) as AGE_Post_Date
, COUNT(*) as TRK_Records
FROM CAT.TRK_0203_Database_File_Changes AS dbf WITH(NOLOCK)
JOIN CAT.LNK_Tier2_Peers AS t2p WITH(NOLOCK)
ON dbf.TRK_FK_0203_ID = t2p.LNK_FK_0203_ID
AND dbf.TRK_Post_Date BETWEEN t2p.LNK_Post_Date AND t2p.LNK_Term_Date
JOIN CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
ON t2p.LNK_FK_T2_ID = lsd.LNK_T2_ID
JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
ON lsd.LNK_FK_0100_ID = rsr.REG_0100_ID
JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
ON lsd.LNK_FK_0200_ID = rdr.REG_0200_ID
GROUP BY t2p.LNK_FK_T2_ID, rsr.REG_Server_Name
, rdr.REG_Database_Name, t2p.LNK_Post_Date , t2p.LNK_Term_Date