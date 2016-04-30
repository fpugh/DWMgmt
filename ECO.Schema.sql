USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'ECO')
DROP SCHEMA [ECO]
GO
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'ECO')
EXEC sys.sp_executesql N'CREATE SCHEMA [ECO]'

GO
