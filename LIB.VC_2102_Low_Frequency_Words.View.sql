USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[VC_2102_Low_Frequency_Words]'))
DROP VIEW [LIB].[VC_2102_Low_Frequency_Words]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[VC_2102_Low_Frequency_Words]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [LIB].[VC_2102_Low_Frequency_Words]
AS
SELECT TOP 20 PERCENT Collection_Name, Description, Word, Global_Use_Count, Collection_Use_Count, Word_Age_Days, Collection_Age_Days 
FROM [LIB].[VC_2100_Meta_Dictionary] WITH(NOLOCK)
ORDER BY Collection_Use_Count
' 
GO
