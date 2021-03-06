

--IF EXISTS (SELECT name FROM sys.tables WHERE name = N'LNK_Current_Keys')
--DROP TABLE CAT.LNK_Current_Keys
--GO

--CREATE TABLE [CAT].[LNK_Current_Keys](
--	[TID] [bigint] NOT NULL,
--	[LNK_Rank] [int] NULL,
--	[LNK_T2_ID] [int] NOT NULL,
--	[LNK_FK_0100_ID] [int] NOT NULL,
--	[T1P_ID] [int] NULL,
--	[LNK_FK_0101_ID] [int] NULL,
--	[LNK_FK_0102_ID] [int] NULL,
--	[LNK_FK_0103_ID] [int] NULL,
--	[LNK_FK_0200_ID] [int] NOT NULL,
--	[T2P_ID] [int] NULL,
--	[LNK_FK_0201_ID] [int] NULL,
--	[LNK_FK_0202_ID] [int] NULL,
--	[LNK_FK_0203_ID] [int] NULL,
--	[REG_File_Type] [nvarchar](25) NULL,
--	[LNK_FK_0204_ID] [int] NULL,
--	[LNK_FK_0205_ID] [int] NULL,
--	[LNK_T3_ID] [int] NULL,
--	[LNK_FK_0300_ID] [int] NULL,
--	[REG_Object_Type] [nvarchar](25) NULL,
--	[T3P_ID] [int] NULL,
--	[LNK_FK_0301_ID] [int] NULL,
--	[LNK_FK_0302_CD_ID] [int] NULL,
--	[LNK_FK_0302_FK_ID] [int] NULL,
--	[LNK_T4_ID] [int] NULL,
--	[LNK_FK_0400_ID] [int] NULL,
--	[T4P_ID] [int] NULL,
--	[LNK_FK_0401_ID] [int] NULL,
--	[LNK_FK_0402_ID] [int] NULL
--) ON [PRIMARY]


--DECLARE @SearchDate DATETIME

--SELECT @SearchDate = GETDATE()


--INSERT INTO CAT.LNK_Current_Keys
--SELECT DENSE_RANK() OVER(ORDER BY lsd.LNK_T2_ID, ISNULL(lsb.LNK_T3_ID,0), ISNULL(occ.LNK_Rank,0), ISNULL(occ.LNK_T4_ID,0)
--, ISNULL(t1p.T1P_ID,0), ISNULL(t2p.T2P_ID,0), ISNULL(t3p.T3P_ID,0), ISNULL(t4p.T4P_ID,0)) AS TID 
--, occ.LNK_Rank, lsd.LNK_T2_ID, lsd.LNK_FK_0100_ID
--, t1p.T1P_ID, t1p.LNK_FK_0101_ID, t1p.LNK_FK_0102_ID, t1p.LNK_FK_0103_ID
--, lsd.LNK_FK_0200_ID
--, t2p.T2P_ID, t2p.LNK_FK_0201_ID, t2p.LNK_FK_0202_ID, t2p.LNK_FK_0203_ID, rdf.REG_File_Type
--, t2p.LNK_FK_0204_ID, t2p.LNK_FK_0205_ID
--, lsb.LNK_T3_ID, lsb.LNK_FK_0300_ID, ror.REG_Object_Type
--, t3p.T3P_ID, t3p.LNK_FK_0301_ID, t3p.LNK_FK_0302_CD_ID, t3p.LNK_FK_0302_FK_ID
--, occ.LNK_T4_ID, occ.LNK_FK_0400_ID
--, t4p.T4P_ID, t4p.LNK_FK_0401_ID, t4p.LNK_FK_0402_ID
--FROM CAT.LNK_0100_0200_Server_Databases AS lsd WITH(NOLOCK)
--LEFT JOIN CAT.LNK_0204_0300_Schema_Binding AS lsb WITH(NOLOCK)
--ON lsd.LNK_T2_ID = lsb.LNK_FK_T2_ID
--AND @SearchDate BETWEEN lsb.LNK_Post_Date AND lsb.LNK_Term_Date
--AND @SearchDate BETWEEN lsd.LNK_Post_Date AND lsd.LNK_Term_Date
--LEFT JOIN CAT.LNK_0300_0400_Object_Column_Collection AS occ WITH(NOLOCK)
--ON lsb.LNK_T3_ID = occ.LNK_FK_T3_ID
--AND @SearchDate BETWEEN occ.LNK_Post_Date AND occ.LNK_Term_Date
--LEFT JOIN CAT.LNK_Tier1_Peers AS t1p WITH(NOLOCK)
--ON t1p.LNK_FK_0100_ID = lsd.LNK_FK_0100_ID
--AND @SearchDate BETWEEN t1p.LNK_Post_Date AND t1p.LNK_Term_Date
--LEFT JOIN CAT.LNK_Tier2_Peers AS t2p WITH(NOLOCK)
--ON t2p.LNK_FK_T2_ID = lsd.LNK_T2_ID
--AND t2p.LNK_FK_0204_ID = lsb.LNK_FK_0204_ID
--AND @SearchDate BETWEEN t2p.LNK_Post_Date AND t2p.LNK_Term_Date
--LEFT JOIN CAT.LNK_Tier3_Peers AS t3p WITH(NOLOCK)
--ON t3p.LNK_FK_T3_ID = lsb.LNK_T3_ID
--AND @SearchDate BETWEEN t3p.LNK_Post_Date AND t3p.LNK_Term_Date
--LEFT JOIN CAT.LNK_Tier4_Peers AS t4p WITH(NOLOCK)
--ON t4p.LNK_FK_T4_ID = occ.LNK_T4_ID
--AND @SearchDate BETWEEN t4p.LNK_Post_Date AND t4p.LNK_Term_Date
--JOIN CAT.REG_0203_Database_files AS rdf
--ON rdf.REG_0203_ID = t2p.LNK_FK_0203_ID
--JOIN CAT.REG_0300_Object_registry AS ror
--ON ror.REG_0300_ID = lsb.LNK_FK_0300_ID
--ORDER BY TID

--ALTER TABLE CAT.LNK_Current_Keys ADD CONSTRAINT PK_LNK_Current_Keys PRIMARY KEY CLUSTERED (TID)


DROP TABLE #Constructs
GO

DECLARE @DBCollation NVARCHAR(256) = 'SQL_Latin1_General_CP1_CI_AS'

SELECT DISTINCT rsr.REG_Server_Name, rdr.REG_Database_Name, rds.REG_Schema_Name, ror.REG_Object_Name
, '['+ rsr.REG_Server_Name +'].['+ rdr.REG_Database_Name +'].['+ rds.REG_Schema_Name +'].['+ ror.REG_Object_Name +']'  as Fully_Qualified_Name
, '['+ rds.REG_Schema_Name +'].['+ ror.REG_Object_Name +']'  as Schema_Qualified_Name
, rdr.REG_Collation, rdr.REG_Compatibility
, lck.LNK_Rank as Column_Rank
, rcr.REG_Column_Name
, typ.name as Column_Type_Desc
, rcp.Is_Identity
, '['+rcr.REG_Column_Name + '] [' + typ.name
+ CASE WHEN rcp.Is_Identity = 1 THEN '] IDENTITY' ELSE ']' END
+ CASE WHEN rcr.REG_Column_Type IN (34,98,99,106,108,165,167,173,175,231,239,241,256)  THEN ' ('+CAST(rcp.REG_Size AS nvarchar) + ')'
	WHEN rcr.REG_Column_Type IN (106,108) OR rcp.Is_Identity = 1 THEN ' ('+CAST(rcp.REG_Size AS nvarchar) + ',' + cast(rcp.REG_Scale as nvarchar)+')' ELSE '' END
+ CASE WHEN rcp.Is_Nullable = 0 THEN ' NOT NULL' ELSE ' NULL' END 
+ CASE WHEN rdr.REG_Collation != @DBCollation AND rcr.REG_Column_Type IN (167,231) THEN  ' COLLATE '+@DBCollation+'' ELSE '' END AS Column_Definition
INTO #Constructs
FROM CAT.LNK_Current_Keys AS lck WITH(NOLOCK)
JOIN (
	SELECT LNK_FK_0300_ID, LNK_FK_0204_ID, LNK_FK_0200_ID
	FROM CAT.LNK_Current_Keys WITH(NOLOCK)
	WHERE REG_Object_Type = 'U'
	GROUP BY LNK_FK_0300_ID, LNK_FK_0204_ID, LNK_FK_0200_ID
	HAVING COUNT(DISTINCT LNK_T2_ID) > 1
	) AS sub
ON sub.LNK_FK_0300_ID = lck.LNK_FK_0300_ID
AND sub.LNK_FK_0204_ID = lck.LNK_FK_0204_ID
AND sub.LNK_FK_0200_ID = lck.LNK_FK_0200_ID
JOIN CAT.REG_0100_Server_Registry AS rsr WITH(NOLOCK)
ON rsr.REG_0100_ID = lck.LNK_FK_0100_ID
JOIN CAT.REG_0200_Database_Registry AS rdr WITH(NOLOCK)
ON rdr.REG_0200_ID = lck.LNK_FK_0200_ID
JOIN CAT.REG_0204_Database_Schemas AS rds WITH(NOLOCK)
ON rds.REG_0204_ID = lck.LNK_FK_0204_ID
JOIN CAT.REG_0300_Object_Registry AS ror WITH(NOLOCK)
ON ror.REG_0300_ID = lck.LNK_FK_0300_ID
JOIN CAT.REG_0400_Column_registry AS rcr WITH(NOLOCK)
ON rcr.REG_0400_ID = lck.LNK_FK_0400_ID
JOIN CAT.REG_0401_Column_Properties AS rcp WITH(NOLOCK)
ON rcp.REG_0401_ID = lck.LNK_FK_0401_ID
JOIN sys.types AS typ
ON typ.user_type_id = rcr.REG_Column_Type
ORDER BY rsr.REG_Server_Name, rdr.REG_Database_Name, rds.REG_Schema_Name, ror.REG_Object_Name






DECLARE @NamePart NVARCHAR(256) = 'JEDI_COUNCIL.DWMgmt.CAT.REG'

DECLARE @Fully_Qualified_Name NVARCHAR(256) = ''
, @Table_Name NVARCHAR(256) = ''
, @Column_String NVARCHAR(4000) = ''
, @i int
, @SQL NVARCHAR(MAX)

DECLARE BuilderBob CURSOR FOR
SELECT Fully_Qualified_Name, '[' + REG_Object_Name + ']', MAX(Column_Rank)
FROM #Constructs
WHERE @NamePart = 'ALL' OR CHARINDEX(@NamePart, REPLACE(REPLACE(Fully_Qualified_Name, '[', ''), ']', '')) > 0
GROUP BY Fully_Qualified_Name, REG_Object_Name

OPEN BuilderBob

FETCH NEXT FROM BuilderBob
INTO @Fully_Qualified_Name, @Table_Name, @i

WHILE @@FETCH_STATUS = 0
BEGIN

	WHILE @i > 0
	BEGIN

		SELECT @Column_String = CASE WHEN Is_Identity = 1 THEN REPLACE(Column_Definition,'IDENTITY (1,1) ','')
			+ CHAR(13) + ', ' + REPLACE(REPLACE(Column_Definition, REG_Column_Name, 'Local_ID'),'IDENTITY (1,1) ','')
		 ELSE Column_Definition END
		 + CASE WHEN @Column_String = '' THEN '' 
		 ELSE CHAR(13)+', '+ @Column_String END
		FROM #Constructs WITH(NOLOCK)
		WHERE Fully_Qualified_Name = @Fully_Qualified_Name
		AND Column_Rank = @i

		SET @i = @i-1

	END

	SELECT @SQL = CHAR(13) + 'CREATE TABLE [TMP].' + REPLACE(@Table_Name, '].[', '_') + ' ('+ CHAR(13) + @Column_String +')' 
	 , @Column_String = ''
	
	PRINT @SQL

FETCH NEXT FROM BuilderBob
INTO @Fully_Qualified_Name, @Table_Name, @i

END

CLOSE BuilderBob
DEALLOCATE BuilderBob


