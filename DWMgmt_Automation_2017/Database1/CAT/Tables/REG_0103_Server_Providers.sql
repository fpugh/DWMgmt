CREATE TABLE [CAT].[REG_0103_Server_Providers] (
    [REG_0103_ID]         INT             IDENTITY (1, 1) NOT NULL,
    [REG_Provider]        NVARCHAR (256)  NOT NULL,
    [REG_Data_Source]     NVARCHAR (256)  NOT NULL,
    [REG_Provider_String] NVARCHAR (2000) NOT NULL,
    [REG_Catalog]         NVARCHAR (256)  NOT NULL,
    [REG_Create_Date]     DATETIME        CONSTRAINT [DF_REG_0103_CDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_REG_0103] PRIMARY KEY CLUSTERED ([REG_Provider] ASC, [REG_Data_Source] ASC, [REG_Provider_String] ASC, [REG_Catalog] ASC),
    CONSTRAINT [UQ_REG_0103_ID] UNIQUE NONCLUSTERED ([REG_0103_ID] ASC)
);

