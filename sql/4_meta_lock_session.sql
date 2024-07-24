SELECT   l.object_type
       , l.object_schema as 'schema'
       , l.object_name   as 'table_name'
       , l.lock_type
       , l.lock_status
       , t.processlist_id as p_id
       , concat(t.processlist_user ,'@', t.processlist_host ) as user
       , t.processlist_time as 'time'
       , t.processlist_info as query
       , t.processlist_state as state
       , t.thread_id
FROM   performance_schema.metadata_locks l
       inner join performance_schema.threads t on t.thread_id = l.owner_thread_id
where  t.processlist_id <> connection_id() 
and  l.object_schema is not null  
and  l.object_type is not null
and  l.object_name is not null
and  l.lock_status = 'GRANTED' 
and  t.processlist_state  not like '%Waiting for table metadata lock%' or t.processlist_state  is null;
