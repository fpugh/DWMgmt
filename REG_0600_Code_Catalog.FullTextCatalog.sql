USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sysfulltextcatalogs ftc WHERE ftc.name = N'REG_0600_Code_Catalog')
DROP FULLTEXT CATALOG [REG_0600_Code_Catalog]
GO
IF NOT EXISTS (SELECT * FROM sysfulltextcatalogs ftc WHERE ftc.name = N'REG_0600_Code_Catalog')
CREATE FULLTEXT CATALOG [REG_0600_Code_Catalog]WITH ACCENT_SENSITIVITY = ON
AS DEFAULT

GO
