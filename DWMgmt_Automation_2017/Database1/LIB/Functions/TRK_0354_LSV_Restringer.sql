CREATE FUNCTION LIB.TRK_0354_LSV_Restringer (@LNK_T4_ID INT)
RETURNS VARCHAR(MAX)
AS
BEGIN 
	DECLARE @String VARCHAR(MAX) = ''

	SELECT @String = CASE WHEN @String = '' THEN [String] ELSE @String + COALESCE('|' + [String], '') END
	FROM [DWMgmt].[TMP].[TRK_0354_Long_String_Values]
	WHERE LNK_T4_ID = @LNK_T4_ID

	RETURN (@String)
END