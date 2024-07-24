/*
 1. db vsersion
 2. uptime
 3. character set
*/
select  'db version' as name, version() as value

union all
select  'startup time' , date_sub( now(), interval ( select variable_value from performance_schema.global_status where variable_name = 'UPTIME' ) second ) 
union all
select 'character_set_server' , @@character_set_server
union all
select 'collation_connection' , @@collation_connection
union all
select 'collation_database'  , @@collation_database
union all
select 'collation_server'   , @@collation_server;

status;
