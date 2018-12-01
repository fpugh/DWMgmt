USE [msdb]
GO

/****** Object:  Job [DWMgmt_Scan]    Script Date: 3/25/2016 12:05:46 AM ******/
EXEC msdb.dbo.sp_delete_job @job_id=N'49f6482f-06ad-4eb5-9af9-df28ef7f3fb9', @delete_unused_schedule=1
GO

/****** Object:  Job [DWMgmt_Scan]    Script Date: 3/25/2016 12:05:46 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Data Collector]    Script Date: 3/25/2016 12:05:46 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Data Collector' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Data Collector'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DWMgmt_Scan', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Runs the metadata and code catalogging process on specified servers.', 
		@category_name=N'Data Collector', 
		@owner_login_name=N'Corruscant\fpugh', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [REG_Server_Master_Execute]    Script Date: 3/25/2016 12:05:46 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'REG_Server_Master_Execute', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'SSIS', 
		@command=N'/ISSERVER "\"\SSISDB\DWMgmt\Actuation\REG_Server_Master.dtsx\"" /SERVER "\"CORRUSCANT\IMPERIAL_SENATE\"" /Par "\"$Project::DestinationDatabase\"";DWMgmt /Par "\"$Project::DestinationServer\"";"\"CORRUSCANT\IMPERIAL_SENATE\"" /Par "\"$Project::ExecuteOutOfProcess(Boolean)\"";False /Par "\"$Project::SQLSourceFileLocation\"";"\"E:\Databases\DWMgmt_Projects\DWMgmt_Actuation_and_Reporting\DWMgmt_SQL_Code\TSQL_Object_and_Procedural_Scripts\\"" /Par "\"$Project::SourceDatabase\"";master /Par "\"$Project::SourceServer\"";"\"CORRUSCANT\IMPERIAL_SENATE\"" /Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"";1 /Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"";True /CALLERINFO SQLAGENT /REPORTING E', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'BiDailyScan', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=12, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20160325, 
		@active_end_date=99991231, 
		@active_start_time=60000, 
		@active_end_time=55959, 
		@schedule_uid=N'f4f703d2-a11b-493f-9a0e-b2350b8dee7d'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


