# mymon
shell script for monitoring MySQL
for MySQL DBA

## 용도
DBA 업무를 하다보면  db 상태라든지 점검을 위한  sql 문들을  많이들 갖고 있을 텐데  필요한 순간마다 매번 찾아서  쿼리 실행기(mysql cli 나 기타 gui tool등) 를 통해서  copy 후 실행하는 방식은  좀 불편하였다.

이를 간편하게 하기 위해서 평소 활용도가 높거나 유용한  쿼리들을 번호만 입력하면 쉽게 실행할 수 있고  Enter 키만 치면 반복해서 실행하도록 하는 shell script 를 작성하였다.

본인들이 소장하고 있는  쿼리문을   shell script 에  계속 추가해 나갈 수 있다.

 
## 사용환경

- Linux

- bash shell

- 터미널 폰트 사이즈 10pt

- 터미널 Logical columns size : 200 이상 ( 화면에 긴 칼럼 표시 고려)

## 실행 화면

![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FcPIY8v%2FbtsI9YMevPR%2Fjj7CsPdkhjSjkCrPhwoGxK%2Fimg.png)

## 설치
mymon.sh 과  sql 폴더 전체를 다운로드 받아서  설치하면 된다.

## 설정
```shell
mymon.sh 안에 아래 아래 설정값 셋팅 필요,  패스워드 미 설정시 실행시 입력이 필요
# Configuration --------------------------------
MYMON_VER="1.0"
MONITOR=.; export MONITOR
USER=root; export USER
OS=`uname -s`; export OS
OSVER=`uname -r`; export OSVER
MYSQL_VER_CHK=8 ; export MYSQL_VER_CHK
MYSQL_IP="127.0.0.1" ; export MYSQL_IP
MYSQL_PORT_NO=3306; export MYSQL_PORT_NO
PAGER=more; export PAGER
```
## 실행

```shell
$bash mymon.sh
또는
$./mymon.sh
```
## 구현 목록

| 대분류(카테고리)                     | 메뉴명                                                       | 호출 sql 파일 및 sub shell script                          | 기능                                                         | 비고                                            |
| ------------------------------------ | ------------------------------------------------------------ | ---------------------------------------------------------- | ------------------------------------------------------------ | ----------------------------------------------- |
|                                      |                                                              |                                                            |                                                              |                                                 |
| 1.GENERAL                            | 11 - Instance/Database Info                                  | 1_instance.sql                                             | db 버전uptimecharacter set간단한 db 부하 load                |                                                 |
|                                      | 12 - Parameter Info (innodb buffer)                          | 1_parameters.sql                                           | innodb_buffer_pool 관련 파라미터 값                          |                                                 |
|                                      | 13 - Memory Usage by each module                             | 1_memoryusage.sql                                          | thread 당 메모리 사용량event 별 메모리 사용량                |                                                 |
| 2.Cache & Latch                      | 21 - Buffer Hit Ratio                                        | 2_bufferhitratio.sql                                       | buffer hit ratio                                             |                                                 |
| 3.SESSION                            | 31 - Current Session Info                                    | 3_current_session.sql                                      | 현재 세션 통계호스트별유저별processlist 정보                 |                                                 |
|                                      | 32 - Current Running Session Info                            | 3_run_session.sql                                          | 현재 실행중인 세션정보                                       |                                                 |
|                                      | 33 - Current Wait Session Info                               | 3_wait_session.sql                                         | lock wait 으로 대기중인 세션정보                             |                                                 |
|                                      | 34 - Running Session SQL Info                                | 3_run_session_sql.sql                                      | 현재 쿼리 실행중 상태인 세션의 쿼리 수행 정보                |                                                 |
| 4.LOCK                               | 41 - Current Transaction                                     | 4_current_transaction.sql                                  | 현재 executing 상태( wait commit ) 상태인 statement / 세션 정보 |                                                 |
|                                      | 42 - Current Lock status of Grant and Wait                   | 4_lock_grant_wait.sql                                      | Lock grant 및 Lock wait 상태인 statement 관계 표시           |                                                 |
|                                      | 43 - Waiting commit session info                             | 4_waiting_commit_session.sql                               | commit 대기중인 세션/statement 정보                          | sys.session 의 trx_state가 'ACTIVE' 인 세션정보 |
|                                      | 44 - Waiting commit Transaction info (require time)          | 4_waiting_commit_transaction.sql                           | 지정된 시간이상 commit wait 상탳인 세션/statement 정보       | 지정시간 입력값 필요                            |
|                                      | 45 - Meta Locking Session Info                               | 4_meta_lock_session.sql                                    | Meta lock 을 잡고 있는 세션/statement 정보                   |                                                 |
|                                      | 46 - Waiting Session by table lock                           | 4_wait_session_by_tablelock.sql                            | Metal lock 에 의해서 blocking 된 상태인 세션/statement 정보  |                                                 |
|                                      | 47 - All Lock Wait stat by table (sort by avg)               | 4_all_lockwait_stat_by_table_sortby_avg.sql                | avg lock wait time 상위 20개인 테이블 및 lock wait time 정보 |                                                 |
|                                      | 48 - All Lock Wait stat by table (sort by sum)               | 4_all_lockwait_stat_by_table_sortby_sum.sql                | sum lock wait time 상위 20개인 테이블 및 lock wait time 정보 |                                                 |
|                                      | 49 - Write Lock Wait stat by table (sort by avg)             | 4_write_lockwait_stat_by_table_sortby_avg.sql              | write lock wait 타임중 average write lock time이 상위 20인 테이블 및 lock wait 시간 정보 |                                                 |
|                                      | 491 - Write Lock Wait stat by table (sort by sum)            | 4_write_lockwait_stat_by_table_sortby_sum.sql              | write lock wait 타임중 sum write lock time이 상위 20인 테이블 및 lock wait 시간 정보 |                                                 |
| 5.Wait Event                         | 51 - Most time used Wait Event by AvgTime                    | 5_most_timeused_waitevent_avg.sql                          | wait event 중 average wait 시간이 상위 10인 event 정보       |                                                 |
|                                      | 52 - Most time used Wait Event by SumTime                    | 5_most_timeused_waitevent_sum.sql                          | wait event 중 sum wait 시간이 상위 10인 event 정보           |                                                 |
|                                      | 53 - Most time used Wait Event by MaxTime                    | 5_most_timeused_waitevent_max.sql                          | wait event 중 max wait 시간이 상위 10인 event 정보           |                                                 |
| 6.I/O                                | 61 - Event I/O by avg WaitTime                               | 6_fileio_by_eventname_avg.sql                              | file I/O 관련 event 중 avg wait time 이 상위 15개인 event 정보 | 디스크 병목시 원인 추적시 활용                  |
|                                      | 62 - Event I/O by sum WaitTime                               | 6_fileio_by_eventname_sum.sql                              | file I/O 관련 event 중 sum wait time 이 상위 15개인 event 정보 |                                                 |
|                                      | 63 - File I/O by avg WaitTime                                | 6_fileio_by_instance_avg.sql                               | instance Level 에서 i/O average wait time 이 상위 20인 파일 파일 정보 |                                                 |
|                                      | 64 - File I/O by sum WaitTime                                | 6_fileio_by_instance_sum.sql                               | instance Level 에서 i/O sum wait time 이 상위 20인 파일 파일 정보 |                                                 |
|                                      | 65 - Table I/O by avg WaitTime                               | 6_tableio_by_table_avg.sql                                 | i/O average wait time 이 상위 20인 테이블정보                |                                                 |
|                                      | 66 - Table I/O by sum WaitTime                               | 6_tableio_by_table_sum.sql                                 | i/O sum wait time 이 상위 20인 테이블정보                    |                                                 |
|                                      | 67 - Index I/O by avg WaitTime                               | 6_indexio_by_index_avg.sql                                 | i/O average wait time 이 상위 20인 테이블/ INDEX 정보        |                                                 |
|                                      | 68 - Index I/O by sum WaitTime                               | 6_indexio_by_index_sum.sql                                 | i/O sum wait time 이 상위 20인 테이블/ INDEX 정보            |                                                 |
| 7.DML statistics                     | 71 - Top slow query-digest by avg of exec time               | 7_topslow_query_digest_by_avg.sql                          | average 수행시간 상위 20인 쿼리 ( digest 형식)               |                                                 |
|                                      | 72 - Top slow query-digest by sum of exec time               | 7_topslow_query_digest_by_sum.sql                          | sum 수행시간 상위 20인 쿼리 ( digest 형식)                   |                                                 |
|                                      | 73 - Top slow query history by duration                      | 7_topslow_queryhistory_by_duration.sql                     | 전체 수행 시간 상위 20인 수행 완료된 쿼리                    |                                                 |
|                                      | 74 - Most executed query                                     | 7_most_exec_query.sql                                      | 수행 횟수 상위 20인 쿼리                                     |                                                 |
|                                      | 75 - Most row examined query                                 | 7_most_row_examined_query.sql                              | row 스캔(examined) 횟수 상위 20인 쿼리                       |                                                 |
| 8. Space & Usage                     | 81 - Database Usage                                          | 8_database_usage.sql                                       | 데이터베이스별 전체/data/index/free 공간 및 테이블 갯수      |                                                 |
|                                      | 82 - Top table Usage                                         | 8_top_table_usage.sql                                      | 테이블 사용량 상위 20인 테이블 정보                          |                                                 |
|                                      | 83 - Top index Usage                                         | 8_top_index_usage.sql                                      | 인덱스 사용량 상위 30인 인덱스 이름 / 사용량 정보            |                                                 |
|                                      | 84 - Top partition table Usage                               | 8_top_partition_table_usage.sql                            | 사용량 상위 30 파티션테이블 이름 / 사용량 정보               |                                                 |
|                                      | 85 - Redo dir Disk Usage ( only possible local)              | 8_redolog_dir.sql sub-script:disk_usage.sh                 | redo directory 의 vg 그룹 사용량 정보                        |                                                 |
|                                      | 86 - Datafile dir Disk Usage ( only possible local)          | 8_datafile_dir.sql sub-script:disk_usage.sh                | data directory 의 vg 그룹 사용량 정보                        |                                                 |
|                                      | 87 - Temp dir Disk Usage ( only possible local)              | 8_tmp_dir.sql sub-script:disk_usage.sh                     | temp directory 의 vg 그룹 사용량 정보                        |                                                 |
| 9. Replication                       | 91 - Connected Slave hosts                                   | 9_connected_slave_hosts.sql                                | master 서버에 접속한 slave 서버 정보 ( master 관점)          |                                                 |
|                                      | 92 - Master Server info                                      | 9_master_server_info.sql                                   | master 서버 정보 ( slave 관점 )                              |                                                 |
|                                      | 93 - Show slave status                                       | 9_show_slave_status.sql sub-script:slave_status.sh         | replication slave 상태 정보 ( slave 기준)                    |                                                 |
|                                      | 94 - Replication Lag (auto repeat)                           | 9_show_slave_status.sql sub-script:show_delta.sh           | replication lag 정보를 1 초 단위로 현재값 증가값을 반복해서 표시( slave 기준) |                                                 |
| 10. Status                           | 101 - Thread status                                          | 10_thread_status.sql                                       | mysql connection thread 상태별 갯수 표시                     |                                                 |
|                                      | 102 - Replication status                                     | 10_replication_status.sql                                  | replication semi sync 관련 상태 정보                         |                                                 |
|                                      | 103 - DML execution status (auto repeat)                     | 10_dml_execution_status.sql sub-script:show_multi_delta.sh | dml 종류별 row 수행건수를 1초 단위로 현재값/증가값 반복패서 표시 |                                                 |
| 20. Plan & Index                     | 201 - Unused Index                                           | 20_unused_index_status.sql                                 | 사용하지 않는 인덱스 명 출력                                 |                                                 |
|                                      | 202 - Tables with full table scan                            | 20_tables_with_fullscan.sql                                | full table scan 이 일어나는 테이블이 fulls scan 횟수 및 수행시간 |                                                 |
|                                      | 203 - Statement with full table scan                         | 20_statement_with_fullscan.sql                             | full scan 이 발생한 수행시간 상위 20개 쿼리정보              |                                                 |
| 30. Performance_schema Configuration | 301. Show Performance_schema variable                        | 30_perf_variables.sql                                      | performance_schema 테이블 관련 현재 설정 정보                |                                                 |
|                                      | 302. Show Performacne_schema setup_consumer                  | 30_perf_setup_consumer.sql                                 | Performacne_schema setup_consumer의 설정정보현재 수집되는 정보표시 |                                                 |
|                                      | 303. Enable Performance_schema support statement history_long | 30_enable_history_long.sql                                 | events_statements_history/history_long 테이블 수집기능 enable 함 |                                                 |
|                                      | 304. Disable Performance_schema support statement history_long | 30_disable_history_long.sql                                | events_statements_history_long 테이블 수집기능 disable 함    |                                                 |
|                                      | 305. flush status (=reset status )                           | 30_flush_status.sql                                        | flush status 수행해서 status 관련 정보를 reset함             |                                                 |
|                                      | 306. Truncate all performance_schema table( reset all)       | 30_ps_truncate_all_table.sql                               | performance_schema 관련 테이블을 truncate하여 reset 함       |                                                 |
|                                      |                                                              |                                                            |                                                              |                                                 |
|                                      |                                                              |                                                            |                                                              |                                                 |


