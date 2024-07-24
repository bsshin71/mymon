select 
       b.ID
	  ,concat(b.USER, '@', b.HOST) as user
      ,a.trx_id
      ,a.trx_state
      ,a.trx_started
      ,TIME_TO_SEC(timediff(now(),a.trx_started)) as 'tx_duration'
      ,ifnull(a.trx_query ,h.sql_text ) as tx_query
      ,a.trx_rows_locked
      ,a.trx_rows_modified
from   information_schema.innodb_trx a,
       information_schema.processlist b,
       performance_schema.threads  c left outer join lateral(  select  h.THREAD_ID, h.SQL_TEXT, h.TIMER_WAIT, h.LOCK_TIME
                                                    , date_sub( now(), interval ( select variable_value 
                                                                                  from performance_schema.global_status 
                                                                                  where variable_name = 'UPTIME' ) -
                                                                                 h.TIMER_START * 10e-13 second) as  start_time
                                             from   performance_schema.events_statements_history h
                                             where  h.THREAD_ID = c.THREAD_ID
                                             order by h.EVENT_ID desc
                                             limit 1 ) h on c.thread_id = h.thread_id
where a.trx_mysql_thread_id = b.ID
  and b.ID = c.PROCESSLIST_ID 
  and TIME_TO_SEC(timediff(now(),a.trx_started))> #PARAM1
