USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_LockPick]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[MP_LockPick]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[MP_LockPick]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [CAT].[MP_LockPick]
@Table NVARCHAR(256) = ''ALL''

AS

DECLARE @SQL nvarchar(max)
, @ThisTable nvarchar(255)
, @IDFlag bit

EXEC sp_MSforeachtable ''RAISERROR(''''Started disabling constraints on table ?'''',1,1) ALTER TABLE ? NOCHECK CONSTRAINT all''

DECLARE LockPick CURSOR FOR
SELECT DISTINCT scm.name +''.''+ obj.name
, CASE WHEN idc.Object_ID IS NULL THEN 0 ELSE 1 END
FROM sys.all_objects AS obj
JOIN sys.schemas AS scm
ON obj.Schema_ID = scm.Schema_ID
LEFT JOIN sys.identity_Columns as idc
ON idc.Object_ID = obj.Object_ID
WHERE left(obj.name,4) in (''LNK_'', ''TRK_'', ''REG_'', ''HSH_'')
AND (@Table = ''ALL'' OR CHARINDEX(@Table, obj.name) > 0)

OPEN LockPick

FETCH NEXT FROM LockPick
INTO @ThisTable, @IDFlag

WHILE @@fetch_status = 0
BEGIN

SET @SQL = ''
DELETE FROM ''+@ThisTable+''
'' EXECUTE sys.sp_executesql @SQl

IF @IDFlag = 1
BEGIN
	SET @SQL = ''
	PRINT ''''''+@ThisTable+''''''
	DBCC CHECKIDENT(''''''+@ThisTable+'''''', RESEED, 0)
	'' EXECUTE sys.sp_executesql @SQl
END

FETCH NEXT FROM LockPick
INTO @ThisTable, @IDFlag

END

CLOSE LockPick
DEALLOCATE LockPick


EXEC sp_MSforeachtable ''RAISERROR(''''Started checking constraints on table ?'''',1,1) ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL''

' 
END
GO
