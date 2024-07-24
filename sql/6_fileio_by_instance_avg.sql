SELECT FILE_NAME
      ,count_star as count
      ,SUM_TIMER_WAIT/1000000000000 AS sum_timewait
      ,AVG_TIMER_WAIT/1000000000000 AS avg_timewait
      ,MAX_TIMER_WAIT/1000000000000 AS max_timewait
      ,COUNT_READ as cnt_read
      ,SUM_TIMER_READ/1000000000000 AS sum_timeread
      ,AVG_TIMER_READ/1000000000000 AS avg_timeread
      ,round( SUM_NUMBER_OF_BYTES_READ/(SUM_TIMER_READ/1000000000000) / 1024/1024, 2)  as 'Read MB/s'
      ,COUNT_WRITE as cnt_write
      ,SUM_TIMER_WRITE/1000000000000 AS sum_timewrite
      ,AVG_TIMER_WRITE/1000000000000 AS avg_timewrite
      ,round( SUM_NUMBER_OF_BYTES_WRITE/(SUM_TIMER_WRITE/1000000000000) / 1024/1024, 2)  as 'Write MB/s'
      ,SUM_TIMER_MISC/1000000000000 AS sum_timemisc
FROM performance_schema.file_summary_by_instance
order by AVG_TIMER_WAIT desc limit 15;
