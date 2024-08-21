SELECT
    table_schema,
    table_name,
    (data_length + index_length + data_free)/1024/1024 AS total_mb,
    (data_length)/1024/1024 AS data_mb,
    (index_length)/1024/1024 AS index_mb,
    (data_free)/1024/1024 AS free_mb,
    CURDATE() AS today
FROM
    information_schema.tables
    ORDER BY 3 DESC
LIMIT 20;
