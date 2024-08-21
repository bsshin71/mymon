select 'update performance_schema.setup_consumers  to disable events_statements_history_long(default settting)';
UPDATE performance_schema.setup_consumers SET ENABLED = 'YES' WHERE NAME = 'events_statements_history';
UPDATE performance_schema.setup_consumers SET ENABLED = 'NO' WHERE NAME = 'events_statements_history_long';
