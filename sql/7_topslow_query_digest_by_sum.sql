/*
SELECT SCHEMA_NAME
       ,IF(LENGTH(DIGEST_TEXT) > 64, CONCAT(LEFT(DIGEST_TEXT, 30), ' ... ', RIGHT(DIGEST_TEXT, 30)), DIGEST_TEXT) AS query
       ,IF(SUM_NO_GOOD_INDEX_USED > 0 OR SUM_NO_INDEX_USED > 0, '*', '') AS full_scan
       ,COUNT_STAR 
       ,SUM_ERRORS 
       ,SUM_WARNINGS
       ,SUM_TIMER_WAIT/1000000000000 AS sum_timewait
       ,MAX_TIMER_WAIT/1000000000000 AS max_timewait
       ,AVG_TIMER_WAIT/1000000000000 AS avg_timewait
       ,SUM_ROWS_SENT
       ,ROUND(SUM_ROWS_SENT / COUNT_STAR) AS rows_sent_avg
       ,SUM_ROWS_EXAMINED AS SUM_ROWS_EXAMINED
FROM performance_schema.events_statements_summary_by_digest
where SCHEMA_NAME not in ('mysql','performance_schema','sys')
ORDER BY SUM_TIMER_WAIT DESC limit 20;
*/

select
      db
     ,replace(IF(LENGTH(query) > 64, CONCAT(LEFT(query, 30), ' ... ', RIGHT(query, 30)), query), '\n', ' ') AS query 
     ,full_scan
     ,exec_count
     ,err_count
     ,warn_count
     ,total_latency/1000000000000 AS total_latency
     ,avg_latency/1000000000000 as avg_latency
     ,rows_sent_avg
     ,rows_examined_avg
     ,last_seen
from sys.x$statement_analysis
where db not in ('mysql','performance_schema','sys')
order by total_latency desc limit 20
