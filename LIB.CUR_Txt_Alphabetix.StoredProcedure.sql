USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[CUR_Txt_Alphabetix]') AND type in (N'P', N'PC'))
DROP PROCEDURE [LIB].[CUR_Txt_Alphabetix]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[CUR_Txt_Alphabetix]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [LIB].[CUR_Txt_Alphabetix]

AS

/** Begin analysis of string map with alphabet and word analysis **/
SELECT t2.Collection_ID, t1.Source_ID, t1.ASCII_Char, t3.Char_Val, COUNT(t1.Char_Pos) as Use_Count
, CASE WHEN t1.ASCII_Char IN (0,1,9,10,11,12,13,28,29,30,31,129,143,144,157,160) THEN 1 ELSE 0 END AS  Printable
INTO #Alphabetix
FROM TMP.TXT_String_Map AS t1
JOIN TMP.TXT_Process_Hash AS t2
ON t2.Source_ID = t1.Source_ID
JOIN LIB.REG_Alphabet AS t3 WITH(NOLOCK)
ON t1.ASCII_Char = t3.ASCII_Char
GROUP BY t2.Collection_ID, t1.Source_ID, t1.ASCII_Char,t3.Char_Val


INSERT INTO LIB.HSH_Collection_Alphabet (Collection_ID, ASCII_Char, Use_Count)
SELECT Collection_ID, ASCII_Char, Use_Count
FROM #Alphabetix
' 
END
GO
