﻿CREATE TABLE [CAT].[REG_0600_Object_Code_Library] (
    [REG_0600_ID]      INT             IDENTITY (1, 1) NOT NULL,
    [REG_Code_Base]    NVARCHAR (25)   NOT NULL,
    [REG_Code_Content] NVARCHAR (4000) NOT NULL,
    [REG_Create_Date]  DATETIME        CONSTRAINT [DF_REG_0600_Post] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [UQ_REG_0600_ID] UNIQUE NONCLUSTERED ([REG_0600_ID] ASC)
);

