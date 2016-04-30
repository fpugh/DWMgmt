USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[VC_2110_Collection_Documents]'))
DROP VIEW [LIB].[VC_2110_Collection_Documents]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[VC_2110_Collection_Documents]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [LIB].[VC_2110_Collection_Documents]
AS
SELECT lrc1.Name as Parent_Collection
, lrc2.Name as Collection_Name
, lrc2.Description
, lrd.Title, lrd.Author
, lrd.File_Size, lrd.File_Path
FROM LIB.HSH_Collection_Heirarchy AS hch WITH(NOLOCK)
JOIN LIB.HSH_Collection_Documents AS hcd WITH(NOLOCK)
ON hch.FK_Collection_ID = hcd.Collection_ID
AND GETDATE() BETWEEN hcd.Post_Date AND hcd.Term_Date
JOIN LIB.REG_Collections AS lrc1 WITH(NOLOCK)
ON lrc1.Collection_ID = hch.RK_Collection_ID
JOIN LIB.REG_Documents AS lrd WITH(NOLOCK)
ON lrd.Document_ID = hcd.Document_ID
JOIN LIB.REG_Collections AS lrc2 WITH(NOLOCK)
ON lrc2.Collection_ID = hch.FK_Collection_ID
WHERE GETDATE() BETWEEN hch.Post_Date AND hch.Term_Date

' 
GO
