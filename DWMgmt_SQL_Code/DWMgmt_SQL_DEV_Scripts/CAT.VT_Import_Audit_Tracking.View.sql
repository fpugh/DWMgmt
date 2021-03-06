USE DWMgmt
GO


IF EXISTS (SELECT name FROM sys.all_objects WHERE name = N'VT_Import_Audit_Tracking')
DROP VIEW CAT.VT_Import_Audit_Tracking
GO


CREATE VIEW CAT.VT_Import_Audit_Tracking
AS
SELECT [Target_Server]
,[Target_Database]
,[Task_Name]
,COUNT(DISTINCT [Execution_ID]) AS Executions
,MIN([Records]) AS ImportMinimum
,AVG([Records]) AS ImportAverage
,ISNULL(STDEV([Records]),0) AS ImportDeviation
,MAX([Records]) AS ImportMaximum
,MIN([Post_Date]) AS FirstPost
,MIN([Post_Date]) AS LastPost
FROM [DWMgmt].[CAT].[TRK_SSIS_Import_Audit]
GROUP BY [Target_Server]
,[Target_Database]
,[Task_Name]
