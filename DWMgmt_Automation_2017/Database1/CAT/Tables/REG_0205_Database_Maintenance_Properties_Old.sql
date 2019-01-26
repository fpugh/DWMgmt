CREATE TABLE [CAT].[REG_0205_Database_Maintenance_Properties_Old] (
    [REG_0205_ID]       INT             IDENTITY (1, 1) NOT NULL,
    [REG_Task_Type]     NVARCHAR (256)  CONSTRAINT [DF_REG_0205_Type] DEFAULT ('Maintenance') NOT NULL,
    [REG_Task_Group]    NVARCHAR (256)  CONSTRAINT [DF_REG_0205_Group] DEFAULT ('Unspecified') NOT NULL,
    [REG_Task_Name]     NVARCHAR (256)  NOT NULL,
    [REG_Task_Proc]     NVARCHAR (256)  NOT NULL,
    [REG_Task_Desc]     NVARCHAR (256)  NOT NULL,
    [REG_Create_Date]   DATETIME        CONSTRAINT [DF_REG_0205_CDate] DEFAULT (getdate()) NOT NULL,
    [REG_Exec_Template] NVARCHAR (4000) NULL,
    CONSTRAINT [PK_REG_0205] PRIMARY KEY CLUSTERED ([REG_Task_Type] ASC, [REG_Task_Group] ASC, [REG_Task_Name] ASC, [REG_Task_Proc] ASC),
    CONSTRAINT [UQ_REG_0205_ID] UNIQUE NONCLUSTERED ([REG_0205_ID] ASC)
);

