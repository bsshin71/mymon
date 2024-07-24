select OBJECT_SCHEMA as 'schema'
     , OBJECT_NAME   as 'table'
     , COUNT_STAR 
     , SUM_TIMER_WAIT/1000000000000 AS sum_timewait
     , AVG_TIMER_WAIT/1000000000000 AS avg_timewait
     , COUNT_READ
     , SUM_TIMER_READ/1000000000000 AS sum_timeread
     , AVG_TIMER_READ/1000000000000 AS avg_timeread
     , COUNT_WRITE
     , SUM_TIMER_WRITE/1000000000000 AS sum_timewrite
     , AVG_TIMER_WRITE/1000000000000 AS avg_timewrite
     , COUNT_FETCH
     , SUM_TIMER_FETCH/1000000000000 AS sum_timefetch
     , AVG_TIMER_FETCH/1000000000000 AS avg_timefetch
FROM performance_schema.table_io_waits_summary_by_table
where OBJECT_SCHEMA not in ('mysql','performance_schema','sys')
order by SUM_TIMER_WAIT desc limit 20;
