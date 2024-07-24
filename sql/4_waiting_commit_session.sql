select * from sys.session where db is not null and trx_state = 'ACTIVE' \G
