select a.object_schema as 'schema'
      ,a.object_name as 'table_name'
      ,a.waiting_thread_id as 'wait_tid'
      ,a.waiting_account as 'user'
      ,a.waiting_lock_type as 'wait_locktype'
      ,a.waiting_query
      ,a.waiting_query_secs
      ,a.blocking_thread_id as 'block_tid'
      ,a.blocking_lock_type as 'block_locktype'
      ,b.sql_text as 'block_query'
from sys.schema_table_lock_waits a left outer join lateral( select  h.THREAD_ID, h.SQL_TEXT, h.TIMER_WAIT, h.LOCK_TIME
                                                        , date_sub( now(), interval ( select variable_value 
                                                                                      from performance_schema.global_status 
                                                                                      where variable_name = 'UPTIME' ) -
                                                                                          h.TIMER_START * 10e-13 second) as  start_time
                                                        from   performance_schema.events_statements_history h
                                                         where  h.THREAD_ID = a.blocking_thread_id
                                                         order by h.EVENT_ID desc
                                                         limit 1 ) b on a.blocking_thread_id = b.thread_id
where a.waiting_thread_id != a.blocking_thread_id;

