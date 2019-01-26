CREATE TABLE [TMP].[XML_Property_Bounds] (
    [Source_ID] INT            NOT NULL,
    [Node_Name] NVARCHAR (256) NOT NULL,
    [Anchor]    BIGINT         NOT NULL,
    [Map_Bound] BIGINT         NOT NULL,
    CONSTRAINT [PK_XML_Property_Bounds] PRIMARY KEY CLUSTERED ([Source_ID] ASC, [Anchor] ASC)
);

