DECLARE @TargetDatabase NVARCHAR(256)
, @TargetServer NVARCHAR(256)
, @NamePart NVARCHAR(256)

SELECT TOP 1 @TargetDatabase = REG_Database_Name
, @TargetServer = REG_Server_Name
, @NamePart = Schema_Bound_name
FROM DWMgmt.CAT.VM_0454_Data_Profile_Assessor
ORDER BY VID

DECLARE @execution_id BIGINT
EXEC [SSISDB].[catalog].[create_execution]
   @package_name = N'REG_Data_Profile.dtsx'
  ,@execution_id = @execution_id OUTPUT
  ,@folder_name = N'DWMgmt'
  ,@project_name = N'Actuation'
  ,@use32bitruntime = False
  ,@reference_id = Null

--SELECT @execution_id as ExecutionID, @TargetServer as TargetServer, @TargetDatabase as TargetDatabase, @NamePart as NamePart

EXEC [SSISDB].[catalog].[set_execution_parameter_value]
   @execution_id
  ,@object_type = 30
  ,@parameter_name = N'TargetDatabase'
  ,@parameter_value = @TargetDatabase

EXEC [SSISDB].[catalog].[set_execution_parameter_value]
   @execution_id
  ,@object_type = 30
  ,@parameter_name = N'TargetServer'
  ,@parameter_value = @TargetServer

EXEC [SSISDB].[catalog].[set_execution_parameter_value]
   @execution_id
  ,@object_type = 30
  ,@parameter_name = N'NamePart'
  ,@parameter_value = @NamePart

EXEC [SSISDB].[catalog].[start_execution] @execution_id