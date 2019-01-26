CREATE TABLE [CAT].[REG_0401_Column_Properties] (
    [REG_0401_ID]          INT      IDENTITY (1, 1) NOT NULL,
    [REG_Size]             INT      CONSTRAINT [DF_REG_0401_Size] DEFAULT ((0)) NOT NULL,
    [REG_Scale]            INT      CONSTRAINT [DF_REG_0401_Scale] DEFAULT ((-1)) NOT NULL,
    [Is_Identity]          BIT      CONSTRAINT [DF_REG_0401_Identity] DEFAULT ((0)) NOT NULL,
    [Is_Nullable]          BIT      CONSTRAINT [DF_REG_0401_Nullable] DEFAULT ((0)) NOT NULL,
    [Is_Default_Collation] BIT      CONSTRAINT [DF_REG_0401_dfltcollate] DEFAULT ((0)) NOT NULL,
    [REG_Create_Date]      DATETIME CONSTRAINT [DF_REG_0401_CDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_REG_0401] PRIMARY KEY CLUSTERED ([REG_Size] ASC, [REG_Scale] ASC, [Is_Identity] ASC, [Is_Nullable] ASC, [Is_Default_Collation] ASC),
    CONSTRAINT [UQ_REG_0401_ID] UNIQUE NONCLUSTERED ([REG_0401_ID] ASC)
);

