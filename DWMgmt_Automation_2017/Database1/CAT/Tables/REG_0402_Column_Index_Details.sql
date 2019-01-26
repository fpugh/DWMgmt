CREATE TABLE [CAT].[REG_0402_Column_Index_Details] (
    [REG_0402_ID]        INT      IDENTITY (1, 1) NOT NULL,
    [Index_Column_ID]    INT      CONSTRAINT [DF_REG_0402_Columnid] DEFAULT ((0)) NOT NULL,
    [Partition_Ordinal]  INT      CONSTRAINT [DF_REG_0402_partitionid] DEFAULT ((0)) NOT NULL,
    [Is_Descending_Key]  BIT      CONSTRAINT [DF_REG_0402_Descending] DEFAULT ('false') NOT NULL,
    [Is_Included_Column] BIT      CONSTRAINT [DF_REG_0402_Included] DEFAULT ('false') NOT NULL,
    [REG_Create_Date]    DATETIME CONSTRAINT [DF_REG_0402_CDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_REG_0402] PRIMARY KEY CLUSTERED ([Index_Column_ID] ASC, [Partition_Ordinal] ASC, [Is_Descending_Key] ASC, [Is_Included_Column] ASC),
    CONSTRAINT [UQ_REG_0402_ID] UNIQUE NONCLUSTERED ([REG_0402_ID] ASC)
);

