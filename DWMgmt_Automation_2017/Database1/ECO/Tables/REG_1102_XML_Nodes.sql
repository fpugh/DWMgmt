﻿CREATE TABLE [ECO].[REG_1102_XML_Nodes] (
    [REG_1102_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [REG_Node_Name]   NVARCHAR (256) NOT NULL,
    [REG_Create_Date] DATETIME       CONSTRAINT [DF_R1102_CDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_REG_1102] PRIMARY KEY CLUSTERED ([REG_Node_Name] ASC),
    CONSTRAINT [UQ_R1102_ID] UNIQUE NONCLUSTERED ([REG_1102_ID] ASC)
);
