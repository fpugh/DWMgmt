﻿CREATE TABLE [CAT].[REG_0100_Server_Registry] (
    [REG_0100_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [REG_Server_Name] NVARCHAR (256) NOT NULL,
    [REG_Product]     NVARCHAR (256) NOT NULL,
    [REG_Create_Date] DATETIME       CONSTRAINT [DF_REG_0100_CDate] DEFAULT (getdate()) NOT NULL,
    [REG_Monitored]   BIT            CONSTRAINT [DF_REG_0100_Monitored] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_REG_0100] PRIMARY KEY CLUSTERED ([REG_Server_Name] ASC, [REG_Product] ASC),
    CONSTRAINT [UQ_REG_0100_ID] UNIQUE NONCLUSTERED ([REG_0100_ID] ASC)
);
