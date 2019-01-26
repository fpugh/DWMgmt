CREATE TABLE [TMP].[REG_Trigger_Insert] (
    [LNK_T2_ID]              INT            DEFAULT ((0)) NULL,
    [LNK_T3_ID]              INT            DEFAULT ((0)) NULL,
    [REG_0204_ID]            INT            DEFAULT ((0)) NULL,
    [REG_0300_Prm_ID]        INT            DEFAULT ((0)) NULL,
    [REG_0300_Ref_ID]        INT            DEFAULT ((0)) NULL,
    [Server_ID]              INT            DEFAULT ((0)) NULL,
    [Database_ID]            INT            NULL,
    [Schema_ID]              INT            NULL,
    [Schema_Name]            NVARCHAR (256) NULL,
    [Parent_Object_ID]       INT            NULL,
    [Parent_Object_Name]     NVARCHAR (256) NULL,
    [Sub_Object_Rank]        TINYINT        NULL,
    [Trigger_Object_ID]      INT            NULL,
    [Trigger_Name]           NVARCHAR (256) NULL,
    [Trigger_Type]           NVARCHAR (256) NULL,
    [is_ms_shipped]          BIT            NULL,
    [is_disabled]            BIT            NULL,
    [is_not_for_replication] BIT            NULL,
    [is_instead_of_trigger]  BIT            NULL,
    [Create_Date]            DATETIME       NULL
);

