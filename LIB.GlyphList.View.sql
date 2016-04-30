USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[GlyphList]'))
DROP VIEW [LIB].[GlyphList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[GlyphList]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [LIB].[GlyphList]
AS
SELECT glp.Glyph_ID, glp.ASCII_Char1, glp.ASCII_Char2, abc1.Char_Val+abc2.Char_Val as Glyph
FROM LIB.REG_Glyphs AS glp
JOIN LIB.REG_Alphabet AS abc1
ON abc1.ASCII_Char = glp.ASCII_Char1
AND abc1.Printable = 0
JOIN LIB.REG_Alphabet AS abc2
ON abc2.ASCII_Char = glp.ASCII_Char2
AND abc2.Printable = 0
' 
GO
