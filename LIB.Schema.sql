USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'LIB')
DROP SCHEMA [LIB]
GO
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'LIB')
EXEC sys.sp_executesql N'CREATE SCHEMA [LIB]'

GO
