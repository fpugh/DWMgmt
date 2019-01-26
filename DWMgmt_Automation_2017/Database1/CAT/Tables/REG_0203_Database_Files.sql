CREATE TABLE [CAT].[REG_0203_Database_Files] (
    [REG_0203_ID]       INT            IDENTITY (1, 1) NOT NULL,
    [REG_File_ID]       INT            NOT NULL,
    [REG_File_Type]     NVARCHAR (25)  NOT NULL,
    [REG_File_Name]     NVARCHAR (256) NOT NULL,
    [REG_File_Location] NVARCHAR (256) NOT NULL,
    [REG_File_Max_Size] BIGINT         CONSTRAINT [DF_REG_0203_Size] DEFAULT ((-1)) NOT NULL,
    [REG_File_Growth]   INT            CONSTRAINT [DF_REG_0203_Growth] DEFAULT ((10)) NOT NULL,
    [REG_Create_Date]   DATETIME       CONSTRAINT [DF_REG_0203_Post_Date] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_REG_0203] PRIMARY KEY CLUSTERED ([REG_File_ID] ASC, [REG_File_Name] ASC, [REG_File_Location] ASC),
    CONSTRAINT [UQ_REG_0203_KeyID] UNIQUE NONCLUSTERED ([REG_0203_ID] ASC)
);

