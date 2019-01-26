CREATE TABLE [CAT].[REG_0302_Foreign_Key_Details] (
    [REG_0302_ID]               INT      IDENTITY (1, 1) NOT NULL,
    [Is_ms_shipped]             BIT      CONSTRAINT [DF_REG_0302_msshipped] DEFAULT ('false') NOT NULL,
    [Is_hypothetical]           BIT      CONSTRAINT [DF_REG_0302_hypothetical] DEFAULT ('false') NOT NULL,
    [Is_Published]              BIT      CONSTRAINT [DF_REG_0302_Published] DEFAULT ('false') NOT NULL,
    [Is_Schema_Published]       BIT      CONSTRAINT [DF_REG_0302_schmpub] DEFAULT ('false') NOT NULL,
    [Is_Disabled]               BIT      CONSTRAINT [DF_REG_0302_Disabled] DEFAULT ('false') NOT NULL,
    [Is_not_trusted]            BIT      CONSTRAINT [DF_REG_0302_nottrust] DEFAULT ('false') NOT NULL,
    [Is_not_for_replication]    BIT      CONSTRAINT [DF_REG_0302_notreplicate] DEFAULT ('true') NOT NULL,
    [Is_System_Named]           BIT      CONSTRAINT [DF_REG_0302_sysnamed] DEFAULT ('true') NOT NULL,
    [delete_referential_action] TINYINT  CONSTRAINT [DF_REG_0302_delref] DEFAULT ((0)) NOT NULL,
    [update_referential_action] TINYINT  CONSTRAINT [DF_REG_0302_updtref] DEFAULT ((0)) NOT NULL,
    [Key_Index_ID]              INT      NOT NULL,
    [principal_ID]              INT      NULL,
    [REG_Create_Date]           DATETIME CONSTRAINT [DF_REG_0302_CDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_REG_0302] PRIMARY KEY CLUSTERED ([Is_ms_shipped] ASC, [Is_hypothetical] ASC, [Is_Published] ASC, [Is_Schema_Published] ASC, [Is_Disabled] ASC, [Is_not_trusted] ASC, [Is_not_for_replication] ASC, [Is_System_Named] ASC, [delete_referential_action] ASC, [update_referential_action] ASC, [Key_Index_ID] ASC),
    CONSTRAINT [UQ_REG_0302_ID] UNIQUE NONCLUSTERED ([REG_0302_ID] ASC)
);

