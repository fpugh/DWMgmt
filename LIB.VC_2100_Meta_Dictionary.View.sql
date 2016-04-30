USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[VC_2100_Meta_Dictionary]'))
DROP VIEW [LIB].[VC_2100_Meta_Dictionary]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[VC_2100_Meta_Dictionary]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [LIB].[VC_2100_Meta_Dictionary]
AS
SELECT cox.Name as Collection_Name
, rsd.REG_Schema_Name+''.''+ror.REG_Object_Name+''.''+rcr.REG_Column_Name as Source_Object
, lex.Column_ID
, dix.Word
, Global_Use_Count
, SUM(lex.Use_Count) as Collection_Use_Count
, DATEDIFF("day", MIN(dix.Post_Date), GETDATE()) as Word_Age_Days
, DATEDIFF("day", MIN(cox.Post_Date), GETDATE()) as Collection_Age_Days
FROM LIB.HSH_Collection_Lexicon AS lex WITH(NOLOCK)
JOIN LIB.REG_Dictionary AS dix WITH(NOLOCK)
ON dix.Word_ID = lex.Word_ID
JOIN LIB.REG_Collections AS cox WITH(NOLOCK)
ON cox.Collection_ID = lex.Collection_ID
LEFT JOIN CAT.LNK_0300_0400_Object_Column_Collection AS occ WITH(NOLOCK)
ON lex.Column_ID = occ.LNK_T4_ID
LEFT JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb WITH(NOLOCK)
ON lsb.LNK_T3_ID = occ.LNK_FK_T3_ID
LEFT JOIN CAT.REG_0204_Database_Schemas AS rsd WITH(NOLOCK)
ON rsd.REG_0204_ID = lsb.LNK_FK_0204_ID
LEFT JOIN CAT.REG_0300_Object_registry AS ror WITH(NOLOCK)
ON ror.REG_0300_ID = lsb.LNK_FK_0300_ID
LEFT JOIN CAT.REG_0400_Column_registry AS rcr WITH(NOLOCK)
ON rcr.REG_0400_ID = occ.LNK_FK_0400_ID
CROSS APPLY (
	SELECT Word, SUM(Use_Count) as Global_Use_Count
	FROM LIB.HSH_Collection_Lexicon AS lex WITH(NOLOCK)
	JOIN LIB.REG_Dictionary AS dix WITH(NOLOCK)
	ON dix.Word_ID = lex.Word_ID
	GROUP BY Word
	) AS guc
WHERE guc.Word = dix.Word
GROUP BY cox.Name, dix.Word, Global_Use_Count, lex.Column_ID
, rsd.REG_Schema_Name+''.''+ror.REG_Object_Name+''.''+rcr.REG_Column_Name

' 
GO
