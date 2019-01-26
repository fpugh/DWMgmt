CREATE TABLE [CAT].[TRK_0205_DB_Maintenance_Job_Tracking] (
    [TRK_ID]           INT      IDENTITY (1, 1) NOT NULL,
    [TRK_FK_T2_ID]     INT      NOT NULL,
    [TRK_FK_0205_ID]   INT      NOT NULL,
    [TRK_FK_T3_ID]     INT      DEFAULT ((0)) NOT NULL,
    [TRK_FK_T4_ID]     INT      DEFAULT ((0)) NOT NULL,
    [TRK_Record_Count] BIGINT   NULL,
    [TRK_Status_Code]  INT      NULL,
    [TRK_Post_Date]    DATETIME CONSTRAINT [DF_TRK_0205_Post] DEFAULT (getdate()) NOT NULL,
    [TRK_Term_Date]    DATETIME NULL,
    CONSTRAINT [PK_TRK_0205] PRIMARY KEY CLUSTERED ([TRK_Post_Date] ASC, [TRK_FK_T2_ID] ASC, [TRK_FK_0205_ID] ASC, [TRK_FK_T3_ID] ASC, [TRK_FK_T4_ID] ASC),
    CONSTRAINT [FK_TRK_0205_REG_0205_Database_Maintenance_Properties] FOREIGN KEY ([TRK_FK_0205_ID]) REFERENCES [CAT].[REG_0205_Database_Maintenance_Properties_Old] ([REG_0205_ID])
);

