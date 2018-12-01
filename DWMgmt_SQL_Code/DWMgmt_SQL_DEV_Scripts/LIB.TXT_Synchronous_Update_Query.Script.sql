
DECLARE @TargetColumn NVARCHAR(4000)
, @AnchorColumn1 NVARCHAR(4000) = ''
, @AnchorColumn2 NVARCHAR(4000) = ''
, @AnchorColumn3 NVARCHAR(4000) = ''
, @TargetTable NVARCHAR(256)
, @KeyColumn NVARCHAR(65) = 'UpdtKeyCol'
, @Delimeter NVARCHAR(8) = ', '
, @KeepTotals NVARCHAR(1) = 1
, @SQL NVARCHAR(MAX)


/** Apply the following examples and generate script or supply your own **/
	
	--select @TargetColumn = 'String'
	--, @TargetTable = 'TMP.TRK_0354_Long_String_Values'
	--, @KeyColumn = 'TBL_LSV_ID'
	--, @AnchorColumn1 = 'LNK_T4_ID'
	--, @Delimeter = '|'


SET @SQL = '
; CREATE CLUSTERED INDEX pk_updt_K0 ON '+@TargetTable+' ('+@KeyColumn+')

SET NOCOUNT ON

DECLARE @UpdateValue nvarchar(MAX)
, @Anchor1 nvarchar(4000)
, @Anchor2 nvarchar(4000)
, @Anchor3 nvarchar(4000)

UPDATE updt SET 
	@UpdateValue = '+@TargetColumn+' =			
	CASE WHEN '+@AnchorColumn1+' = @Anchor1'
+ CHAR(9) + CASE WHEN ISNULL(@AnchorColumn2,'') = '' THEN '' ELSE 'AND '+@AnchorColumn2+' = @Anchor2' END
+ CHAR(9) + CASE WHEN ISNULL(@AnchorColumn3,'') = '' THEN '' ELSE 'AND '+@AnchorColumn3+' = @Anchor3' END
+ CHAR(13) + 'AND @UpdateValue <> '+@TargetColumn+'
	THEN @UpdateValue + '''+@Delimeter+'''+ '+@TargetColumn+'
	ELSE '+@TargetColumn+' END
	, @Anchor1 = '+@AnchorColumn1+''
+ CASE WHEN ISNULL(@AnchorColumn2,'') = '' THEN '' ELSE CHAR(9) + ', @Anchor2 = '+@AnchorColumn2+'' END
+ CASE WHEN ISNULL(@AnchorColumn3,'') = '' THEN '' ELSE CHAR(9) + ', @Anchor3 = '+@AnchorColumn3+'' END
+ CHAR(13) + 'FROM '+@TargetTable+' AS updt
OPTION (MAXDOP 1)

SET NOCOUNT OFF

IF '+@KeepTotals+' = 1
BEGIN
	DELETE src
	FROM '+@TargetTable+' AS SRC
	LEFT JOIN (
		SELECT '+@AnchorColumn1+''
+ CHAR(9) + CHAR(9) + CASE WHEN ISNULL(@AnchorColumn2,'') = '' THEN '' ELSE ', '+@AnchorColumn2+'' END
+ CHAR(9) + CHAR(9) + CASE WHEN ISNULL(@AnchorColumn3,'') = '' THEN '' ELSE ', '+@AnchorColumn3+'' END
+ CHAR(13)+'		, MAX('+@KeyColumn+') as UpdtKeyValue
		FROM '+@TargetTable+'
		GROUP BY '+@AnchorColumn1+''
+ CHAR(9) + CHAR(9) + CASE WHEN ISNULL(@AnchorColumn2,'') = '' THEN '' ELSE ', '+@AnchorColumn2+'' END
+ CHAR(9) + CHAR(9) + CASE WHEN ISNULL(@AnchorColumn3,'') = '' THEN '' ELSE ', '+@AnchorColumn3+'' END
+ CHAR(13) + CHAR(9) + ') AS SUB
	ON 
	sub.'+@AnchorColumn1+' = src.'+@AnchorColumn1+''
+ CASE WHEN ISNULL(@AnchorColumn2,'') = '' THEN '' ELSE CHAR(9) + CHAR(9) + 'AND sub.'+@AnchorColumn2+' = src.'+@AnchorColumn2+'' END
+ CASE WHEN ISNULL(@AnchorColumn3,'') = '' THEN '' ELSE CHAR(9) + CHAR(9) + 'AND sub.'+@AnchorColumn3+' = src.'+@AnchorColumn2+'' END
+'	AND sub.UpdtKeyValue = src.'+@KeyColumn+'
	WHERE sub.UpdTKeyValue IS NULL
END

DROP INDEX pk_updt_K0 ON '+@TargetTable+'
'

PRINT @SQL


