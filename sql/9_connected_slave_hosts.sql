select user,host,command, state from information_schema.PROCESSLIST AS p WHERE p.COMMAND like 'Binlog Dump%';
