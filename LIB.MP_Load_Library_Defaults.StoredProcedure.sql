USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[MP_Load_Library_Defaults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [LIB].[MP_Load_Library_Defaults]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LIB].[MP_Load_Library_Defaults]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [LIB].[MP_Load_Library_Defaults]
AS

/* Initialize Version_Stamp schemas collection
	20150820 - Many portions of this procedure could be replicated by file import. Consider this the minimal required
		pre-loading for the Library functions to work. This code should be retained so long as 2008 and 2005 databases
		are viable targets.

	20140505 - This is currently uncertain work, designed as a prototype code template source.
		Its intent is to provide a standard script to capture and currate files based on type using AI rules.
		The template script will beceome a secured record accessible to the AI job process that asssesses source curration.
		As of this notation date it is retained as a sample, but should not be deployed as normal code.
		See view [Management].[LIB].[VI_Version_Stamp_Reference] for a listing of topics and filings for this process.


set identity_Insert LIB.DOC_Version_Stamp_Schemas on

INSERT INTO LIB.DOC_Version_Stamp_Schemas (SchemaID, ParentID, Value, Description)
SELECT 0, 0, ''ADHOC'', ''Adhoc insert/update Identifier Template.'' 
UNION
SELECT 1, 0, ''CAT'', ''Catalog Event Identifier Template''
UNION
SELECT 2, 0, ''LIB'', ''Library Event Identifier Template''
UNION
SELECT 3, 0, ''DOC'', ''Document Event Identifier Template''

set identity_Insert LIB.DOC_Version_Stamp_Schemas off


INSERT INTO LIB.DOC_Version_Stamp_Schemas (ParentID, Value, Description)
SELECT 0, ''ADLIB'', ''Basic Library Template: <Code> --''''ADLIB<Target =:>''''+{REG_0204_ID}+''''.''''+{REG_0300_ID}+''''</Target><Date =:>getdate()</Date><Agent=:>{suser_ID()}<>''''''
UNION
SELECT 0, ''ADCAT'', ''Unregistered Catalog Event Identifier Template --''''ADCAT<Target =:>''''+{REG_0204_ID}+''''.''''+{REG_0300_ID}+''''</Target><Date =:>getdate()</Date><Agent=:>{suser_ID()}</Agent>''''''
UNION
SELECT 2, ''TSQLLIB'', ''TSQL Module Intake Stack Identifier Template -- <TEMPLATE COMPLETE>''
UNION
SELECT 1, ''TSQLCAT'', ''TSQL Event Identifier from Catalog analysis procedures --''''<Job>{jobid}</Job><Sequence>{seqid}</Sequence><Post_Date>getdate()</Post_Date><Target>{REG_0300_ID}</Target><Status>[tinyint]</status>''''''



!!!! 20150106:4est - These objects and methods are no longer supported. The concept of deriving a standard dynamic template to automatically generate improved code is worth keeping as an idea for future implementation.
		Retain these notes until the templating phase of development is functional.
 */


/* Initialize GLOBAL collection */

set identity_Insert LIB.REG_Collections on

insert into LIB.REG_Collections (Collection_ID, Name, Description, Curator, Post_Date)
select 0, ''Global'',''Library Global collection aggregates select basic metrics across its entire inventory.'', ''Default'', getdate()

set identity_Insert LIB.REG_Collections off

insert into LIB.REG_Collections (Name, Description, Curator)

select ''Catalog'', ''Registered structures, logic, data, metrics and resources of the datawarehouse.'',''Job Catalog Process''
	union
	select ''Foreign Databases'', ''Databases and objects from foreign servers or unknown sources'', ''Manual or Import Process''
	union
	select ''System Databases'', ''System databases or system objects distributed into user databases'', ''Job Catalog Process''
	union
	select ''User Databases'', ''User or Non-OEM Databases related to a collection.'', ''Job Catalog Process''
	union
	select ''File System'', ''User or Non-OEM Databases related to a collection.'', ''Environment Scan''
	union
		select ''Structures'', ''A collection of architecture for all objects in the datawarehouse.'',''Job Catalog Process''
	union
		select ''Code'', ''A collection of all procedural code found in the Datawarehouse and/or Business Intelligence system.'',''Job Catalog Process''
		union
			select ''TSQL'', ''A collection of procedural TSQL found in the Datawarehouse and/or Business Intelligence system.'',''Job Catalog Process''
				union
				select ''[.sql]'',''A SQL script file saved on the file system. May contain DML or DDL language such as table or view definitions, procedures, fucntions or ad-hoc user queries'',''Environment Scan''
				union
				select ''[.ssmssln]'',''A SQL Server project file (SQL Server 2008+) in XML format.'',''Environment Scan''
			union
			select ''XML'', ''A collection of procedural XML found in the Datawarehouse and/or Business Intelligence system.'',''Job Catalog Process''
				union
				select ''[.xml]'',''A generic XML format file with unknown node structure or content.'',''Adhoc''
			union
			select ''VB.NET'', ''A collection of procedural Visual Basic found in the Datawarehouse and/or Business Intelligence system.'',''Job Catalog Process''
			union
			select ''CSS/CPP'', ''A collection of procedural Visual C# and C++ found in the Datawarehouse and/or Business Intelligence system.'',''Job Catalog Process''
			union
				select ''[.cpp]'',''A C++ program file.'',''Adhoc''
				union
				select ''[.css]'',''A C# program file.'',''Adhoc''
			union
			select ''SSRS'', ''A collection of TSQL Server Reporting Services report templates found in the DHHA Business Intelligence system.'',''Job Catalog Process''
				union
				select ''[.rdl]'',''An Reporting Services file in XML format - contains definitions and logic for SSRS Reports.'',''Environment Scan''
			union
			select ''SSIS'', ''A collection of TSQL Server Integration Services data transformation packages found in the Datawarehouse and/or Business Intelligence system.'',''Job Catalog Process''
				union
				select ''[.dtsx]'',''An Integration Services "Package" in XML format - contains all tasks and logic for an ETL opperation'',''Job Catalog Process''
				union
				select ''[.conmgr]'',''An Integration Services connection manager in XML format - contains all tasks and logic for an ETL opperation'',''Job Catalog Process''
				union
				select ''[.dtproj]'',''An Integration Services project file in XML format - contains all details of package files included in a project'',''Job Catalog Process''
				union
				select ''[.params]'',''An Integration Services parameter file in XML format - contains all project parameters and default values'',''Job Catalog Process''
				union
				select ''[.user]'',''An Integration Services user settings file in XML format - contains all user variable settings for an instance of the VS Shell'',''Job Catalog Process''
			union
			select ''SSAS'', ''A collection of TSQL Server Analysis Services queries found in the Datawarehouse and/or Business Intelligence system.'',''Job Catalog Process''
			union
			select ''SAS'', ''A collection of Statistical Analysis System code found in the Datawarehouse and/or Business Intelligence system.'',''Job Catalog Process''
	union
		select ''Content'', ''A collection of data metrics, and context tags for all data collections in the Datawarehouse.'',''Job Catalog Process''
		union
			select ''Values'', ''Collection of select, unique data values present in a collection - Low value data (determined by class, quality, quantity, etc.), system object values typically omitted.'', ''Job Catalog Process''
			union
			select ''Reporting'', ''A collection of reporting topics, templates, and statistics found in the DHHA Business Intelligence system.'',''Job Catalog Process''
			union
				select ''Crystal'', ''A collection of Crystal Reports templates associated with a collection'',''Adhoc''
					union 
					select ''[.rpt]'',''A Crystal Reports output file (many file type associated with reports use this).'',''Adhoc''
				union					
				select ''Excel'', ''A collection of Excel workbooks used as sources or reports.'',''Adhoc''
					union
					select ''[.xls]'', ''An Excel 97 - 2003 workbook'',''Adhoc''
					union
					select ''[.xlsx]'', ''An Excel 2007+ workbook'',''Adhoc''
				union
				select ''Power Pivot'', ''A collection of Power Pivot reports utilized in sharepoint to illustrate aggregate data.'',''Adhoc''
				union
				select ''Sharepoint'', ''A collection of Sharepoint lists used for reporting from operational datastores'',''Adhoc''
				union
				select ''Access DBs'', ''A collection of Access databases used for reporting, or data sampling.'',''Adhoc''
					union
					select ''[.mdb]'', ''An Access 97 - 2003 database file.'',''Adhoc''
					union
					select ''[.accdb]'', ''An Access 2007+ database file.'',''Adhoc''
union
select ''Languages'', ''A collection of printed, natural/spoken language and code-based languages found in the Datawarehouse and/or Business Intelligence system.'',''Job Catalog Process''
union 
	select ''English'', ''Most common spoken language of the business and aviation world. Dialects exist and may be required for translatin/differentiation in some regions.'',''Adhoc''
union
select ''Documents'', ''Formal collections of textual information - typically natural language sourced - related to a collection.'',''Adhoc''
	union
	select ''[.txt]'',''Basic text document - likely in ASCII encoding.'',''Adhoc''
	union
	select ''[.readme]'',''Usually a text document with instructions or notes about files in a direcotory - likely in ASCII encoding.'',''Adhoc''
	union
	select ''[.pdf]'',''Adobe "Portable Document Format" image file.'',''Binary Stream''
	union
	select ''[.gif]'',''Traditional image file. Essentially produces pixel plot of RGB scale.'',''Binary Stream''
	union
	select ''[.jpeg]'',''A lossy image file format used for photography and higher quality images'',''Binary Stream''

insert into LIB.HSH_Collection_Heirarchy (DURLFlag, rk_Collection_ID, fk_Collection_ID)

select 0, 0, Collection_ID
from LIB.REG_Collections as clt
where clt.name in (''Catalog'',''Languages'',''Documents'')
union
select 0, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = ''Catalog''
and clt2.name in (''Foreign Databases'',''System Databases'',''User Databases'')
union
select 0, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name in (''Foreign Databases'',''System Databases'',''User Databases'')
and clt2.name in (''Structures'',''Code'',''Content'')
union
select 0, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = ''Code''
and clt2.name in (''TSQL'',''XML'',''VB.NET'',''CSS/CPP'',''SSRS'',''SSIS'',''SSAS'',''SAS'')
union
select 1, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = ''TSQL''
and clt2.name in (''[.sql]'',''[.ssmssln]'')
union
select 1, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = ''CSS/CPP''
and clt2.name in (''[.cpp]'',''[.css]'')
union
select 1, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = ''SSIS''
and clt2.name in (''[.conmgr]'',''[.dtproj]'',''[.dtsx]'',''[.params]'',''[.user]'')
union
select 1, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = ''SSRS''
and clt2.name in (''[.rdl]'')
union
select 0, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = ''XML''
and clt2.name in (''[.rdl]'',''[.conmgr]'',''[.dtproj]'',''[.dtsx]'',''[.params]'',''[.user]'',''[.xml]'',''[.ssmssln]'')
union
select 0, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = ''File System''
and clt2.name in (''[.rdl]'',''[.conmgr]'',''[.dtproj]'',''[.dtsx]'',''[.params]'',''[.user]'',''[.txt]'',''[.xml]'',''[.xls]'',''[.xlsx]'',''[.mdb]'',''[.accdb]'',''[.sql]'',''[.rpt]'',''[.ssmssln]'')
union
select 0, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = ''Content''
and clt2.name in (''Values'',''Reporting'')
union
select 0, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = ''Reporting''
and clt2.name in (''Crystal'',''Excel'',''Power Pivot'',''Sharepoint'',''Access DBs'')
union
select 1, clt1.Collection_ID, clt2.Collection_ID
from LIB.REG_Collections as clt1
cross apply LIB.REG_Collections as clt2
where clt1.Name = ''Reporting''
and clt2.name in (''SSRS'',''SAS'')


/* Insert initial contextual link between DWMgmt and UserDatabases */
INSERT INTO LIB.REG_Collections (Name, Description, Curator)
SELECT ''DWMgmt'', ''An alternative TSQL Data Warehouse Management collection of structure, logic, and content'', ''Adhoc''

INSERT INTO LIB.HSH_Collection_Heirarchy (fk_Collection_ID, rk_Collection_ID, DURLFlag)
SELECT (SELECT Collection_ID FROM LIB.REG_Collections WHERE name = ''DWMgmt''), (SELECT Collection_ID FROM LIB.REG_Collections WHERE name = ''User Databases''), 0

/* Initialize standard ASCII alphabet set - Character value 0 - NULL not permitted. */

insert into LIB.REG_Alphabet (ASCII_Char, Char_Val, Printable)
select 0,'''',0

declare @i smallint = 1

while @i <= 255
begin

	insert into LIB.REG_Alphabet (ASCII_Char, Char_Val)
	select @i, char(@i)

set @i = @i + 1

end


UPDATE LIB.REG_Alphabet SET Printable = 1
FROM LIB.REG_Alphabet AS lib
WHERE ASCII_Char IN (0,1,9,10,11,12,13,28,29,30,31,129,143,144,157,160)



/* Initialize Glyphs */

set identity_Insert LIB.REG_Glyphs on
		insert into LIB.REG_Glyphs (Glyph_ID, ASCII_Char1, ASCII_Char2)
		select 0,0,0
set identity_Insert LIB.REG_Glyphs off



declare @i1 smallint = 1
, @i2 smallint = 1

while @i1 <= 255
begin
	if @i1 IN (1,9,10,11,12,13,28,29,30,31,129,143,144,157,160) goto skip1
	while @i2 <= 255
	begin
		if @i2 IN (1,9,10,11,12,13,28,29,30,31,129,143,144,157,160) goto skip2
		insert into LIB.REG_Glyphs (ASCII_Char1, ASCII_Char2)
		select @i1, @i2

		if @i2 = 255 goto skip1

		skip2:
		set @i2 = @i2 + 1
	end

skip1:
	
if @i1 = 255 goto glyphend
set @i2 = 1
set @i1 = @i1+1
end

glyphend:


/* TSQL Code Control Words with Dynarameters!

Disabled prior to 20140630. DOC_Code_Control_Words is a library item identifying
control words used in various sources of code. This concept is still valid as a 
test vehicle for AI based code detection. The following routine loaded most primary
and secondary MSTSQL seed words. The concept is not well developed however and in its
present use and format could be accomplished more efficiently by actual full-text indexes.

Retain this as prototype notes until the implementation of full-text indexes is complete.

DECLARE @Collection_ID TINYINT 
SELECT @Collection_ID = Collection_ID
FROM LIB.REG_Collections
WHERE Name = ''TSQL''

INSERT INTO LIB.DOC_Code_Control_Words (Collection_ID, WordID, Word, Category)
SELECT @Collection_ID, 0, ''¶'', ''Lines''
UNION
SELECT @Collection_ID, 0, ''--'', ''Comments''
UNION
SELECT @Collection_ID, 0, ''/*'', ''Comments''
UNION
SELECT @Collection_ID, 0, ''*/'', ''Comments''
UNION
SELECT @Collection_ID, 0, ''('', ''Markup''
UNION
SELECT @Collection_ID, 0, '')'', ''Markup''
UNION
SELECT @Collection_ID, 0, ''['', ''Markup''
UNION
SELECT @Collection_ID, 0, '']'', ''Markup''
UNION
SELECT @Collection_ID, 0, '')'', ''Markup''
UNION
SELECT @Collection_ID, 0, ''ALTER'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''APPLY'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''BACKUP'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''CREATE'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''DECLARE'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''DELETE'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''DROP'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''EXCEPT'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''EXEC'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''EXECUTE'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''FROM'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''GROUP'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''HAVING'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''IF'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''INTO'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''JOIN'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''OPTION'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''ORDER'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''PIVOT'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''PRINT'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''RESTORE'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''SELECT'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''SET'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''TRUNCATE'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''UNION'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''UPDATE'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''UNPIVOT'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''WHERE'', ''Primary''
UNION
SELECT @Collection_ID, 0, ''ADD'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''AUTHORIZATION'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''BEGIN'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''BREAK'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''BROWSE'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''CASCADE'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''CASE'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''CHECK'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''CLOSE'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''COALESCE'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''COLLATE'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''COMMIT'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''COMPUTE'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''CONTINUE'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''CONVERT'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''DEALLOCATE'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''DENY'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''DISTINCT'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''DISTRIBUTED'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''ELSE'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''END'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''EXIT'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''FETCH'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''GOTO'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''GRANT'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''HOLDLOCK'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''INSERT'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''KILL'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''OPEN'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''RANK'', ''Secondary''
UNION
SELECT @Collection_ID, 0, ''DATABASE'', ''Objects''
UNION
SELECT @Collection_ID, 0, ''COLUMN'', ''Objects''
UNION
SELECT @Collection_ID, 0, ''CURSOR'', ''Objects''
UNION
SELECT @Collection_ID, 0, ''FUNCTION'', ''Objects''
UNION
SELECT @Collection_ID, 0, ''INDEX'', ''Objects''
UNION
SELECT @Collection_ID, 0, ''KEY'', ''Objects''
UNION
SELECT @Collection_ID, 0, ''PROCEDURE'', ''Objects''
UNION
SELECT @Collection_ID, 0, ''SCHEMA'', ''Objects''
UNION
SELECT @Collection_ID, 0, ''TABLE'', ''Objects''
UNION
SELECT @Collection_ID, 0, ''TRIGGER'', ''Objects''
UNION
SELECT @Collection_ID, 0, ''VALUES'', ''Objects''
UNION
SELECT @Collection_ID, 0, ''VIEW'', ''Objects''
UNION
SELECT @Collection_ID, 0, ''ALL'', ''State''
UNION
SELECT @Collection_ID, 0, ''AND'', ''State''
UNION
SELECT @Collection_ID, 0, ''ANY'', ''State''
UNION
SELECT @Collection_ID, 0, ''AS'', ''State''
UNION
SELECT @Collection_ID, 0, ''ASC'', ''State''
UNION
SELECT @Collection_ID, 0, ''BETWEEN'', ''State''
UNION
SELECT @Collection_ID, 0, ''BY'', ''State''
UNION
SELECT @Collection_ID, 0, ''CLUSTERED'', ''State''
UNION
SELECT @Collection_ID, 0, ''CONTAINS'', ''State''
UNION
SELECT @Collection_ID, 0, ''CROSS'', ''State''
UNION
SELECT @Collection_ID, 0, ''DEFAULT'', ''State''
UNION
SELECT @Collection_ID, 0, ''DESC'', ''State''
UNION
SELECT @Collection_ID, 0, ''EXISTS'', ''State''
UNION
SELECT @Collection_ID, 0, ''FOR'', ''State''
UNION
SELECT @Collection_ID, 0, ''FOREIGN'', ''State''
UNION
SELECT @Collection_ID, 0, ''FULL'', ''State''
UNION
SELECT @Collection_ID, 0, ''IN'', ''State''
UNION
SELECT @Collection_ID, 0, ''INNER'', ''State''
UNION
SELECT @Collection_ID, 0, ''IS'', ''State''
UNION
SELECT @Collection_ID, 0, ''LEFT'', ''State''
UNION
SELECT @Collection_ID, 0, ''LIKE'', ''State''
UNION
SELECT @Collection_ID, 0, ''NOT'', ''State''
UNION
SELECT @Collection_ID, 0, ''NULL'', ''State''
UNION
SELECT @Collection_ID, 0, ''OF'', ''State''
UNION
SELECT @Collection_ID, 0, ''OFF'', ''State''
UNION
SELECT @Collection_ID, 0, ''ON'', ''State''
UNION
SELECT @Collection_ID, 0, ''RIGHT'', ''State''
UNION
SELECT @Collection_ID, 0, ''FULL'', ''State''
UNION
SELECT @Collection_ID, 0, ''OVER'', ''State''
UNION
SELECT @Collection_ID, 0, ''THEN'', ''State''
UNION
SELECT @Collection_ID, 0, ''TOP'', ''State''
UNION
SELECT @Collection_ID, 0, ''WHILE'', ''State''
UNION
SELECT @Collection_ID, 0, ''WHEN'', ''State''


*/

' 
END
GO
