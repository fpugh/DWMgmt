CREATE TABLE [TMP].[XML_Property_Owners] (
    [Source_ID]  INT             NOT NULL,
    [Node_Name]  NVARCHAR (256)  NOT NULL,
    [Node_Level] INT             NOT NULL,
    [Node_Class] NVARCHAR (25)   NOT NULL,
    [Anchor]     BIGINT          NOT NULL,
    [Bound]      BIGINT          NOT NULL,
    [Segment]    NVARCHAR (4000) NOT NULL,
    CONSTRAINT [PK_XML_PropertyOwners] PRIMARY KEY CLUSTERED ([Source_ID] ASC, [Node_Level] ASC, [Anchor] ASC)
);

