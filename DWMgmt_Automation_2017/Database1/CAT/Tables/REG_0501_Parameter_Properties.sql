CREATE TABLE [CAT].[REG_0501_Parameter_Properties] (
    [REG_0501_ID]       INT      IDENTITY (1, 1) NOT NULL,
    [REG_Size]          INT      CONSTRAINT [DF0_0501_Size] DEFAULT ((0)) NOT NULL,
    [REG_Scale]         INT      CONSTRAINT [DFm1_0501_Scale] DEFAULT ((-1)) NOT NULL,
    [Is_Input]          BIT      CONSTRAINT [DF0_0501_glbl] DEFAULT ((0)) NOT NULL,
    [Is_Output]         BIT      CONSTRAINT [DF0_0501_otpt] DEFAULT ((0)) NOT NULL,
    [Is_cursor_ref]     BIT      CONSTRAINT [DF0_0501_csrf] DEFAULT ((0)) NOT NULL,
    [has_Default_Value] BIT      CONSTRAINT [DF0_0501_dfvl] DEFAULT ((0)) NOT NULL,
    [Is_XML_document]   BIT      CONSTRAINT [DF0_0501_xmld] DEFAULT ((0)) NOT NULL,
    [Is_readonly]       BIT      CONSTRAINT [DF0_0501_read] DEFAULT ((0)) NOT NULL,
    [REG_Create_Date]   DATETIME CONSTRAINT [DFgd_0501_cdate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_REG_0501] PRIMARY KEY CLUSTERED ([REG_Size] ASC, [REG_Scale] ASC, [Is_Input] ASC, [Is_Output] ASC, [Is_cursor_ref] ASC, [has_Default_Value] ASC, [Is_XML_document] ASC, [Is_readonly] ASC),
    CONSTRAINT [UQ_REG_0501_ID] UNIQUE NONCLUSTERED ([REG_0501_ID] ASC)
);

