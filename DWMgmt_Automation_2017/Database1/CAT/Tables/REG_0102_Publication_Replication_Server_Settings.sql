CREATE TABLE [CAT].[REG_0102_Publication_Replication_Server_Settings] (
    [REG_0102_ID]               INT      IDENTITY (1, 1) NOT NULL,
    [REG_Lazy_Schema_Flag]      BIT      CONSTRAINT [DF_REG_0102_K2] DEFAULT ((0)) NOT NULL,
    [REG_Publisher_Flag]        BIT      CONSTRAINT [DF_REG_0102_K3] DEFAULT ((0)) NOT NULL,
    [REG_Subscriber_Flag]       BIT      CONSTRAINT [DF_REG_0102_K4] DEFAULT ((0)) NOT NULL,
    [REG_Distributor_Flag]      BIT      CONSTRAINT [DF_REG_0102_K5] DEFAULT ((0)) NOT NULL,
    [REG_NonSQL_Subcriber_Flag] BIT      CONSTRAINT [DF_REG_0102_K6] DEFAULT ((0)) NOT NULL,
    [REG_Create_Date]           DATETIME CONSTRAINT [DF_REG_0102_CDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_REG_0102] PRIMARY KEY CLUSTERED ([REG_Lazy_Schema_Flag] ASC, [REG_Publisher_Flag] ASC, [REG_Subscriber_Flag] ASC, [REG_Distributor_Flag] ASC, [REG_NonSQL_Subcriber_Flag] ASC),
    CONSTRAINT [UQ_REG_0102_ID] UNIQUE NONCLUSTERED ([REG_0102_ID] ASC)
);

