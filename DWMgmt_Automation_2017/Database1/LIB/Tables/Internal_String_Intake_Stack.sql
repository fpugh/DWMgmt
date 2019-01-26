CREATE TABLE [LIB].[Internal_String_Intake_Stack] (
    [ID_Type]       TINYINT        CONSTRAINT [DF_Int_String_Stack_ID_Type] DEFAULT ((0)) NOT NULL,
    [Server_ID]     INT            NOT NULL,
    [Server_Name]   NVARCHAR (256) NULL,
    [Database_ID]   INT            NULL,
    [Database_Name] NVARCHAR (256) NULL,
    [Schema_ID]     INT            NULL,
    [Schema_Name]   NVARCHAR (256) NULL,
    [Object_ID]     INT            NULL,
    [Object_Name]   NVARCHAR (256) NULL,
    [Object_Type]   NVARCHAR (25)  NULL,
    [Object_Owner]  NVARCHAR (256) NULL,
    [Column_ID]     INT            NULL,
    [Column_Name]   NVARCHAR (256) NULL,
    [Version_Stamp] CHAR (40)      NULL,
    [Create_Date]   DATETIME       CONSTRAINT [DF_Int_String_Stack_Create_Date] DEFAULT (getdate()) NULL,
    [Post_Date]     DATETIME       CONSTRAINT [DF_Int_String_Stack_Post_Date] DEFAULT (getdate()) NOT NULL,
    [Code_Content]  NVARCHAR (MAX) NOT NULL,
    [Batch_ID]      NCHAR (7)      CONSTRAINT [DF_ISIS_Batch_ID] DEFAULT ('TXTL000') NULL
);


GO



/* These triggers exist on the string intake stack tables and apply a version stamp, as well
	as filter out duplicate entries detected during table insertion. */

CREATE TRIGGER [LIB].[Internal_String_Version_Stamp]
ON [LIB].[Internal_String_Intake_Stack]
INSTEAD OF INSERT

AS

INSERT INTO LIB.Internal_String_Intake_Stack (Server_ID
 , Database_ID
 , Database_Name
 , Schema_ID
 , Schema_Name
 , Object_ID
 , Object_Name
 , Object_Type
 , Create_Date
 , Version_Stamp
 , Code_Content)

SELECT Server_ID
 , Database_ID
 , Database_Name
 , Schema_ID
 , Schema_Name
 , Object_ID
 , Object_Name
 , Object_Type
 , Create_Date
 , SOUNDEX(LEFT(Object_Name
 , LEN(Object_Name)/2))+'-'+SOUNDEX(RIGHT(Object_Name
 , LEN(Object_Name)/2)) -- Namex Code
 +':'+right('000'+cast(Server_ID as nvarchar),3)
 +'.'+right('000'+cast(Database_ID as nvarchar),3)
 +'.'+right('0000000000'+cast(Object_ID as nvarchar),10)
 +':'+right('0000000000'+cast(DATALENGTH(Code_Content) as nvarchar),10) as Version_Stamp -- Datamass Code
 , Code_Content
FROM inserted