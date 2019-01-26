CREATE TABLE [TMP].[REG_0500_0501_Insert] (
    [LNK_T2_ID]         INT            NULL,
    [LNK_T3_ID]         INT            NULL,
    [REG_0300_ID]       INT            NULL,
    [REG_0500_ID]       INT            NULL,
    [REG_0501_ID]       INT            NULL,
    [Server_ID]         INT            CONSTRAINT [DF_0500_0501_Server_ID] DEFAULT ((0)) NOT NULL,
    [Database_ID]       INT            NULL,
    [Object_ID]         INT            NULL,
    [Parameter_name]    NVARCHAR (256) NULL,
    [Parameter_Type]    INT            NULL,
    [rank]              INT            NULL,
    [size]              INT            NULL,
    [scale]             INT            NULL,
    [is_input]          BIT            NULL,
    [is_output]         BIT            NULL,
    [is_cursor_ref]     BIT            NULL,
    [has_default_value] BIT            NULL,
    [is_xml_document]   BIT            NULL,
    [is_readonly]       BIT            NULL,
    [default_value]     NVARCHAR (MAX) NULL,
    [xml_collection_ID] INT            NULL
);

