
select * from sys.memory_global_total;

select  m.thread_id
      , ps_th.name
      , m.current_allocated 
from   sys.memory_by_thread_by_current_bytes m
     , performance_schema.threads  ps_th
     , information_schema.processlist  is_pl
where ps_th.PROCESSLIST_ID = is_pl.ID
and  m.thread_id = ps_th.thread_id
order by current_allocated desc 
limit 10;

SELECT event_name
      ,count_alloc
      ,sum_number_of_bytes_alloc/1024/1024 as 'alloc(MB)'
      ,high_number_of_bytes_used/1024/1024 as 'high used(MB)'
FROM performance_schema.memory_summary_global_by_event_name 
WHERE COUNT_ALLOC > 0  
order by sum_number_of_bytes_alloc desc 
limit 10;
