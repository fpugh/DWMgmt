﻿CREATE TABLE [CAT].[REG_0400_Column_Registry] (
    [REG_0400_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [REG_Column_Name] NVARCHAR (256) NOT NULL,
    [REG_Column_Type] NVARCHAR (25)  NOT NULL,
    [REG_Create_Date] DATETIME       CONSTRAINT [DF_REG_0400_CDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_REG_0400] PRIMARY KEY CLUSTERED ([REG_Column_Name] ASC, [REG_Column_Type] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [UQ_REG_0400_ID] UNIQUE NONCLUSTERED ([REG_0400_ID] ASC)
);

