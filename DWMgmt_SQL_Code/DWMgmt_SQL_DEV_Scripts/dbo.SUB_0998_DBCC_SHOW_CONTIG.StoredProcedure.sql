USE [DWMgmt]
GO
/****** Object:  StoredProcedure [dbo].[SUB_0998_DBCC_SHOW_CONTIG]    Script Date: 3/1/2017 1:29:55 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SUB_0998_DBCC_SHOW_CONTIG]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SUB_0998_DBCC_SHOW_CONTIG]
GO
/****** Object:  StoredProcedure [dbo].[SUB_0998_DBCC_SHOW_CONTIG]    Script Date: 3/1/2017 1:29:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SUB_0998_DBCC_SHOW_CONTIG]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[SUB_0998_DBCC_SHOW_CONTIG]
@QualifiedName NVARCHAR(256)

AS

DECLARE @SQL NVARCHAR(600)
SELECT @SQL = ''
DBCC SHOWCONTIG (''''''+@QualifiedName+'''''')
WITH TABLERESULTS, ALL_INDEXES 
''

EXEC sp_ExecuteSQL @SQL
' 
END
GO
