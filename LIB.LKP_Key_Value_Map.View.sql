USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[LKP_Key_Value_Map]'))
DROP VIEW [LIB].[LKP_Key_Value_Map]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[LIB].[LKP_Key_Value_Map]'))
EXEC dbo.sp_executesql @statement = N'






CREATE VIEW [LIB].[LKP_Key_Value_Map]
AS
SELECT Name, Map_Value, cast(Map_Key as varchar) as Map_Key
FROM sys.dm_xe_map_values WITH(NOLOCK)
GROUP BY Name, Map_Value, Map_Key
UNION
SELECT securable_class_desc, class_type_desc, class_type
FROM sys.dm_audit_class_type_map WITH(NOLOCK)
GROUP BY  securable_class_desc, class_type_desc, class_type



' 
GO
