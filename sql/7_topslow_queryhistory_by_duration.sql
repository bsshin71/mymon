select   ps_esh.current_SCHEMA as 'schema'
        ,replace( replace(IF(LENGTH(ps_esh.SQL_TEXT) > 64, CONCAT(LEFT(ps_esh.SQL_TEXT, 30), ' ... ',  RIGHT(ps_esh.SQL_TEXT, 30)) , ps_esh.SQL_TEXT), '\n',''), '\t','') AS query
        ,sys.format_time(ps_esh.TIMER_WAIT) as 'statement duration'
        ,sys.format_time(ps_esh.LOCK_TIME) as 'lock duration'
        , date_sub( now(), interval ( select variable_value from performance_schema.global_status where variable_name = 'UPTIME' ) -
                                   ps_esh.TIMER_START * 10e-13 second) as 'start_time'
       ,date_sub( now(), interval ( select variable_value from performance_schema.global_status where variable_name = 'UPTIME' ) -
                                   ps_esh.TIMER_END * 10e-13 second) as 'end_time'
from  performance_schema.events_statements_history ps_esh 
where ps_esh.current_SCHEMA not in ( 'mysql','performance_schema','sys')
and event_name like 'statement/sql%' 
order by ps_esh.TIMER_WAIT desc limit 25 ;    
