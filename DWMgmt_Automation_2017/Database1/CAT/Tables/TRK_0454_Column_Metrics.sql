CREATE TABLE [CAT].[TRK_0454_Column_Metrics] (
    [TRK_ID]              INT            IDENTITY (1, 1) NOT NULL,
    [TRK_FK_T4_ID]        INT            NOT NULL,
    [TRK_Total_Values]    BIGINT         CONSTRAINT [DF_TRK_0454_Total_Values] DEFAULT ((0)) NOT NULL,
    [TRK_Column_Nulls]    BIGINT         CONSTRAINT [DF_TRK_0454_Column_Nulls] DEFAULT ((0)) NOT NULL,
    [TRK_Density]         DECIMAL (7, 6) CONSTRAINT [DF_TRK_0454_Density] DEFAULT ((0)) NOT NULL,
    [TRK_Uniqueness]      DECIMAL (7, 6) CONSTRAINT [DF_TRK_0454_Uniqueness] DEFAULT ((0)) NOT NULL,
    [TRK_Distinct_Values] INT            NULL,
    [TRK_Post_Date]       DATETIME       CONSTRAINT [DF_TRK_0454_Post_Date] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_TRK_0454] PRIMARY KEY CLUSTERED ([TRK_FK_T4_ID] ASC, [TRK_Post_Date] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TRK_0454_LNK_0300_0400_Object_Column_Collection] FOREIGN KEY ([TRK_FK_T4_ID]) REFERENCES [CAT].[LNK_0300_0400_Object_Column_Collection] ([LNK_T4_ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [UQ_TRK_0454_ID] UNIQUE NONCLUSTERED ([TRK_ID] ASC)
);

