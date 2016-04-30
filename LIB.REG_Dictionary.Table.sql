USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[Dictionary_Insert]'))
DROP TRIGGER [LIB].[Dictionary_Insert]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Dictionary_Post]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[REG_Dictionary] DROP CONSTRAINT [DF_Dictionary_Post]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[REG_Dictionary]') AND type in (N'U'))
DROP TABLE [LIB].[REG_Dictionary]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[REG_Dictionary]') AND type in (N'U'))
BEGIN
CREATE TABLE [LIB].[REG_Dictionary](
	[Word_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Word] [nvarchar](256) NOT NULL,
	[Post_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_LIB_Lexicon] PRIMARY KEY CLUSTERED 
(
	[Word] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Dictionary_WordID] UNIQUE NONCLUSTERED 
(
	[Word_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[LIB].[DF_Dictionary_Post]') AND type = 'D')
BEGIN
ALTER TABLE [LIB].[REG_Dictionary] ADD  CONSTRAINT [DF_Dictionary_Post]  DEFAULT (getdate()) FOR [Post_Date]
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[LIB].[Dictionary_Insert]'))
EXEC dbo.sp_executesql @statement = N'


CREATE TRIGGER [LIB].[Dictionary_Insert]
ON  [LIB].[REG_Dictionary]
INSTEAD OF INSERT
AS 

BEGIN
	
	INSERT INTO LIB.REG_Dictionary (Word)
	SELECT Word
	FROM inserted AS tmp
	EXCEPT
	SELECT Word
	FROM LIB.REG_Dictionary

END

' 
GO
