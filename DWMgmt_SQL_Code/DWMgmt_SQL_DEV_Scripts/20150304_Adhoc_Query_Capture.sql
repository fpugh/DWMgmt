
/* This is a direct method to attach code to query plans,
	however produces far too much volume, and too slowly.
	Perhaps can adapt for asynchronous query using freetext
	methods??
*/


WITH HandleBars (plan_handle, use_counts, objtype, text)
AS (
	SELECT t1.plan_handle, t1.usecounts, t1.objtype, t2.text
	FROM sys.dm_exec_cached_plans as t1
	CROSS APPLY sys.dm_exec_sql_text (plan_handle) as t2
	)

SELECT *
FROM CAT.vi_0360_Object_Code_Reference as ocr
CROSS APPLY HandleBars as crap
WHERE ocr.reg_Object_Type NOT IN ('C','D')
AND ocr.reg_code_content <> ''
AND PATINDEX('%'+ocr.reg_code_content+'%', crap.text) > 0
ORDER BY 1 DESC, 2,3