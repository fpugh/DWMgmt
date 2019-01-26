


CREATE FUNCTION [LIB].[SplitTable] (@Delimiter nvarchar(15) = ' ', @ForceDelimit int = 0, @MaxLen int, @String nvarchar(4000), @SourceID int)
RETURNS table

AS

/* Splitter Notes and Usage
This function will take any string (@String) upto 8000 characters long and split into segments defined by the @MaxLen variable.
The @Delimiter variable is defaulted to ' ' <space> for natural language parsing, but can be used to split comma-separated lists.
@SourceID is any numeric anchor used to pin the results to a specific line from the source query.

Example - This splits the NARRATIVE line from the ORDER_NARRATIVE table in EPIC into <= 80 character lengths for the VDW LabNotes table specification.

    SELECT nar.ORDER_PROC_ID, crp.Chunk as DW_Result_Note
    , DENSE_RANK() OVER (PARTITION BY nar.ORDER_PROC_ID ORDER BY nar.LINE, crp.Line) Line
    INTO #OrderNarratives
    FROM [VDW_SourceData].dbo.ORDER_NARRATIVE as nar WITH(NOLOCK)
    CROSS APPLY dbo.Split(' ',80,NARRATIVE,ORDER_PROC_ID) as CRP
    WHERE LEN(nar.NARRATIVE) > 80        -- This is used to filter short results and speed up processing time!

The @Delimiter is used with PATINEX() so it can be a single character ',', or a short pattern such as '. ' or '[,.;:?!]'.
This makes it reusable for many different purposes.

It uses a Recursive CTE, so it will NOT successfully split strings with more than 100 sub-sections... a different approach would be appropriate in that case.

-4est 10/30/2017

Test/Execution Examples

-- I13.2, I50.20, N18.6
-- This is a very long string. It is longer than the limit so that free-text parsing can be tested. -- Breaks at the last '.' for some reason??
                        
declare @Delimiter varchar(15) = ','
, @MaxLen int = 20
, @String varchar(8000) = 'I13.2, I50.20, N18.6'
, @SourceID int = 1
, @ForceDelimit int = 1 -- 1 use each delimiter such as parsing a comma separated field, or 0 use the delimiter nearest the @MaxLen limit such as punctuation marks or space characters in natural language.


*/


RETURN (

    WITH splitter_cte AS (
        SELECT 1 as Line 
            , 1 as Pos

                -- If the string contains no delimiters, or the delimiter occurs after the @MaxLen limit, use the @MaxLen limit:
            , CASE WHEN PATINDEX('%'+@Delimiter+'%', @String + ' ') = 0 
                    OR PATINDEX('%'+@Delimiter+'%', @String + ' ') > @MaxLen 
                    THEN @MaxLen
                    
                -- If a delimiter is detected before the @MaxLen limit position, and @ForceDelimit is true, use the first occurence of the @Delimiter character
                WHEN @ForceDelimit = 1 
                    AND PATINDEX('%'+@Delimiter+'%', @String + ' ') > 0 
                    AND PATINDEX('%'+@Delimiter+'%', @String + ' ') < @MaxLen 
                    THEN PATINDEX('%'+@Delimiter+'%', @String + ' ') - 1 -- Includes the position of the delimiter which is not intended when @ForcedDelimiter flag is true.
                
                -- If a delimiter is detected before the @MaxLen limit position, and @ForceDelimit is false, use the last occurence of the @Delimiter character before the @MasLen limit.
                WHEN @ForceDelimit = 0
                    AND PATINDEX('%'+@Delimiter+'%', @String + ' ') > 0 
                    AND PATINDEX('%'+@Delimiter+'%', @String + ' ') < @MaxLen 
                    THEN @MaxLen - PATINDEX('%'+@Delimiter+'%', REVERSE(LEFT(@String + ' ', @MaxLen))) + 1
                
                END AS LastPos

        UNION ALL

        SELECT Line+1
        
            , CASE WHEN @ForceDelimit = 1 
                    AND PATINDEX('%'+@Delimiter+'%', SUBSTRING(@String + ' ', LastPos + 1, @MaxLen)) > 0
                    THEN LastPos + 2 -- When a Delimiter is specified, it should not be included in the split string chunk.
                    ELSE LastPos + 1 END AS Pos
            
                -- If the string is delimited and a delimiter is detected between the current position, and the @MaxLen, use the first instance of the delimiter
            , CASE WHEN @ForceDelimit = 1 
                    AND PATINDEX('%'+@Delimiter+'%', SUBSTRING(@String + ' ', LastPos + 2, @MaxLen)) > 0 
                    THEN LastPos + PATINDEX('%'+@Delimiter+'%', SUBSTRING(@String + ' ', LastPos + 2, @MaxLen))

                -- If the string is natural and a delimiter is detected between the mid-point of the current position, and the @MaxLen, use the last instance of the delimiter
                WHEN @ForceDelimit = 0 
                    AND PATINDEX('%'+@Delimiter+'%', SUBSTRING(@String + ' ', LastPos + 1, @MaxLen)) > 0
                    THEN LastPos + @MaxLen - PATINDEX('%'+@Delimiter+'%', REVERSE(SUBSTRING(@String + ' ', LastPos + 1, @MaxLen)))

                -- If a string is longer than the @MaxLen and no delimiter is found, use the @MaxLen to slice the string
                WHEN LEN(@String + ' ') - LastPos > @MaxLen 
                    AND PATINDEX('%'+@Delimiter+'%', SUBSTRING(@String + ' ', LastPos + 1, @MaxLen)) = 0 
                    THEN LastPos + @MaxLen + 1

                -- Otherwise use the use the @MaxLen to slice the string - there are no delimiters found within the allowed length
                    ELSE LEN(@String + ' ') END AS LastPos

            FROM splitter_cte
            WHERE 1=1 
            AND LastPos < LEN(@String + ' ') 
            )


    SELECT LTRIM(RTRIM(SUBSTRING(@String, Pos, LastPos-Pos+1))) as Chunk
    , Line
    , @SourceID as SourceID
    FROM splitter_cte
    WHERE 1=1
    


  )