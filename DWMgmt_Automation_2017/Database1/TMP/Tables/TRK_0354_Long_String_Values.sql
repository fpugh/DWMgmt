CREATE TABLE [TMP].[TRK_0354_Long_String_Values] (
    [TBL_LSV_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [LNK_T4_ID]   INT            NULL,
    [Value_Count] INT            NULL,
    [String]      NVARCHAR (MAX) NULL,
    [Source_ID]   INT            NULL,
    [Batch_ID]    VARCHAR (10)   NULL
);

