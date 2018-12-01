USE TestDB
GO

IF EXISTS (SELECT tables.name FROM sys.tables JOIN sys.schemas on tables.schema_id = schemas.schema_id WHERE tables.name = 'Test_Table_II')
DROP TABLE [Private].[Test_Table_II]

CREATE TABLE [Private].[Test_Table_II](
	[tbl_pkid] [int] IDENTITY(1,1) NOT NULL,
	[tbl_fk_tbl_pkid] [int] NOT NULL,
	[tbl_random_string_and_int] [nvarchar](75) NOT NULL,
	[tbl_create_date] [datetime] NOT NULL,

PRIMARY KEY CLUSTERED 
(	[tbl_pkid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY])

----------------------------------------------------------------------------
--  A unique non-clustered (index) can be created inline with the table
--  or it can be added with an alter statement as an index or constraint.
--  The result is the same - it is an index; however it ALSO becomes a key
----------------------------------------------------------------------------

/* Add a standard default date for a datestamp field */

ALTER TABLE [Private].[Test_Table_II] ADD  DEFAULT (getdate()) FOR [tbl_create_date]
GO

/* Add a simple one column check constraint - All tbl_create_date values should be on or after 1/1/1900 */

ALTER TABLE [Private].[Test_Table_II]  WITH CHECK ADD CHECK  (([tbl_create_date]>='1/1/1900'))
GO

/* Add a multi-column check constraint - Essentially the value to be inserted to the column tbl_random_string_and_int must have an alpha character proceded by an integer value. */

ALTER TABLE [Private].[Test_Table_II]  WITH CHECK ADD CONSTRAINT [chk_rsk_II] CHECK  ((patindex('%[a-zA-Z]%',[tbl_random_string_and_int])>(0) AND patindex('%[0=9]%', [tbl_random_string_and_int])>(0)))
GO

/* Add a foreign key to the table that references Test_Table - Ensures the integrity of key values between Test_Table and Test_Table_II */

ALTER TABLE [Private].[Test_Table_II]  WITH CHECK ADD  CONSTRAINT [Test_Table_II_FK_Test_Table_ID] FOREIGN KEY([tbl_fk_tbl_pkid])
REFERENCES [Private].[Test_Table] ([tbl_pkid])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

-----------------------------------------------------------------------------
--  Use the object explorer to review the Columns, Keys, Constraints, 
--	and Indexes nodes under the object Test_Table_II.
--
--	Although defined as constraints, you will see that a foreign key
--  ONLY appears as a "key" type of object. It's constraint applies
--  to TWO tables - it prevents the constrained column from permitting
--  NULL values by default, and also puts a system trigger on the
--  referenced table that prohibits delete and truncate statements
--  without properly cascading the delete or update operation into this table.  
-----------------------------------------------------------------------------

/* Enter a clean record into Test_Table which would violate the constraints in Test_Table_II for testing */

INSERT INTO Private.Test_Table (tbl_random_string, tbl_create_date)
SELECT 'Faioath', '7/22/2012'

INSERT INTO Private.Test_Table (tbl_random_string, tbl_random_int, tbl_create_date)
SELECT 'LoghatTH', '01591', '1/1/1890'

----------------------------------------------------------------------------
--  These values pass all constraints and validations placed on Test_Table
--  They *should* violate 2 constraints in Test_Table_II and be rejected
----------------------------------------------------------------------------

/* Enter a clean record into the table - use values from Test_Table */

INSERT INTO Private.Test_Table_II (tbl_fk_tbl_pkid, tbl_random_string_and_int, tbl_create_date)

SELECT tbl_pkid, tbl_random_string+ISNULL(CAST(tbl_random_int AS VARCHAR),''), tbl_create_date
FROM Private.Test_Table
WHERE tbl_create_date > '1/1/1900'

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--	An error statement should occur:
--  The INSERT statement conflicted with the CHECK constraint "chk_rsk_II". The conflict occurred in database "testdb", table "Private.Test_Table_II", column 'tbl_random_string_and_int'.
--	This means that some value contains a null, or is blank. Notice that the last row contains Faioath, but has no integer component.
--	A system trigger on the column performs the following check:
--
--		(patindex('%[a-zA-Z]%',[tbl_random_string_and_int])>(0) AND patindex('%[0=9]%', [tbl_random_string_and_int])>(0))
--
--	This essentially requires that the column have an alpha character proceded by an integer. The use of 
--
--		ISNULL(CAST(tbl_random_int AS VARCHAR),'')
--
--	is creating a blank when an integer is required.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* Try replacing the string+Integer statement as follows and run the statement again - what happens? */

INSERT INTO Private.Test_Table_II (tbl_fk_tbl_pkid, tbl_random_string_and_int, tbl_create_date)

SELECT tbl_pkid, tbl_random_string+CAST(ISNULL(tbl_random_int,'') AS VARCHAR), tbl_create_date
FROM Private.Test_Table
WHERE tbl_create_date > '1/1/1900'

-----------------------------------------------------------------------------------------------------------------------------------------------------------
--  You SHOULD observe that the last row appears to meet the constraint for the column. Notice that casting an integer column to blank results in a 0.
--	The difference is in where the opperation of deriving the value 0 from the NULL occurs within the statement. Casting a NULL into a VARCHAR is treated
--	Differently than casting a NULL into an integer and then to a varchar!
---------------------------------------------------------------------------------------------------------------------------------------------------------

/* Test a simple date constraint */

INSERT INTO Private.Test_Table_II (tbl_fk_tbl_pkid, tbl_random_string_and_int, tbl_create_date)

SELECT tbl_pkid, tbl_random_string+CAST(tbl_random_int AS VARCHAR), tbl_create_date
FROM Private.Test_Table
WHERE tbl_create_date < '1/1/1900'

-----------------------------------------------------------------------------------------------
--	In this case the indicated create date precedes the valid date of entry by some 10 years.
-----------------------------------------------------------------------------------------------

/* Test a NULL constraint */

INSERT INTO Private.Test_Table_II (tbl_fk_tbl_pkid, tbl_random_string_and_int, tbl_create_date)

SELECT TOP 1 NULL, tbl_random_string+CAST(tbl_random_int AS VARCHAR), tbl_create_date
FROM Private.Test_Table
WHERE tbl_random_int IS NOT NULL
AND tbl_create_date >= '1/1/1900'

--------------------------------------------------------------------
---	The error indicates that inserting a NULL value is not allowed.
--	In this case the foreign key enforces this constraint implicitly.
--------------------------------------------------------------------


/* Add a Unique Constraint to ensure that duplicate keys cannot be inserted
	Try inserting these records again to test the UNIQUE constraint */

ALTER TABLE [Private].[Test_Table_II] ADD CONSTRAINT [ck_unc_test_table_II_K2] UNIQUE ([tbl_random_string_and_int])
GO

INSERT INTO Private.Test_Table_II (tbl_fk_tbl_pkid, tbl_random_string_and_int, tbl_create_date)

SELECT TOP 1 tbl_pkid, tbl_random_string+CAST(tbl_random_int AS VARCHAR), tbl_create_date
FROM Private.Test_Table
WHERE tbl_random_int IS NOT NULL
AND tbl_create_date >= '1/1/1900'

---------------------------------------------------------------------------------------
--	If values in table must be unique there are two methods to ensure this.
--	Use an identity as specified in the table definition for the tbl_pkid fields
--	or a special type of index called a unique constraint.
--
--	Typically a primary key will be a unique clustered index. There are cases
--	where this is not always sufficient. Consider a primary key on natural business
--	keys such as program name, department, and region. It may be required as part of
--	business logic that this is the defacto primary key of the data, but it is clumsy
--	so a proxy key might derived and used which is easier throughout the data model.
--	This will be used as a foriegn key and will need a unique index on it
--
--	Multiple unique indexes can exist on a table, but only one index on a table can
--	be clustered. In such cases it is generally okay to use the actual column-set 
--	that should be physically sorted as the primary key.
--
---------------------------------------------------------------------------------------


SELECT *
FROM Private.Test_Table_II

SELECT *
FROM Private.Test_Table



