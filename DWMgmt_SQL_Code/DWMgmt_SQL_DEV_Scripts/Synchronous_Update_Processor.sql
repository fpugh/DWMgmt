
--SELECT tsm.Source_ID, max(tsm.Char_Pos) as Max_Char_Pos
--FROM TMP.TXT_String_Map AS tsm WITH(NOLOCK)
--JOIN LIB.REG_Alphabet AS alp WITH(NOLOCK)
--ON alp.ASCII_Char = tsm.ASCII_Char
--LEFT JOIN (
--	SELECT hcr.Collection_ID, hcd.Source_ID, hcr.Rule_Value
--	FROM LIB.HSH_Collection_Rules AS hcr WITH(NOLOCK)
--	JOIN LIB.VI_2119_Simple_Collection_List AS scl WITH(NOLOCK)
--	ON CAST(hcr.Collection_ID AS VARCHAR) = RIGHT(scl.Collection_Key, LEN(hcr.Collection_ID))
--	AND scl.Link_Type = 1
--	AND GETDATE() BETWEEN hcr.Post_Date AND hcr.Term_Date
--	JOIN LIB.HSH_Collection_Documents AS hcd WITH(NOLOCK)
--	ON hcd.Collection_ID = hcr.Collection_ID
--	) AS hcr
--ON hcr.Source_ID = tsm.Source_ID
--GROUP BY tsm.Source_ID




 -- drop table ##WordBase

BEGIN TRANSACTION

SELECT tsm.Source_ID
, ISNULL(hcr.Rule_Value, '')+'44,34,32,13,10' as Delimiter_Char
, CAST(tsm.ASCII_Char AS VARCHAR(3)) as ASCII_Char
, tsm.Char_Pos, alp.Char_Val
, CAST(NULL AS NVARCHAR(4000)) as Word
INTO ##WordBase
--select tsm.Source_ID, max(char_pos) as max_char_pos
FROM TMP.TXT_String_Map AS tsm WITH(NOLOCK)
JOIN LIB.REG_Alphabet AS alp WITH(NOLOCK)
ON alp.ASCII_Char = tsm.ASCII_Char
LEFT JOIN (
	SELECT hcr.Collection_ID, hcd.Source_ID, hcr.Rule_Value
	FROM LIB.HSH_Collection_Rules AS hcr WITH(NOLOCK)
	JOIN LIB.VI_2119_Simple_Collection_List AS scl WITH(NOLOCK)
	ON CAST(hcr.Collection_ID AS VARCHAR) = RIGHT(scl.Collection_Key, LEN(hcr.Collection_ID))
	AND scl.Link_Type = 1
	AND GETDATE() BETWEEN hcr.Post_Date AND hcr.Term_Date
	JOIN LIB.HSH_Collection_Documents AS hcd WITH(NOLOCK)
	ON hcd.Collection_ID = hcr.Collection_ID
	) AS hcr
ON hcr.Source_ID = tsm.Source_ID
WHERE 1=1
--AND tsm.Source_ID IN (19942) -- 1834542
--AND tsm.Source_ID IN (21558) -- 540
--AND tsm.Source_ID IN (21558,21371) -- 540+1048
--AND tsm.Source_ID IN (21558,21371,21346) -- 540+1048+10090
--AND tsm.Source_ID IN (19949) -- 236309
--AND tsm.Source_ID IN (21471) -- 322538
--AND tsm.Source_ID IN (19949,21471) -- 236309+322538
AND tsm.Source_ID IN (19949,21471,21558,21371,21346) -- 540+1048+10090+236309+322538
--AND tsm.Source_ID IN (19942,21346) -- 322538+1834542 - NO
--AND tsm.Source_ID IN (21371,19942) -- 236309+1834542 - NO
--AND tsm.Source_ID IN (19949,21471,21558,19942) -- 540+1048+10090+1834542 - NO
--AND tsm.Source_ID IN (19949,21471,19942) -- 540+1048+1834542 - NO
--AND tsm.Source_ID IN (19949,19942) -- 540+1834542 - NO

CREATE CLUSTERED INDEX tdx_ci_WordBase_K1_K4 ON ##WordBase (Source_ID, Char_Pos)

--select *
--from ##WordBase
--order by Source_ID, Char_Pos

COMMIT TRANSACTION

; SET NOCOUNT ON

BEGIN TRANSACTION

	
DECLARE @Word NVARCHAR(4000) = ''
, @SourceID BIGINT

UPDATE t1 SET 
	@Word = t1.Word = CASE WHEN @SourceID = t1.Source_ID AND CHARINDEX(t1.ASCII_Char, t1.Delimiter_Char) = 0 THEN @Word+t1.Char_Val
	ELSE @Word END
	, @Word = CASE WHEN CHARINDEX(t1.ASCII_Char, t1.Delimiter_Char) > 0 THEN '' ELSE @Word END
	, @SourceID = t1.Source_ID
FROM ##WordBase AS t1
--WHERE Char_Pos < 1800000
OPTION(MAXDOP 1)

SET NOCOUNT OFF

COMMIT TRANSACTION




WITH WordBase (Source_ID, ASCII_Char, Char_Val, Char_Pos, Char_Rank)
AS (
	SELECT Source_ID, ASCII_Char, Char_Val, Char_Pos
	, DENSE_RANK() OVER(PARTITION BY Source_ID, ASCII_CHAR ORDER BY Char_Pos) as Char_Rank
	FROM ##WordBase
	WHERE 1=1
	--AND ISNULL(Word,'') != ''
	AND CHARINDEX(ASCII_Char, Delimiter_Char) > 0
	)


--SELECT dom.Source_ID, dom.ASCII_Char, dom.Char_Val, dom.Width
----, MIN(Width) as Min_Width
----, AVG(Width) as Avg_Width
----, MAX(Width) as Max_Width
--FROM (
	SELECT t1.Source_ID, t1.ASCII_Char, t1.Char_Val, t1.Char_Rank, t1.Char_Pos
	, t2.Char_Pos - t1.Char_Pos as Width
	FROM WordBase AS t1 WITH(NOLOCK)
	LEFT JOIN WordBase AS t2 WITH(NOLOCK)
	ON t2.Source_ID = t1.Source_ID
	AND t2.ASCII_Char = t1.ASCII_Char
	AND t2.Char_Rank = t1.Char_Rank + 1
	--) AS dom
--GROUP BY dom.Source_ID, dom.ASCII_Char, dom.Char_Val
order by Width


SELECT Word, COUNT(*) as Instances
FROM ##WordBase
WHERE 1=1
AND ISNULL(Word,'') != ''
AND CHARINDEX(ASCII_Char, Delimiter_Char) > 0
GROUP BY Word
ORDER BY Instances DESC


SELECT frm.ASCII_Char, COUNT(*) as Instances
FROM ##WordBase as frm
WHERE 1=1
--AND ISNULL(Word,'') != ''
AND CHARINDEX(frm.ASCII_Char, frm.Delimiter_Char) > 0
GROUP BY frm.ASCII_Char
ORDER BY Instances DESC


select top 100 *
from ##WordBase
WHERE 1=1
--AND ISNULL(Word,'') != ''
AND CHARINDEX(ASCII_Char, Delimiter_Char) > 0
order by Source_ID, Char_Pos




-- select 197509/32917.00 6 columns per table??


select map.Source_ID, map.Char_Pos, alp.ASCII_Char, alp.Char_Val, alp.Class_VCNS, alp.Printable
from TMP.TXT_String_Map AS map
join LIB.REG_Alphabet AS alp
on map.ASCII_Char = alp.ASCII_Char
join ##WordBase as tmp
on tmp.Source_ID = map.Source_ID


select map.Source_ID, alp.ASCII_Char, alp.Char_Val, alp.Class_VCNS, alp.Printable, count_big(distinct map.Char_Pos) as Utilization
from TMP.TXT_String_Map AS map
join LIB.REG_Alphabet AS alp
on alp.ASCII_Char = map.ASCII_Char
join ##WordBase as tmp
on tmp.Source_ID = map.Source_ID
group by map.Source_ID, alp.ASCII_Char, alp.Char_Val, alp.Class_VCNS, alp.Printable
order by alp.Printable, Utilization desc









