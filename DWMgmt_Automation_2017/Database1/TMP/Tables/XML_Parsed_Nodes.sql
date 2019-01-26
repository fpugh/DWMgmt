CREATE TABLE [TMP].[XML_Parsed_Nodes] (
    [Source_ID]  INT            NOT NULL,
    [Node_Name]  NVARCHAR (256) NOT NULL,
    [Node_Level] INT            NOT NULL,
    [Node_Class] NVARCHAR (25)  NOT NULL,
    [Anchor]     BIGINT         NOT NULL,
    [Bound]      BIGINT         NOT NULL,
    CONSTRAINT [PK_XMLNodes] PRIMARY KEY CLUSTERED ([Source_ID] ASC, [Anchor] ASC)
);

