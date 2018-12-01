/******************************************
Copyright 2014 Brent Ozar PLF, LLC (DBA Brent Ozar Unlimited)
*******************************************/

/*  Script:         20_waitstats.sql 

    Run as a:       WHOLE SCRIPT (Just F5 it!)

    Impact:         LIGHT (Will not block -- fire away!)

    Contains:       Server uptime and signal waits
                    Wait stats since last clear
                    Wait stats over 30-second sample

    Description:    SQL Server Wait Information from sys.dm_os_wait_stats
                    Run all at once. Takes 30 seconds, produces 3 result sets, doesn't block anything.
                    1st result set: server uptime.
                    2nd result set: wait stats since SQL restarted (or since they were manually cleared)
                    3rd result set: wait stats over a 30-second sample.

                    Queries in this file were written by Brent Ozar PLF, 2012.

                    Community references for waits:
                    sys.dm_os_wait_stats Books Online: http://msdn.microsoft.com/en-us/library/ms179984(v=sql.105).aspx
                    Microsoft PSS Wait Type Repository: http://blogs.msdn.com/b/psssql/archive/2009/11/03/the-sql-server-wait-type-repository.aspx
                    Service Broker Wait Types Explained: http://blogs.msdn.com/b/sql_service_broker/archive/2008/12/01/service-broker-wait-types.aspx
                    Technet Magazine, "SQL Server: SQL Server Delays Demystified" http://technet.microsoft.com/en-us/magazine/hh781189.aspx
*/

/* --------------------------------------------- */
/* BEGIN SECTION: Server uptime and signal waits */
/* --------------------------------------------- */

    /********************************* 
    How long has SQL Server been up?
    How much do we wait on signal overall?
    *********************************/
    IF OBJECT_ID('tempdb..#uptime') IS NULL
        CREATE TABLE #uptime
        (
            percent_signal_waits DECIMAL(10, 0) NOT NULL ,
            hours_since_startup INT NOT NULL ,
            days_since_startup DECIMAL (20, 1) NOT NULL ,
            cpu_hours BIGINT NOT NULL ,
            ms_since_startup DECIMAL(38,0) NOT NULL ,
            cpu_ms_since_startup DECIMAL(38,0) NOT NULL
        );
    
    TRUNCATE TABLE #uptime ;

    WITH cpu_count AS (
        SELECT cpu_count
        FROM sys.dm_os_sys_info
    ), 
    overall_waits AS (
        SELECT  cast(100* SUM(CAST(signal_wait_time_ms AS NUMERIC(20,1)))
                 / SUM(wait_time_ms) AS NUMERIC(10,0)) AS percent_signal_waits
        FROM    sys.dm_os_wait_stats os),
    uptime AS (
        SELECT  DATEDIFF(HH, create_date, CURRENT_TIMESTAMP) AS hours_since_startup
        FROM    sys.databases
        WHERE   name='tempdb'
    )
    INSERT INTO #uptime
    SELECT  percent_signal_waits,
            hours_since_startup,
            CAST(hours_since_startup / 24. AS NUMERIC(20,1)) AS days_since_startup, 
            hours_since_startup * cpu_count AS cpu_hours, 
            CAST(hours_since_startup AS DECIMAL(38,0)) * 3600000 AS ms_since_startup,
            CAST(hours_since_startup AS DECIMAL(38,0)) * 3600000 * cpu_count AS cpu_ms_since_startup
    FROM    overall_waits, uptime, cpu_count;

    SELECT  percent_signal_waits ,
            hours_since_startup ,
            days_since_startup
    FROM    #uptime ;
    GO


/* ------------------------------------------- */
/* END SECTION: Server uptime and signal waits */
/* ------------------------------------------- */


/* ------------------------------------------ */
/* BEGIN SECTION: Wait stats since last clear */
/* ------------------------------------------ */

    /********************************* 
    Let's build a list of waits we can safely ignore.
    *********************************/
    IF OBJECT_ID('tempdb..#ignorable_waits') IS NOT NULL 
        DROP TABLE #ignorable_waits;
    GO

    create table #ignorable_waits (wait_type nvarchar(256) PRIMARY KEY);
    GO

    /* We aren't usign row constructors to be SQL 2005 compatible */
    SET NOCOUNT ON;
    INSERT #ignorable_waits (wait_type) VALUES ('REQUEST_FOR_DEADLOCK_SEARCH');
    INSERT #ignorable_waits (wait_type) VALUES ('SQLTRACE_INCREMENTAL_FLUSH_SLEEP');
    INSERT #ignorable_waits (wait_type) VALUES ('SQLTRACE_BUFFER_FLUSH');
    INSERT #ignorable_waits (wait_type) VALUES ('LAZYWRITER_SLEEP');
    INSERT #ignorable_waits (wait_type) VALUES ('XE_TIMER_EVENT');
    INSERT #ignorable_waits (wait_type) VALUES ('XE_DISPATCHER_WAIT');
    INSERT #ignorable_waits (wait_type) VALUES ('FT_IFTS_SCHEDULER_IDLE_WAIT');
    INSERT #ignorable_waits (wait_type) VALUES ('LOGMGR_QUEUE');
    INSERT #ignorable_waits (wait_type) VALUES ('CHECKPOINT_QUEUE');
    INSERT #ignorable_waits (wait_type) VALUES ('BROKER_TO_FLUSH');
    INSERT #ignorable_waits (wait_type) VALUES ('BROKER_TASK_STOP');
    INSERT #ignorable_waits (wait_type) VALUES ('BROKER_EVENTHANDLER');
    INSERT #ignorable_waits (wait_type) VALUES ('BROKER_TRANSMITTER');
    INSERT #ignorable_waits (wait_type) VALUES ('SLEEP_TASK');
    INSERT #ignorable_waits (wait_type) VALUES ('WAITFOR');
    INSERT #ignorable_waits (wait_type) VALUES ('DBMIRROR_DBM_MUTEX')
    INSERT #ignorable_waits (wait_type) VALUES ('DBMIRROR_EVENTS_QUEUE')
    INSERT #ignorable_waits (wait_type) VALUES ('DBMIRRORING_CMD');
    INSERT #ignorable_waits (wait_type) VALUES ('DISPATCHER_QUEUE_SEMAPHORE');
    INSERT #ignorable_waits (wait_type) VALUES ('BROKER_RECEIVE_WAITFOR');
    INSERT #ignorable_waits (wait_type) VALUES ('CLR_AUTO_EVENT');
    INSERT #ignorable_waits (wait_type) VALUES ('DIRTY_PAGE_POLL');
    INSERT #ignorable_waits (wait_type) VALUES ('HADR_FILESTREAM_IOMGR_IOCOMPLETION');
    INSERT #ignorable_waits (wait_type) VALUES ('ONDEMAND_TASK_QUEUE');
    INSERT #ignorable_waits (wait_type) VALUES ('FT_IFTSHC_MUTEX');
    INSERT #ignorable_waits (wait_type) VALUES ('CLR_MANUAL_EVENT');
    INSERT #ignorable_waits (wait_type) VALUES ('SP_SERVER_DIAGNOSTICS_SLEEP');
    INSERT #ignorable_waits (wait_type) VALUES ('CLR_SEMAPHORE');
    INSERT #ignorable_waits (wait_type) VALUES ('DBMIRROR_WORKER_QUEUE');
    INSERT #ignorable_waits (wait_type) VALUES ('DBMIRROR_DBM_EVENT');
    GO

    /* Want to manually exclude an event and recalculate?*/
    /* insert #ignorable_waits (wait_type) VALUES (''); */


    /********************************* 
    What are the highest overall waits since startup? 
    What is the sum_wait_time_ms compared to the cpu_ms_since_startup? 
    *********************************/
    DECLARE @cpu_ms_since_startup DECIMAL (38, 0);
    SELECT  @cpu_ms_since_startup = cpu_ms_since_startup
    FROM    #uptime ;

    SELECT  TOP 25
            os.wait_type, 
            SUM(os.wait_time_ms / 1000.0 / 60 / 60) OVER (PARTITION BY os.wait_type) as sum_wait_time_hours,
            100.0 * (SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type) / @cpu_ms_since_startup) AS percent_actual_cpu_time ,
            CAST(
                100.* SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type) 
                / (1. * SUM(os.wait_time_ms) OVER () )
                AS NUMERIC(10,1)) AS pct_wait_time,
            CAST(
                100. * SUM(os.signal_wait_time_ms) OVER (PARTITION BY os.wait_type) 
                / (1. * SUM(os.wait_time_ms) OVER ())
                AS NUMERIC(10,1)) AS pct_signal_wait,
            SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type) AS sum_waiting_tasks,
            CASE WHEN  SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type) > 0
            THEN
                CAST(
                    SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type)
                        / (1. * SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type)) 
                    AS NUMERIC(10,1))
            ELSE 0 END AS avg_wait_time_ms,

            CURRENT_TIMESTAMP AS sample_time
    FROM    sys.dm_os_wait_stats os
            LEFT JOIN #ignorable_waits iw on os.wait_type=iw.wait_type
    WHERE   iw.wait_type IS NULL
    ORDER BY sum_wait_time_hours DESC;
    GO

/* ------------------------------------------ */
/* END SECTION: Wait stats since last clear */
/* ------------------------------------------ */


/* ----------------------------------------------- */
/* BEGIN SECTION: Wait stats over 30-second sample */
/* ----------------------------------------------- */

    /********************************* 
    What are the highest waits *right now*? 
    *********************************/

    

    /* Note: this is dependent on the #ignorable_waits table created earlier. */
    IF OBJECT_ID('tempdb..#wait_batches') IS NOT NULL
        DROP TABLE #wait_batches;
    IF OBJECT_ID('tempdb..#wait_data') IS NOT NULL
        DROP TABLE #wait_data;
    GO


    CREATE TABLE #wait_batches (
        batch_id INT IDENTITY (1,1) PRIMARY KEY,
        sample_time datetime NOT NULL
    );

    CREATE TABLE #wait_data ( 
        batch_id INT NOT NULL ,
        wait_type NVARCHAR(256) NOT NULL ,
        wait_time_ms BIGINT NOT NULL ,
        waiting_tasks BIGINT NOT NULL
    );

    CREATE CLUSTERED INDEX cx_wait_data ON #wait_data(batch_id);
    GO

    /* 
    This temporary procedure records wait data to a temp table.
    */
    IF OBJECT_ID('tempdb..#get_wait_data') IS NOT NULL
        DROP procedure #get_wait_data;
    GO

    CREATE PROCEDURE #get_wait_data
        @intervals tinyint = 2,
        @delay char(12)='00:00:30.000' /* 30 seconds*/
    AS  
    DECLARE @batch_id int,
        @current_interval tinyint,
        @msg nvarchar(max);

    SET NOCOUNT ON;
    SET @current_interval=1;

    WHILE @current_interval <= @intervals
    BEGIN
        INSERT #wait_batches(sample_time)
        SELECT CURRENT_TIMESTAMP;

        SELECT @batch_id=SCOPE_IDENTITY();


        INSERT  #wait_data (batch_id, wait_type, wait_time_ms, waiting_tasks)
        SELECT  @batch_id,
                os.wait_type, 
                SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type) AS sum_wait_time_ms, 
                SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type) AS sum_waiting_tasks
        FROM    sys.dm_os_wait_stats os
                LEFT JOIN #ignorable_waits iw on  os.wait_type=iw.wait_type
        WHERE   iw.wait_type IS NULL
        ORDER BY sum_wait_time_ms DESC;

        SET @msg = CONVERT(char(23),CURRENT_TIMESTAMP,121)+ N': Completed sample ' 
                    + cast(@current_interval as nvarchar(4))
                    + N' of ' + cast(@intervals as nvarchar(4)) 
                    +  '.'

        RAISERROR (@msg,0,1) WITH NOWAIT;
    
        SET @current_interval=@current_interval+1;

        IF @current_interval <= @intervals
            WAITFOR DELAY @delay;
    END
    GO

    /* 
    Let's take two samples 30 seconds apart
    */
    exec #get_wait_data @intervals=2, @delay='00:00:30.000';
    GO


    /* 
    What were we waiting on?
    This query compares the most recent two samples.
    */
    with max_batch as (
        select top 1 batch_id, sample_time
        from #wait_batches
        order by batch_id desc
    )
    SELECT 
        b.sample_time as [Second Sample Time],
        datediff(ss,wb1.sample_time, b.sample_time) as [Sample Duration in Seconds],
        wd1.wait_type,
        cast((wd2.wait_time_ms-wd1.wait_time_ms)/1000. as numeric(10,1)) as [Wait Time (Seconds)],
        (wd2.waiting_tasks-wd1.waiting_tasks) AS [Number of Waits],
        CASE WHEN (wd2.waiting_tasks-wd1.waiting_tasks) > 0 
        THEN
            cast((wd2.wait_time_ms-wd1.wait_time_ms)/
                (1.0*(wd2.waiting_tasks-wd1.waiting_tasks)) as numeric(10,1))
        ELSE 0 END AS [Avg ms Per Wait]
    FROM  max_batch b
    JOIN #wait_data wd2 on
        wd2.batch_id=b.batch_id
    JOIN #wait_data wd1 on
        wd1.wait_type=wd2.wait_type AND
        wd2.batch_id - 1 = wd1.batch_id
    join #wait_batches wb1 on
        wd1.batch_id=wb1.batch_id
    WHERE (wd2.waiting_tasks-wd1.waiting_tasks) > 0
    ORDER BY [Wait Time (Seconds)] DESC;
    GO

/* --------------------------------------------- */
/* END SECTION: Wait stats over 30-second sample */
/* --------------------------------------------- */
