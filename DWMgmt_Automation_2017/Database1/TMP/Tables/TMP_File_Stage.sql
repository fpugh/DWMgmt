CREATE TABLE [TMP].[TMP_File_Stage] (
    [File_ID]       INT             IDENTITY (1, 1) NOT NULL,
    [File_Name]     NVARCHAR (256)  NULL,
    [File_Type]     NVARCHAR (256)  NULL,
    [File_Size]     NVARCHAR (256)  NULL,
    [File_Created]  NVARCHAR (256)  NULL,
    [File_Modified] NVARCHAR (256)  NULL,
    [IsReadOnly]    NVARCHAR (256)  NULL,
    [File_Path]     NVARCHAR (2000) NULL,
    [Encoding]      NVARCHAR (256)  NULL
);

