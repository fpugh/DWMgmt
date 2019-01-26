CREATE TABLE [TMP].[REG_0102_Insert] (
    [REG_0102_ID]            INT NOT NULL,
    [Server_ID]              INT NOT NULL,
    [lazy_schema_validation] BIT NOT NULL,
    [Is_publisher]           BIT NOT NULL,
    [Is_subscriber]          BIT NULL,
    [Is_distributor]         BIT NULL,
    [Is_nonsql_subscriber]   BIT NULL
);

