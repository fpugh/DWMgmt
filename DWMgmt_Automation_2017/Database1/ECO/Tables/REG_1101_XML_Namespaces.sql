﻿CREATE TABLE [ECO].[REG_1101_XML_Namespaces] (
    [REG_1101_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [REG_Namespace]   NVARCHAR (256) NOT NULL,
    [REG_NS_Link]     NVARCHAR (256) NOT NULL,
    [REG_Create_Date] DATETIME       CONSTRAINT [DF_R1101_CDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_REG_1101] PRIMARY KEY CLUSTERED ([REG_Namespace] ASC, [REG_NS_Link] ASC),
    CONSTRAINT [UQ_R1101_ID] UNIQUE NONCLUSTERED ([REG_1101_ID] ASC)
);

