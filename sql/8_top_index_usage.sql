select  database_name
       , table_name
       , index_name
       , ( stat_value*@@innodb_page_size ) / 1024/1024  as 'index_size(MB)'
from mysql.innodb_index_stats 
where stat_name='size'
order by stat_value desc
limit 30;
