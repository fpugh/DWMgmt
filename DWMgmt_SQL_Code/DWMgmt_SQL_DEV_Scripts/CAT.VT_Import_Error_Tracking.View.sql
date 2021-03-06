USE DWMgmt
GO


IF EXISTS (SELECT name FROM sys.all_objects WHERE name = N'VT_Import_Error_Tracking')
DROP VIEW CAT.VT_Import_Error_Tracking
GO


CREATE VIEW CAT.VT_Import_Error_Tracking
AS
SELECT [Target_Server]
,[Target_Database]
,[Task_Name]
,[Error_Code]
,[Error_Description]
,COUNT([Execution_ID]) AS FailedExecutions
,SUM([Records]) AS FailedRecords
,MIN([Post_Date]) AS FirstPost
,MIN([Post_Date]) AS LastPost
FROM [DWMgmt].[CAT].[TRK_SSIS_Import_Errors]
GROUP BY [Target_Server]
,[Target_Database]
,[Task_Name]
,[Error_Code]
,[Error_Description]