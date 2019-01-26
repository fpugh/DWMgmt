CREATE TABLE [CAT].[REG_0200_Database_Registry] (
    [REG_0200_ID]        INT            IDENTITY (1, 1) NOT NULL,
    [REG_Database_Name]  NVARCHAR (256) NOT NULL,
    [REG_Compatibility]  TINYINT        NOT NULL,
    [REG_Collation]      NVARCHAR (65)  CONSTRAINT [DF_REG_0200_Collate] DEFAULT ('database default') NOT NULL,
    [REG_Recovery_Model] NVARCHAR (65)  CONSTRAINT [DF_REG_0200_Recovery] DEFAULT ('simple') NOT NULL,
    [REG_Create_Date]    DATETIME       CONSTRAINT [DF_REG_0200_CDate] DEFAULT (getdate()) NOT NULL,
    [REG_Managed]        BIT            CONSTRAINT [DF_REG_0200_Managed] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_REG_0200] PRIMARY KEY CLUSTERED ([REG_Database_Name] ASC, [REG_Compatibility] ASC, [REG_Collation] ASC, [REG_Recovery_Model] ASC),
    CONSTRAINT [UQ_REG_0200_KeyID] UNIQUE NONCLUSTERED ([REG_0200_ID] ASC)
);

