CREATE TABLE [CAT].[TRK_0203_Database_File_Changes] (
    [TRK_ID]            INT            IDENTITY (1, 1) NOT NULL,
    [TRK_FK_0203_ID]    INT            NOT NULL,
    [TRK_Growth_Factor] INT            NOT NULL,
    [TRK_Max_Size]      BIGINT         NOT NULL,
    [TRK_File_Size]     BIGINT         NOT NULL,
    [TRK_File_Path]     NVARCHAR (256) NULL,
    [TRK_Schema_Count]  INT            NOT NULL,
    [TRK_Object_Count]  INT            NOT NULL,
    [TRK_Post_Date]     DATETIME       CONSTRAINT [DF_TRK_0203_Post] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_TRK_0203] PRIMARY KEY CLUSTERED ([TRK_FK_0203_ID] ASC, [TRK_Growth_Factor] ASC, [TRK_Max_Size] ASC, [TRK_File_Size] ASC, [TRK_Schema_Count] ASC, [TRK_Object_Count] ASC, [TRK_Post_Date] ASC),
    CONSTRAINT [FK_TRK_0203_REG_0203_Database_files] FOREIGN KEY ([TRK_FK_0203_ID]) REFERENCES [CAT].[REG_0203_Database_Files] ([REG_0203_ID]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO


CREATE TRIGGER [CAT].[TGR_TRK_0203_DFC]
   ON  [CAT].[TRK_0203_Database_File_Changes]
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO CAT.TRK_0203_Database_File_Changes (TRK_FK_0203_ID, TRK_Growth_Factor, TRK_Max_Size, TRK_File_Size, TRK_File_Path, TRK_Schema_Count, TRK_Object_Count)
    SELECT ins.TRK_FK_0203_ID, ins.TRK_Growth_Factor, ins.TRK_Max_Size, ins.TRK_File_Size, ins.TRK_File_Path, ins.TRK_Schema_Count, ins.TRK_Object_Count
    FROM inserted AS ins
    LEFT JOIN CAT.TRK_0203_Database_File_Changes AS trk
    ON trk.TRK_FK_0203_ID = ins.TRK_FK_0203_ID
	AND trk.TRK_Growth_Factor = ins.TRK_Growth_Factor
	AND trk.TRK_Max_Size = ins.TRK_Max_Size
	AND trk.TRK_File_Size = ins.TRK_File_Size
	AND trk.TRK_Schema_Count = ins.TRK_Schema_Count
	AND trk.TRK_Object_Count = ins.TRK_Object_Count
	AND trk.TRK_Post_Date < getdate()
	WHERE trk.TRK_ID IS NULL
END