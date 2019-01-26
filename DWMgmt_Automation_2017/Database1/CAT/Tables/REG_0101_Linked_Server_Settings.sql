CREATE TABLE [CAT].[REG_0101_Linked_Server_Settings] (
    [REG_0101_ID]               INT           IDENTITY (1, 1) NOT NULL,
    [REG_Linked_Flag]           BIT           CONSTRAINT [DF_REG_0101_K2] DEFAULT ((0)) NOT NULL,
    [REG_Remote_Login_Flag]     BIT           CONSTRAINT [DF_REG_0101_K3] DEFAULT ((0)) NOT NULL,
    [REG_RPC_Out_Flag]          BIT           CONSTRAINT [DF_REG_0101_K4] DEFAULT ((0)) NOT NULL,
    [REG_Data_Access_Flag]      BIT           CONSTRAINT [DF_REG_0101_K5] DEFAULT ((0)) NOT NULL,
    [REG_Collation_Compatible]  BIT           CONSTRAINT [DF_REG_0101_K6] DEFAULT ((0)) NOT NULL,
    [REG_Remote_Collation_Flag] BIT           CONSTRAINT [DF_REG_0101_K7] DEFAULT ((0)) NOT NULL,
    [REG_Collation_Name]        NVARCHAR (65) CONSTRAINT [DF_REG_0101_K8] DEFAULT ('Database_Default') NOT NULL,
    [REG_Connection_TO]         INT           CONSTRAINT [DF_REG_0101_K9] DEFAULT ((0)) NOT NULL,
    [REG_Query_TO]              INT           CONSTRAINT [DF_REG_0101_K10] DEFAULT ((0)) NOT NULL,
    [REG_System_Flag]           BIT           CONSTRAINT [DF_REG_0101_K11] DEFAULT ((0)) NOT NULL,
    [REG_RPT_TPE_Flag]          BIT           CONSTRAINT [DF_REG_0101_K12] DEFAULT ((0)) NOT NULL,
    [REG_Create_Date]           DATETIME      CONSTRAINT [DF_REG_0101_CDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_REG_0101] PRIMARY KEY CLUSTERED ([REG_Linked_Flag] ASC, [REG_Remote_Login_Flag] ASC, [REG_RPC_Out_Flag] ASC, [REG_Data_Access_Flag] ASC, [REG_Collation_Compatible] ASC, [REG_Remote_Collation_Flag] ASC, [REG_Collation_Name] ASC, [REG_Connection_TO] ASC, [REG_Query_TO] ASC, [REG_System_Flag] ASC, [REG_RPT_TPE_Flag] ASC),
    CONSTRAINT [UQ_REG_0101_ID] UNIQUE NONCLUSTERED ([REG_0101_ID] ASC)
);

