

CREATE VIEW [LIB].[VI_2011_Grapheme_List]
AS
SELECT glp.Graph_ID
, glp.ASCII_Char1
, glp.ASCII_Char2
, abc1.Char_Val
+ abc2.Char_Val as Grapheme
, glp.Use_Class
FROM LIB.REG_Graphemes AS glp
JOIN LIB.REG_Alphabet AS abc1
ON abc1.ASCII_Char = glp.ASCII_Char1
AND abc1.Printable = 0
JOIN LIB.REG_Alphabet AS abc2
ON abc2.ASCII_Char = glp.ASCII_Char2
AND abc2.Printable = 0