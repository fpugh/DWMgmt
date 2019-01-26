CREATE TABLE [LIB].[REG_Sources] (
    [Source_ID]     INT           IDENTITY (1, 1) NOT NULL,
    [Version_Stamp] CHAR (40)     NOT NULL,
    [Post_Date]     DATETIME      CONSTRAINT [DF_Sources_Post] DEFAULT (getdate()) NOT NULL,
    [File_Path]     VARCHAR (512) DEFAULT ('C:\') NOT NULL,
    CONSTRAINT [PK_LIB_Sources] PRIMARY KEY CLUSTERED ([Version_Stamp] ASC, [File_Path] ASC),
    CONSTRAINT [UQ_Source_ID] UNIQUE NONCLUSTERED ([Source_ID] ASC)
);

