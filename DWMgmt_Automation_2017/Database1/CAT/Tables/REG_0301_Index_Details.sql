CREATE TABLE [CAT].[REG_0301_Index_Details] (
    [REG_0301_ID]          INT            IDENTITY (1, 1) NOT NULL,
    [Filter_Definition]    NVARCHAR (MAX) NULL,
    [data_space_ID]        INT            NOT NULL,
    [Fill_Factor]          TINYINT        NOT NULL,
    [Is_Unique]            BIT            CONSTRAINT [DF_REG_0301_Unique] DEFAULT ('false') NOT NULL,
    [Ignore_Dup_Key]       BIT            CONSTRAINT [DF_REG_0301_igndup] DEFAULT ('false') NOT NULL,
    [Is_Primary_Key]       BIT            CONSTRAINT [DF_REG_0301_primkey] DEFAULT ('false') NOT NULL,
    [Is_Unique_Constraint] BIT            CONSTRAINT [DF_REG_0301_unqcnsrt] DEFAULT ('false') NOT NULL,
    [Is_padded]            BIT            CONSTRAINT [DF_REG_0301_padded] DEFAULT ('false') NOT NULL,
    [Is_Disabled]          BIT            CONSTRAINT [DF_REG_0301_Disabled] DEFAULT ('false') NOT NULL,
    [Is_hypothetical]      BIT            CONSTRAINT [DF_REG_0301_hypothetical] DEFAULT ('false') NOT NULL,
    [Allow_Row_Locks]      BIT            CONSTRAINT [DF_REG_0301_rolox] DEFAULT ('true') NOT NULL,
    [Allow_Page_Locks]     BIT            CONSTRAINT [DF_REG_0301_paglox] DEFAULT ('true') NOT NULL,
    [REG_Create_Date]      DATETIME       CONSTRAINT [DF_REG_0301_CDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_REG_0301] PRIMARY KEY CLUSTERED ([data_space_ID] ASC, [Fill_Factor] ASC, [Is_Unique] ASC, [Ignore_Dup_Key] ASC, [Is_Primary_Key] ASC, [Is_Unique_Constraint] ASC, [Is_padded] ASC, [Is_Disabled] ASC, [Is_hypothetical] ASC, [Allow_Row_Locks] ASC, [Allow_Page_Locks] ASC),
    CONSTRAINT [UQ_REG_0301_ID] UNIQUE NONCLUSTERED ([REG_0301_ID] ASC)
);

