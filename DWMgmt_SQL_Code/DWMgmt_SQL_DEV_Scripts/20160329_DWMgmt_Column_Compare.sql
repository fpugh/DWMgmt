use DWMgmt
go



SELECT Map.REG_Server_Name, Map.Fully_Qualified_Name, Map.REG_Column_Name, Map.Column_Rank, Map.Column_Definition
FROM CAT.VI_0300_Full_Object_Map AS Map
JOIN (
	SELECT Fully_Qualified_Name
	FROM CAT.VI_0300_Full_Object_Map
	WHERE CHARINDEX('CAT.REG', Fully_Qualified_Name) > 0
	AND REG_Object_Type = 'U'
	GROUP BY Fully_Qualified_Name
	HAVING COUNT(DISTINCT REG_Server_Name) > 1
	) AS List
ON List.Fully_Qualified_Name = Map.Fully_Qualified_Name
ORDER BY Map.Fully_Qualified_Name, Map.REG_Server_Name, Map.Column_Rank



