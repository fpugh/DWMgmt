

SELECT DISTINCT 
 mem.type_desc as RolememberType
, mem.principal_id as RoleMemberPrincipalID
, mem.name as RoleMemberName
, rol.type_desc as RoleMemberRoleType
, rol.name as RoleMemberRole
, prm.state_desc as RoleMemberPermissionState
, prm.permission_name as RoleMemberPermissionName
, prm.class_desc as RoleMemberPermissionClass

,'prm Database Permissions' as HeaderPrm
, prm.*

,'prm DB Role Members' as HeaderDrm
, drm.*

,'prm Database Principals' as HeaderRol
, rol.*

,'prm Database Principals' as HeaderMem
, mem.*

FROM sys.database_principals as mem
LEFT OUTER JOIN sys.database_role_members as drm
ON mem.principal_id = drm.member_principal_id
LEFT OUTER JOIN sys.database_principals as rol
ON rol.principal_id = drm.role_principal_id
LEFT OUTER JOIN sys.database_permissions as prm
ON prm.grantee_principal_id = mem.principal_id





SELECT DISTINCT mem.type_desc as RolememberType
, mem.principal_id as RoleMemberPrincipalID
, mem.name as RoleMemberName
, rol.type_desc as RoleMemberRoleType
, rol.name as RoleMemberRole
, prm.state_desc as RoleMemberPermissionState
, prm.permission_name as RoleMemberPermissionName
, prm.class_desc as RoleMemberPermissionClass
, obj.name
, obj.type_desc
FROM sys.database_principals as mem
LEFT OUTER JOIN sys.database_role_members as drm
ON mem.principal_id = drm.member_principal_id
LEFT OUTER JOIN sys.database_principals as rol
ON rol.principal_id = drm.role_principal_id
LEFT OUTER JOIN sys.database_permissions as prm
ON prm.grantee_principal_id = mem.principal_id
LEFT JOIN sys.objects as obj
ON obj.object_id = prm.major_id



--- ERGO - Deny select on OBJECT_OR_COLUMN [list] to [public].

--REVOKE SELECT ON Private.Test_Table TO public
--REVOKE SELECT ON Private.Test_Table_II TO public


GRANT SELECT ON Private.Test_Table TO [CORRUSCANT\SQL_MosEisley_Exclusive_User]
GRANT SELECT ON Private.Test_Table_II TO [CORRUSCANT\SQL_MosEisley_Exclusive_User]


--ALTER AUTHORIZATION ON schema::Private TO [CORRUSCANT\SQL_MosEisley_Exclusive_User]



--DENY SELECT ON Private.Test_Table TO [CORRUSCANT\SQL_MosEisley_PowerUsers]
--DENY SELECT ON Private.Test_Table_II TO [CORRUSCANT\SQL_MosEisley_PowerUsers]






DECLARE @SQL NVARCHAR(max)
, @State NVARCHAR(32)
, @Permission NVARCHAR(128)
, @Object NVARCHAR(256)
, @Principal NVARCHAR(128)

-- Users who should NOT see data in the object.

SELECT 




SET @SQL = @State+' '+@Permission+' ON '+ @Object +' TO '+ @Principal

IF @ExecuteStatus IN (0,1)
BEGIN
	PRINT @SQL
END

IF @ExecuteStatus IN (1,2)
BEGIN
	EXEC(@SQL)
END


























--select obj.name, obj.type_desc, dep.referenced_entity_name
--from sys.sql_expression_dependencies as dep
--join sys.all_objects as obj
--on dep.referencing_id = obj.object_id
--order by name, referenced_entity_name