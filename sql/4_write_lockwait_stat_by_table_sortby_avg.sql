select OBJECT_SCHEMA as 'schema'
     , OBJECT_NAME   as 'table'
     , COUNT_STAR 
     , SUM_TIMER_WAIT/1000000000000 AS sum_timewait
     , AVG_TIMER_WAIT/1000000000000 AS avg_timewait
     , COUNT_WRITE
     , SUM_TIMER_WRITE/1000000000000 AS sum_timewrite
     , AVG_TIMER_WRITE/1000000000000 AS avg_timewrite
	 ,COUNT_WRITE_EXTERNAL as 'count_write_externallock'
     ,SUM_TIMER_WRITE_EXTERNAL/1000000000000 AS sum_time_write_externallock
     ,AVG_TIMER_WRITE_EXTERNAL/1000000000000 AS avg_time_write_externallock
FROM performance_schema.table_lock_waits_summary_by_table
where OBJECT_SCHEMA not in ('mysql','performance_schema','sys')
order by AVG_TIMER_WAIT desc limit 20;
