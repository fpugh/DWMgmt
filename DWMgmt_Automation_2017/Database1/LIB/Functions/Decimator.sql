

/* LIB.Decimator finds ten characters within the string
	content and returns a 10 character 'word' that helps
	uniquify the text as part of a VersionStamp algorithm. */

CREATE FUNCTION [LIB].[Decimator] (@String nvarchar(max), @Length bigint)
RETURNS NVARCHAR(9)

AS

BEGIN

DECLARE @Decimate INT
, @Position BIGINT = 1
, @Namex NVARCHAR(10) = ''

SELECT @Decimate = (@Length/9)

WHILE @Position <= @Length
BEGIN
	SELECT @Namex = @Namex + CASE WHEN PATINDEX('[A-Za-z0-9]', ISNULL(SUBSTRING(@String, @Position, 1),'')) > 0
		THEN SUBSTRING(@String, @Position, 1)
		ELSE '-' END 
	, @Position = @Position + @Decimate
END

RETURN @Namex

END