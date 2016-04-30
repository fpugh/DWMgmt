USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[TGR_REG_Source_Insert]'))
DROP TRIGGER [LIB].[TGR_REG_Source_Insert]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Sources_Post]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[REG_Sources] DROP CONSTRAINT [DF_Sources_Post]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[REG_Sources]') AND type in (N'U'))
DROP TABLE [LIB].[REG_Sources]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[REG_Sources]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[REG_Sources](
	[Source_ID] [int] IDENTITY(1,1) NOT NULL,
	[Version_Stamp] [char](40) NOT NULL,
	[Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_LIB_Sources] PRIMARY KEY CLUSTERED 
(
	[Version_Stamp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Source_ID] UNIQUE NONCLUSTERED 
(
	[Source_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Sources_Post]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[REG_Sources] ADD  CONSTRAINT [DF_Sources_Post]  DEFAULT (getdate()) FOR [Create_Date]
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[TGR_REG_Source_Insert]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [LIB].[TGR_REG_Source_Insert]
ON  [LIB].[REG_Sources]
INSTEAD OF INSERT

AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO LIB.REG_Sources (Version_Stamp)
	SELECT Version_Stamp
	FROM inserted
	EXCEPT
	SELECT Version_Stamp
	FROM LIB.REG_Sources
	
    
END
' 
GO
