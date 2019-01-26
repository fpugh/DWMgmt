

CREATE FUNCTION [LIB].[Levenshtein](@str_1 nvarchar(4000), @str_2 nvarchar(4000))
RETURNS int
AS

---------------------------------------------------------------------------------------
--- This function produces a Levenshtein distance for a pair of	strings presented	---
--- presented either as values or columns. This does not depend on the constraints	---
--- of dynamic SQL variable sizes. Both strings can be up to 4000 characters in 	---
--- length.																			---
---																					---
---	Vladimir Levenshtein (b. 1935) is a Russian Information Theory scientist. This	---
--- is the replication of one of his methods of testing encoding and decoding		---
--- validation.																		---
---																					---
---	Encoded 20120929 : 4est Pugh													---
---------------------------------------------------------------------------------------


BEGIN
 DECLARE	@str_1_len int
		,	@str_2_len int
		,	@str_1_itr int
		,	@str_2_itr int
		,	@str_1_char nchar
		,	@Levenshtein int
		,	@LD_temp int
		,	@cv0 varbinary(8000)
		,	@cv1 varbinary(8000)

SELECT  @str_1_len = LEN(@str_1)
	,	@str_2_len = LEN(@str_2)
	,	@cv1 = 0x0000
	,	@str_2_itr = 1
	,	@str_1_itr = 1
	,	@Levenshtein = 0


WHILE @str_2_itr <= @str_2_len

SELECT	@cv1 = @cv1 + CAST(@str_2_itr AS binary(2))
	,	@str_2_itr = @str_2_itr + 1

WHILE @str_1_itr <= @str_1_len
BEGIN
	SELECT	@str_1_char = SUBSTRING(@str_1, @str_1_itr, 1)
		,   @Levenshtein = @str_1_itr
		,   @cv0 = CAST(@str_1_itr AS binary(2))
		,   @str_2_itr = 1

	WHILE @str_2_itr <= @str_2_len
	BEGIN
		SET @Levenshtein = @Levenshtein + 1
		SET @LD_temp = CAST(SUBSTRING(@cv1, @str_2_itr+@str_2_itr-1, 2) AS int) +
		CASE WHEN @str_1_char = SUBSTRING(@str_2, @str_2_itr, 1) THEN 0 ELSE 1 END
		IF @Levenshtein > @LD_temp SET @Levenshtein = @LD_temp
		SET @LD_temp = CAST(SUBSTRING(@cv1, @str_2_itr+@str_2_itr+1, 2) AS int)+1
		IF @Levenshtein > @LD_temp SET @Levenshtein = @LD_temp
		SELECT @cv0 = @cv0 + CAST(@Levenshtein AS binary(2)), @str_2_itr = @str_2_itr + 1
	END

SELECT @cv1 = @cv0, @str_1_itr = @str_1_itr + 1
END

RETURN @Levenshtein
END