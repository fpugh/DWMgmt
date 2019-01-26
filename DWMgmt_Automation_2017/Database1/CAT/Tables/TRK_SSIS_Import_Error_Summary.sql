CREATE TABLE [CAT].[TRK_SSIS_Import_Error_Summary] (
    [Error_Code]          INT            NULL,
    [Target_Server]       NVARCHAR (256) NULL,
    [Target_Database]     NVARCHAR (256) NULL,
    [Min_Error_Post_Date] DATETIME       NULL,
    [Max_Error_Post_Date] DATETIME       NULL,
    [Error_Instances]     INT            NULL,
    [Error_Records]       INT            NULL,
    [Post_Date]           DATETIME       NOT NULL
);

