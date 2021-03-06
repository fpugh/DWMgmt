/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ID_Type]
      ,[Server_ID]
      ,[Server_Name]
      ,[Database_ID]
      ,[Database_Name]
      ,[Schema_ID]
      ,[Schema_Name]
      ,[Object_ID]
      ,[Object_Name]
      ,[Object_Type]
      ,[Object_Owner]
      ,[Column_ID]
      ,[Column_Name]
      ,[Version_Stamp]
      ,[Create_Date]
      ,[Post_Date]
      ,[Code_Content]
      ,[Batch_ID]
  FROM [DWMgmt].[LIB].[Internal_String_Intake_Stack]


  /* Clear for manual tests 
  
	TRUNCATE TABLE [DWMgmt].[LIB].[Internal_String_Intake_Stack]

	-- REG_Sources will eliminate any previously encountered code, reducing resource utilization during analysis.
	DELETE FROM [DWMgmt].[LIB].[REG_Sources]


	INSERT INTO [DWMgmt].LIB.Internal_String_Intake_Stack (Server_ID, Database_ID, Database_Name
	, Schema_ID, Schema_Name, Object_ID, Object_Name, Object_Type, Create_Date, Code_Content)

	SELECT DISTINCT Server_ID, Database_ID, Database_Name, Schema_ID, Schema_Name, Object_ID, Object_Name
	, Object_Type, Create_Date, Code_Content
	FROM [DWMgmt].TMP.REG_0600_Insert AS tmp WITH(NOLOCK)
	WHERE Code_Content IS NOT NULL
  
  */



