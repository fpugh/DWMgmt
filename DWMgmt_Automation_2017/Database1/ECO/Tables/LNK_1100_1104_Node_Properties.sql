﻿CREATE TABLE [ECO].[LNK_1100_1104_Node_Properties] (
    [LNK_1100_1104_ID] INT      IDENTITY (1, 1) NOT NULL,
    [LNK_FK_1100_ID]   INT      NOT NULL,
    [LNK_FK_1102_ID]   INT      NOT NULL,
    [LNK_FK_1103_ID]   INT      NOT NULL,
    [LNK_FK_1104_ID]   INT      NOT NULL,
    [LNK_Rank]         INT      NOT NULL,
    [LNK_Post_Date]    DATETIME CONSTRAINT [DF_L1100_1104_Post] DEFAULT (getdate()) NULL,
    [LNK_Term_Date]    DATETIME CONSTRAINT [DF_L1100_1104_Term] DEFAULT ('12/31/2099') NOT NULL,
    CONSTRAINT [PK_LNK_1100_1104] PRIMARY KEY CLUSTERED ([LNK_FK_1100_ID] ASC, [LNK_FK_1102_ID] ASC, [LNK_FK_1103_ID] ASC, [LNK_FK_1104_ID] ASC, [LNK_Rank] ASC, [LNK_Term_Date] ASC),
    CONSTRAINT [FK_NP_LNK_1102] FOREIGN KEY ([LNK_FK_1102_ID]) REFERENCES [ECO].[REG_1102_XML_Nodes] ([REG_1102_ID]),
    CONSTRAINT [FK_NP_LNK_1103] FOREIGN KEY ([LNK_FK_1103_ID]) REFERENCES [ECO].[REG_1103_XML_Node_Properties] ([REG_1103_ID]),
    CONSTRAINT [UQ_L1100_1104_ID] UNIQUE NONCLUSTERED ([LNK_1100_1104_ID] ASC)
);
