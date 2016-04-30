USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'CAT')
DROP SCHEMA [CAT]
GO
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'CAT')
EXEC sys.sp_executesql N'CREATE SCHEMA [CAT]'

GO
