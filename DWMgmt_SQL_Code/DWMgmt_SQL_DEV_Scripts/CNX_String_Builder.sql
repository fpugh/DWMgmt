

SELECT 'CNX_OLEDB_'+REPLACE(vw.REG_Server_Name,'\','_')+'_'+vw.REG_Database_Name as CNX_Name
, 'CNX_OLEDB_'+vw.REG_Server_Name+'_'+vw.REG_Database_Name as CNX_Name_Unrefined
, 'Server='+vw.REG_Server_Name+'; Database='+vw.REG_Database_Name+';' as CNX_String
, vw.*
FROM DWMgmt.CAT.VI_0100_Server_Database_Reference AS vw
WHERE LNK_T2_ID > 0
AND vw.REG_Database_Name IN ('DWMgmt','master')