CREATE TABLE [TMP].[TRK_0300_Utiliztion_Insert] (
    [TRK_fk_T2_ID]         INT           CONSTRAINT [DF_Utilization_T2_ID] DEFAULT ((0)) NULL,
    [TRK_fk_T3_ID]         INT           CONSTRAINT [DF_Utilization_T3_ID] DEFAULT ((0)) NULL,
    [Server_ID]            INT           NULL,
    [Database_ID]          INT           NULL,
    [Object_ID]            INT           NULL,
    [TRK_Last_Action_Type] NVARCHAR (25) NULL,
    [TRK_Last_Action_Date] DATETIME      NULL,
    [Total_Seeks]          INT           NULL,
    [Total_Scans]          INT           NULL,
    [Total_Lookups]        INT           NULL,
    [Total_Updates]        INT           NULL
);

