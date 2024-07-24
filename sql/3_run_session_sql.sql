select  s.conn_id as 'P_ID'
       ,s.user
       ,s.db
	   ,s.state
       ,s.statement_latency
       ,s.trx_latency
       ,s.trx_state
       ,date_sub( now() , interval t.uptime - a.TIMER_START * 10e-13 second ) as 'start_time'
       ,s.program_name as 'prg_name'
       ,replace(replace(a.sql_text,'\r',''), '\n','') as query
from  performance_schema.events_statements_current  a
    , sys.session  s
    , ( select variable_value as uptime from performance_schema.global_status where variable_name = 'UPTIME' ) t
where 
     a.thread_Id = s.thd_id
and  s.STATE='executing'  
and s.conn_id <>  connection_id() \G
