/* Create a test case database
create database Archive_Test_ALPHA
use Archive_Test_Alpha
*/

DECLARE @IDMaxInt int
, @UnitID tinyint
, @RawEarly datetime
, @RawLate datetime

, @ID100kInt int
, @BlockID smallint
, @RenameVal varchar(36)
, @100kEarly datetime
, @100kLate datetime

, @RandInt int
, @LKIntFlag int
, @LKIntEarly datetime
, @LKIntLate datetime
, @String varchar(255)
, @SSLen int
, @SSEarly datetime
, @SSLate datetime
, @LKSSFlag int
, @LKSSEarly datetime
, @LKSSLate datetime
, @LongString nvarchar(4000)
, @LSLen int
, @LSEarly datetime
, @LSLate datetime
, @ID10kInt int
, @i tinyint
, @10kEarly datetime
, @10kLate datetime

SET @IDMaxInt = 0
SET @UnitID = 1

--WHILE @IDMaxInt < 2147383647
SET @RawEarly = GETDATE()
WHILE @IDMaxInt < 2000001
BEGIN
   
    SET @BlockID = 1
	SET @ID100kInt = 0
	IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Bulk_Data_10k_String_Lookup')
	BEGIN
		CREATE TABLE Bulk_Data_10k_String_Lookup (
		BDT_S_10K_ID SMALLINT IDENTITY(1,1) PRIMARY KEY,
		BDT_String_Key varchar(255) not null,
		BDT_String_Hit_Count int not null DEFAULT 0)

	    CREATE NONCLUSTERED INDEX idx_nc_BDTS10K_K4 ON Bulk_Data_10k_String_Lookup
	    (BDT_String_Key)
    END

	IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Bulk_Data_10k_Integer_Lookup')
	BEGIN
		CREATE TABLE Bulk_Data_10k_Integer_Lookup (
		BDT_I_10K_ID SMALLINT IDENTITY(1,1) PRIMARY KEY,
		BDT_Integer_Key int not null,
		BDT_Integer_Hit_Count int not null DEFAULT 0)

		CREATE NONCLUSTERED INDEX idx_nc_BDTI10K_K2 ON Bulk_Data_10k_Integer_Lookup
		(BDT_Integer_Key)
    END
    
	IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Bulk_Data_Block_Metrics')
	BEGIN 
        CREATE TABLE Bulk_Data_Block_Metrics (
        BDT_Met_ID tinyint identity (1,1) primary key,
        BDT_Block_ID tinyint not null,
        BDT_Block_Elapsed numeric not null,
        BDT_Post_Difference numeric not null,
        BDT_Min_Record_Size bigint not null,
        BDT_Avg_Record_Size bigint not null,
        BDT_Max_Record_Size bigint not null,
        BDT_Distinct_Block_Int_Values smallint not null,
        BDT_Most_Common_Int_Value int not null,
        BDT_Most_Common_Int_Value_Hits smallint not null,
        BDT_Distinct_Block_SS_Values smallint not null,
        BDT_Most_Common_SS_Value varchar(255) not null,
        BDT_Most_Common_SS_Value_Hits smallint not null,
        BDT_Min_LS_Length smallint not null,
        BDT_Avg_LS_Length smallint not null,
        BDT_Max_LS_Length smallint not null)
    END

	WHILE @ID100kInt < 100000
	BEGIN

    	SET @ID10kInt = 0
    	SET @10kEarly = GETDATE()
    	
        IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Bulk_Data_10K_Table')
		BEGIN
			CREATE TABLE Bulk_Data_10K_Table (
			BDT_ID int identity(1,2) primary key,
			BDT_Random_Integer int not null default 0,
			BDT_10k_Lookup_Flag int default 0,
			BDT_10k_Lookup_Elapsed numeric null,
			BDT_Short_String varchar(255) not null,
			BDT_SS_10k_Lookup_Flag int default 0,
			BDT_SS_10k_Lookup_Elapsed float null,
			BDT_SS_Length int,
			BDT_SS_Post_Early datetime not null default getdate(),
			BDT_SS_Post_Late datetime not null default getdate(),
			BDT_SS_Elapsed numeric null,
			BDT_Long_String nvarchar(max) null,
			BDT_LS_Length int,
			BDT_LS_Post_Early datetime not null default getdate(),
			BDT_LS_Post_Late datetime not null default getdate(),
			BDT_LS_Elapsed numeric null,
			BDT_Post datetime not null default getdate())

			CREATE NONCLUSTERED INDEX idx_nc_BDT_K2 on Bulk_Data_10K_Table
			(BDT_Random_Integer asc)

			CREATE NONCLUSTERED INDEX idx_nc_BDT_K3 on Bulk_Data_10K_Table
			(BDT_10k_Lookup_Flag desc)

			CREATE NONCLUSTERED INDEX idx_nc_BDT_K4 on Bulk_Data_10K_Table
			(BDT_10k_Lookup_Elapsed desc)

			CREATE NONCLUSTERED INDEX idx_nc_BDT_K5 on Bulk_Data_10K_Table
			(BDT_Short_String asc)

			CREATE NONCLUSTERED INDEX idx_nc_BDT_K6 on Bulk_Data_10K_Table
			(BDT_SS_10k_Lookup_Flag desc)

			CREATE NONCLUSTERED INDEX idx_nc_BDT_K7 on Bulk_Data_10K_Table
			(BDT_SS_10k_Lookup_Elapsed desc)

			CREATE NONCLUSTERED INDEX idx_nc_BDT_K8 on Bulk_Data_10K_Table
			(BDT_SS_Length desc)

			CREATE NONCLUSTERED INDEX idx_nc_BDT_K13 on Bulk_Data_10K_Table
			(BDT_LS_Length desc)
		END

		WHILE @ID10kInt < 10000
		BEGIN

		SET @RandInt = cast(RAND(CHECKSUM(NEWID()))*1000000000 as int);

		SET @LKIntEarly = GETDATE();
		SELECT @LKIntFlag = CASE WHEN ISNULL(
				(SELECT COUNT(BDT_I_10K_ID) FROM Bulk_Data_10k_Integer_Lookup WHERE BDT_Integer_Key = @RandInt), 0) 
				= 0 THEN 0 ELSE 1 END;
		SET @LKIntLate = GETDATE();

		SET @SSEarly = GETDATE();
		SET @String = ''
		WHILE LEN(@String) < (1+ROUND((254 * RAND(CHECKSUM(NEWID()))),0))
		BEGIN
			SELECT @i = (1 + ROUND((2 * RAND()),0))
			SELECT @String = @String + ISNULL(CASE WHEN @i = 1 THEN char(48 + ROUND(((57-48)* RAND(CHECKSUM(NEWID()))),0))
			WHEN @i = 2 THEN char(65 + ROUND(((90-65) * RAND(CHECKSUM(NEWID()))),0))
			WHEN @i = 3 THEN char(97 + ROUND(((122-97) * RAND(CHECKSUM(NEWID()))),0))
			END,'-')
		END
		SET @SSLen = LEN(@String);
		SET @SSLate = GETDATE();

		SET @LKSSEarly = GETDATE();
		SELECT @LKSSFlag = CASE WHEN ISNULL(
		(SELECT COUNT(BDT_S_10K_ID) FROM Bulk_Data_10k_String_Lookup WHERE BDT_String_Key = @String), 0) 
		= 0 THEN 0 ELSE 1 END;
		SET @LKSSLate = GETDATE();
		
		SET @LSEarly = GETDATE();	
		SET @LongString = ''
		WHILE LEN(@LongString) < (1+ROUND((3999 * RAND(CHECKSUM(NEWID()))),0))
		BEGIN
			SELECT @LongString = @LongString + ISNULL(char(32 + ROUND(((127-32)* RAND(CHECKSUM(NEWID()))),0)),'-')
		END
		SET @LSLen = LEN(@LongString);
		SET @LSLate = GETDATE();

		INSERT INTO Bulk_Data_10K_Table (BDT_Random_Integer, BDT_10k_Lookup_Flag, BDT_10k_Lookup_Elapsed
		, BDT_Short_String, BDT_SS_Length, BDT_SS_Post_Early, BDT_SS_Post_Late, BDT_SS_Elapsed
		, BDT_SS_10K_Lookup_Flag, BDT_SS_10K_Lookup_Elapsed
		, BDT_Long_String, BDT_LS_Length, BDT_LS_Post_Early, BDT_LS_Post_Late, BDT_LS_Elapsed)
		
		SELECT @RandInt, @LKIntFlag, datediff(mcs,@LKIntLate,@LKIntEarly) as LK_10K_Elapsed
			, @String, @SSLen, @SSEarly, @SSLate, datediff(mcs,@SSLate,@SSEarly) as SS_Elapsed
			, @LKSSFlag, datediff(mcs,@LKSSLate,@LKSSEarly) as LK_SS_Elapsed
			, @LongString, @LSLen, @LSEarly, @LSLate, datediff(mcs,@LSlate,@LSEarly) as LS_Elapsed

		SET @ID10kInt = @ID10kInt+1
		
		IF (SELECT COUNT(*) FROM Bulk_Data_10k_String_Lookup) = 0 AND @ID10kInt = 10000
			BEGIN	
				INSERT INTO Bulk_Data_10k_String_Lookup (BDT_String_Key)
				SELECT TOP 10000 BDT_Short_String
				FROM Bulk_Data_10K_Table;
    		END

		IF (SELECT COUNT(*) FROM Bulk_Data_10k_Integer_Lookup) = 0 AND @ID10kInt = 10000
			BEGIN	
				INSERT INTO Bulk_Data_10k_Integer_Lookup (BDT_Integer_Key)
				SELECT TOP 10000 BDT_Random_Integer
				FROM Bulk_Data_10K_Table;
			END
			
			
		--TRUNCATE TABLE Bulk_Data_10K_Table
  --      SET @ID10kInt = 0
        END

        SET @10kLate = GETDATE()
		SET @ID100kInt = @ID100kInt + (SELECT COUNT(*) FROM Bulk_Data_10K_Table)
		SET @IDMaxInt = @IDMaxInt + (SELECT COUNT(*) FROM Bulk_Data_10K_Table)

		UPDATE lkp SET BDT_Integer_Hit_Count = BDT_Integer_Hit_Count + BDT_10K_Lookup_Flag
		FROM Bulk_Data_10k_Integer_Lookup AS lkp
		LEFT OUTER JOIN Bulk_Data_10K_Table AS bdt
		ON bdt.BDT_Random_Integer = lkp.BDT_Integer_Key
		WHERE bdt.BDT_10K_Lookup_Flag > 0;

		UPDATE lkp SET BDT_String_Hit_Count = BDT_String_Hit_Count + BDT_SS_10K_Lookup_Flag
		FROM Bulk_Data_10k_String_Lookup AS lkp
		LEFT OUTER JOIN Bulk_Data_10K_Table AS bdt
		ON bdt.BDT_Short_String = lkp.BDT_String_Key
		WHERE bdt.BDT_SS_10k_Lookup_Flag > 0;

        INSERT INTO Bulk_Data_Block_Metrics (BDT_Block_ID, BDT_Block_Elapsed, BDT_Post_Difference
        , BDT_Min_Record_Size, BDT_Avg_Record_Size, BDT_Max_Record_Size
        , BDT_Distinct_Block_Int_Values, BDT_Most_Common_Int_Value, BDT_Most_Common_Int_Value_Hits
        , BDT_Distinct_Block_SS_Values, BDT_Most_Common_SS_Value, BDT_Most_Common_SS_Value_Hits
        , BDT_Min_LS_Length, BDT_Avg_LS_Length, BDT_Max_LS_Length)

        SELECT @BlockID, datediff(mcs,@10kLate,@10kEarly) AS Block_Elapsed, datediff(mcs,MIN(BDT_Post),MAX(BDT_Post))
        , (4+4+2+8+MIN(BDT_SS_Length)+4+8+8+8+MIN(BDT_LS_Length)+4+8+8+8+8)
        , (4+4+2+8+AVG(BDT_SS_Length)+4+8+8+8+AVG(BDT_LS_Length)+4+8+8+8+8)
        , (4+4+2+8+MAX(BDT_SS_Length)+4+8+8+8+MAX(BDT_LS_Length)+4+8+8+8+8)
        , COUNT(DISTINCT tbl.BDT_Random_Integer), lkp1.BDT_Random_Integer, lkp1.BDT_Random_Integer_Value_Count
        , COUNT(DISTINCT tbl.BDT_Short_String), lkp2.BDT_Short_String, lkp2.BDT_SS_Value_Count
        , MIN(BDT_LS_Length), AVG(BDT_LS_Length), MAX(BDT_LS_Length)
        FROM Bulk_Data_10K_Table AS tbl
        JOIN (SELECT TOP 1 BDT_Random_Integer, COUNT(*) AS BDT_Random_Integer_Value_Count 
                FROM Bulk_Data_10K_Table 
                GROUP BY BDT_Random_Integer 
                ORDER BY COUNT(*) DESC) AS lkp1
        ON 'A' = 'A'
        JOIN (SELECT TOP 1 BDT_Short_String, COUNT(*) AS BDT_SS_Value_Count 
                FROM Bulk_Data_10K_Table 
                GROUP BY BDT_Short_String 
                ORDER BY COUNT(*) DESC) AS lkp2
        ON 'A' = 'A'
        GROUP BY lkp1.BDT_Random_Integer, lkp1.BDT_Random_Integer_Value_Count, lkp2.BDT_Short_String, lkp2.BDT_SS_Value_Count


		IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Bulk_Data_10K_Table')
		BEGIN
    		IF ((@ID100kInt/10000)/@BlockID) = 1.0000 AND (SELECT COUNT(*) FROM Bulk_Data_10K_Table) = 10000
			BEGIN 
				SET @RenameVal = 'Bulk_Data_10K_Table_UB:'+RIGHT('000'+CAST(@UnitID as VARCHAR),3)+':'+RIGHT('00'+CAST(@BlockID as VARCHAR),2)
				EXEC sp_rename Bulk_Data_10K_Table, @RenameVal
			END
	    END
	
	SET @BlockID = @BlockID + 1
	   	 
	    IF (@ID100kInt/100000) = 1.0000
        BEGIN
            SET @RenameVal = 'Bulk_Data_10k_String_Lookup_U'+RIGHT('000'+CAST(@UnitID as VARCHAR),3)
            EXEC sp_rename Bulk_Data_10k_String_Lookup, @RenameVal
            
            SET @RenameVal = 'Bulk_Data_10k_Integer_Lookup_U'+RIGHT('000'+CAST(@UnitID as VARCHAR),3)
            EXEC sp_rename Bulk_Data_10k_Integer_Lookup, @RenameVal

            SET @RenameVal = 'Bulk_Data_Block_Metrics_U'+RIGHT('000'+CAST(@UnitID as VARCHAR),3)
            EXEC sp_rename Bulk_Data_Block_Metrics, @RenameVal
        END
        
	END

    SET @UnitID = @UnitID + 1
	SET @ID100kInt = 0
	
END

	
SET @RawLate = GETDATE()
GO




CREATE VIEW V_T10K_Integer_Hits
AS
SELECT TOP 100 PERCENT BDT_Integer_Key, BDT_Integer_Hit_Count
FROM dbo.Bulk_Data_10k_Integer_Lookup_U001
WHERE BDT_Integer_Hit_Count > 0
GO




CREATE VIEW V_T10K_String_Hits
AS
SELECT TOP 100 PERCENT BDT_String_Key, BDT_String_Hit_Count
FROM dbo.Bulk_Data_10k_String_Lookup_U001
WHERE BDT_String_Hit_Count > 0
GO