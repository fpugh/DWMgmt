USE [DWMgmt]
GO
/****** Object:  User [DWMgmtAgent]    Script Date: 3/1/2017 1:29:55 AM ******/
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'DWMgmtAgent')
DROP USER [DWMgmtAgent]
GO
/****** Object:  User [DWMgmtAgent]    Script Date: 3/1/2017 1:29:56 AM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'DWMgmtAgent')
CREATE USER [DWMgmtAgent] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [DWMgmtAgent]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [DWMgmtAgent]
GO
