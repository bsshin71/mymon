select  conn_id       
      , user
      , db
      , state
      , sys.format_time(time) as 'time'
      , IF(LENGTH(current_statement) > 50, CONCAT(LEFT(current_statement, 25), ' ... ', RIGHT(current_statement, 25)), left(current_statement,50)) AS query
      , sys.format_time(statement_latency) as 'stmt_lat'
      , rows_examined as 'rows_exam'
      , rows_affected as 'rows_affect'
      , program_name as 'prg_name'
from sys.session
where db not in ('mysql','sys')
and conn_id <> connection_id()
and state is not null;
