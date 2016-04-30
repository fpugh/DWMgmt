USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[VI_2111_Collection_Alphabet]'))
DROP VIEW [LIB].[VI_2111_Collection_Alphabet]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[VI_2111_Collection_Alphabet]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [LIB].[VI_2111_Collection_Alphabet]
AS
SELECT DENSE_Rank() OVER(ORDER BY R2.Name, SUM(T1.Use_Count) DESC, R1.ASCII_Char) as VID
, R2.Name, R1.Char_Val, R1.ASCII_Char, SUM(T1.Use_Count) AS Use_Count
FROM LIB.HSH_Collection_Alphabet AS T1 WITH(NOLOCK)
JOIN LIB.REG_Alphabet AS R1 WITH(NOLOCK)
ON R1.ASCII_Char = T1.ASCII_Char
JOIN LIB.REG_Collections AS R2 WITH(NOLOCK)
ON R2.Collection_ID = T1.Collection_ID
GROUP BY R2.Name, R1.Char_Val, R1.ASCII_Char
' 
GO
