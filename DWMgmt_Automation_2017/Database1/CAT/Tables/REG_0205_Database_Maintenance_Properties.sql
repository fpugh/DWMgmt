CREATE TABLE [CAT].[REG_0205_Database_Maintenance_Properties] (
    [REG_0205_ID]       INT             NOT NULL,
    [REG_Task_Type]     NVARCHAR (256)  NOT NULL,
    [REG_Task_Group]    NVARCHAR (256)  NOT NULL,
    [REG_Task_Name]     NVARCHAR (256)  NOT NULL,
    [REG_Task_Proc]     NVARCHAR (256)  NOT NULL,
    [REG_Task_Desc]     NVARCHAR (256)  NOT NULL,
    [REG_Create_Date]   SMALLDATETIME   NOT NULL,
    [REG_Exec_Template] NVARCHAR (4000) NULL
);

