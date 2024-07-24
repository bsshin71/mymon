select
       a.ROLE
       ,a.PROCESSLIST_ID
       ,a.user
       ,sys.format_time(b.TIMER_WAIT) as TIMER_WAIT
       ,sys.format_time(b.LOCK_TIME) as LOCK_TIME
       ,b.start_time
       ,left(replace(ifnull(a.PROCESSLIST_INFO, b.SQL_TEXT), '\n',''), 50) as query
       ,c.LOCK_TYPE
       ,c.LOCK_MODE
from
    (select
        a.THREAD_ID,
        case
            when a.THREAD_ID = b.BLOCKING_THREAD_ID
            then 'GRANTER'
            when a.THREAD_ID = b.REQUESTING_THREAD_ID
            then 'REQUESTER'
            else 'UNKNOW'
        end as ROLE,
        a.PROCESSLIST_ID,
        concat(a.PROCESSLIST_USER,'@',a.PROCESSLIST_HOST) as user,
        a.PROCESSLIST_INFO
    from
        performance_schema.threads a,
        performance_schema.data_lock_waits b
    where
        a.THREAD_ID = b.BLOCKING_THREAD_ID or  a.THREAD_ID = b.REQUESTING_THREAD_ID
    ) a , 
       performance_schema.data_locks c  
       left outer join  lateral ( select  h.THREAD_ID, h.SQL_TEXT, h.TIMER_WAIT, h.LOCK_TIME 
                                         , date_sub( now(), interval ( select variable_value from performance_schema.global_status where variable_name = 'UPTIME' ) -
                                           h.TIMER_START * 10e-13 second) as  start_time
								   from   performance_schema.events_statements_history h 
                                   where  h.THREAD_ID = c.THREAD_ID
                                   order by h.EVENT_ID desc
                                           limit 1 ) b on c.thread_id = b.thread_id
 where
     a.THREAD_ID = c.THREAD_ID  ;
