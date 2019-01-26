

CREATE FUNCTION [LIB].[Document_Directory_Structure]
(@Path NVARCHAR(4000))

RETURNS @RtnValue TABLE (Id INT IDENTITY(1, 1),Value NVARCHAR(4000))

AS

BEGIN
WHILE (CHARINDEX('\', @Path) > 0)

	BEGIN 
	INSERT INTO @RtnValue(value)
	
	SELECT Value = LTRIM(RTRIM(SUBSTRING(@Path, 1, CHARINDEX('\', @Path)))) 
    SET @Path = SUBSTRING(@Path, CHARINDEX('\', @Path) + LEN('\'), LEN(@Path))

END 

	INSERT INTO @RtnValue (Value)
	SELECT Value = LTRIM(RTRIM(@Path))
	WHERE RIGHT(@Path,1)= '\'

RETURN
END