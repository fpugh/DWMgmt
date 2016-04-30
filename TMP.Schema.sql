USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'TMP')
DROP SCHEMA [TMP]
GO
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'TMP')
EXEC sys.sp_executesql N'CREATE SCHEMA [TMP]'

GO
