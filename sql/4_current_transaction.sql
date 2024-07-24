-- replace(replace(a.sql_text,'\r',''), '\n','') as query

select
	 b.thread_id,
     b.processlist_user,
     b.processlist_host,
     b.processlist_db,
     b.processlist_state, 
     SEC_TO_TIME(c.TIMER_WAIT/1000000000000) AS timer_wait,
     replace(IF(LENGTH(a.SQL_TEXT) > 64, CONCAT(LEFT(a.SQL_TEXT, 30), ' ... ', RIGHT(a.SQL_TEXT, 30)), a.SQL_TEXT), '\n','') AS query ,
     a.ROWS_AFFECTED,
     a.ROWS_SENT,
     a.ROWS_EXAMINED
from performance_schema.events_statements_current a,
     performance_schema.threads b,
     performance_schema.events_transactions_current c
where  a.thread_id = b.thread_id and c.state = 'ACTIVE'
  and  a.thread_id = c.thread_id
order by a.timer_wait desc limit 20;
