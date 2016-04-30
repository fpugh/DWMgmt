USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[unf_SplitString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [LIB].[unf_SplitString]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[unf_SplitString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [LIB].[unf_SplitString]
    (
     @List NVARCHAR(4000)
    ,@SplitOn NVARCHAR(5)
    )
RETURNS @RtnValue TABLE
    (
     Id INT IDENTITY(1, 1)
    ,Value NVARCHAR(4000)
    )
AS
    BEGIN
        WHILE ( CHARINDEX(@SplitOn, @List) > 0 )
            BEGIN 
                INSERT  INTO @RtnValue
                        ( value
                        )
                        SELECT
                            Value = LTRIM(RTRIM(SUBSTRING(@List, 1,
                                                          CHARINDEX(@SplitOn,
                                                              @List) - 1))) 
                SET @List = SUBSTRING(@List,
                                      CHARINDEX(@SplitOn, @List)
                                      + LEN(@SplitOn), LEN(@List))
            END 

        INSERT  INTO @RtnValue
                ( Value )
                SELECT
                    Value = LTRIM(RTRIM(@List))
        RETURN
    END
' 
END

GO
