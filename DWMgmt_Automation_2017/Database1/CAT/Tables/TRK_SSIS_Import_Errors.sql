CREATE TABLE [CAT].[TRK_SSIS_Import_Errors] (
    [Post_Date]         DATETIME         CONSTRAINT [DF_LogErrors_Post] DEFAULT (getdate()) NOT NULL,
    [Execution_ID]      UNIQUEIDENTIFIER NOT NULL,
    [Target_Server]     NVARCHAR (256)   NULL,
    [Target_Database]   NVARCHAR (256)   NULL,
    [Task_Name]         NVARCHAR (256)   NULL,
    [Error_Code]        INT              NULL,
    [Error_Description] NVARCHAR (MAX)   NULL,
    [Records]           INT              NULL
);

