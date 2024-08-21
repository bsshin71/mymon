select CHANNEL_NAME
      ,HOST
      ,PORT
      ,USER   
from performance_schema.replication_connection_configuration;
