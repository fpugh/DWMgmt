CREATE TABLE [TMP].[XML_Property_Map] (
    [Source_ID]       INT            NOT NULL,
    [Value_Anchor]    INT            NOT NULL,
    [Value_Bound]     INT            NOT NULL,
    [Property_Anchor] INT            NOT NULL,
    [Node_Name]       NVARCHAR (256) NOT NULL,
    [Property_Rank]   INT            NOT NULL,
    [Property]        NVARCHAR (256) NOT NULL,
    [Sub_Segment]     NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_XMLPropMap] PRIMARY KEY CLUSTERED ([Source_ID] ASC, [Value_Anchor] ASC, [Value_Bound] ASC)
);

