CREATE TABLE [CAT].[TRK_SSIS_Import_Audit] (
    [Execution_ID]    NVARCHAR (65)  NULL,
    [Target_Server]   NVARCHAR (256) NULL,
    [Target_Database] NVARCHAR (256) NULL,
    [Task_Name]       NVARCHAR (256) NULL,
    [Records]         INT            NULL,
    [Post_Date]       DATETIME       DEFAULT (getdate()) NOT NULL
);

