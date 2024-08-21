   
select db, exec_count,
        sys.format_time(total_latency) as 'total_latency',
        rows_sent_avg, rows_examined_avg, last_seen
        ,replace(IF(LENGTH(query) > 70, CONCAT(LEFT(query, 35), ' ... ', RIGHT(query, 35)), query), '\n',' ') AS 'query'
from sys.x$statements_with_full_table_scans
where db not in ( 'peformance_schema','information_schema','sys','mysql') 
order by total_latency desc limit 20;
