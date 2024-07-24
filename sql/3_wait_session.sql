 select
       a.PROCESSLIST_ID as 'P_ID'
      ,concat(a.PROCESSLIST_USER ,'@',a.PROCESSLIST_HOST ) as 'USER'
      ,a.PROCESSLIST_DB as 'DB'
      ,left(a.PROCESSLIST_INFO, 50) as query
      ,b.lock_latency
      ,b.trx_latency
      ,b.trx_state
      ,program_name as 'prg_name'
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
        a.PROCESSLIST_USER,
        a.PROCESSLIST_INFO,
		a.PROCESSLIST_HOST,
        a.PROCESSLIST_DB
    from
        performance_schema.threads a,
        performance_schema.data_lock_waits b
    where
        a.THREAD_ID = b.BLOCKING_THREAD_ID or  a.THREAD_ID = b.REQUESTING_THREAD_ID
) a, sys.session b
where a.ROLE='REQUESTER'
and a.PROCESSLIST_ID = b.conn_id ;
