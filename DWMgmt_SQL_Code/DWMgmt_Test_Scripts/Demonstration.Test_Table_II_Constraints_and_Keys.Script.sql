USE TestDB
GO


CREATE TABLE [Private].[Test_Table](
	[tbl_pkid] [int] IDENTITY(1,1) NOT NULL,
	[tbl_random_string] [nvarchar](60) NULL,
	[tbl_random_int] [int] NULL,
	[tbl_create_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[tbl_pkid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
-------------------------------------------------------------------
--  A primary key is both an index and a constraint. It does not
--  NEED to be the default clustered index in a table - it could
--  be a column set, such as a name touple, but is generally fine
--  to utilize on an identity column as this performs faster
-------------------------------------------------------------------


/* create a default value for a date stamp field */
ALTER TABLE [Private].[Test_Table] ADD  DEFAULT (getdate()) FOR [tbl_create_date]
GO


/* create a unique index on two columns */
CREATE UNIQUE NONCLUSTERED INDEX [idx_unc_test_table_k2_k3] ON [Private].[Test_Table] 
(
	[tbl_random_string] ASC,
	[tbl_random_int] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/* create a unique constraint on one column */
ALTER TABLE [Private].[Test_Table] ADD CONSTRAINT [ck_unc_test_table_K2] UNIQUE ([tbl_random_string])
GO

------------------------------------------------------------
--  If you review the Indexes folder under the table in
--  object explorer, you will see that this is really just
--  another kind of index.
------------------------------------------------------------


/* create a first row of data */
insert into [Private].[Test_Table]  (tbl_random_string, tbl_random_int)
select 'ajaitoaft', '9301'


/* Test a unique 2 column index violation */
insert into [Private].[Test_Table]  (tbl_random_string, tbl_random_int)
select 'ajaitoaft', '9301' 

----------------------------------------------------------------------
--  This value set will violate one of the unique indexes, but an
--  error will be avoided due to the index option IGNORE_DUPES ON.
----------------------------------------------------------------------

/* Insert a clean row */
insert into [Private].[Test_Table]  (tbl_random_string, tbl_random_int)
select 'afaotacet', '93816'


/* Test a unique 1 column index violation - also known as a column unique constraint */
insert into [Private].[Test_Table]  (tbl_random_string, tbl_random_int)
select 'ajaitoaft', '9303' 

-------------------------------------------------------------------------------------
--  This value will violate one of the unique cosntraints and be explicitly refused.
--  This value create an error message and halt processing of any further records.
-------------------------------------------------------------------------------------


/* Insert another clean row */
insert into [Private].[Test_Table]  (tbl_random_string, tbl_random_int)
select 'alphamet', '10'


select * from [Private].[Test_Table] 

--------------------------------------------------------------------------------------
--  Notice that the tbl_pkid skips where indexes have refused duplicate values.
--  The only way to keep a "clean" key field is to self join the table values
--  and check for existing entries before attempting an insert, or by rolling back
--  a transaction.
--------------------------------------------------------------------------------------