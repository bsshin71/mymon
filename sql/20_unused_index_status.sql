select *  from sys.schema_unused_indexes where object_schema not in ( 'performance_schema', 'sys', 'mysql');
