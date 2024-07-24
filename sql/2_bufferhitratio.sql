select
      a.a  as 'Innodb_buffer_pool_read_requests'
     ,b.b  as 'Innodb_buffer_pool_reads'
     ,(a.a)/(a.a + b.b) as 'innodb buffer pool hit ratio'
from 
  ( select variable_value as a from performance_schema.global_status where variable_name like 'Innodb_buffer_pool_read_requests%' ) a
, ( select variable_value as b from performance_schema.global_status where variable_name like 'Innodb_buffer_pool_reads%' ) b;
