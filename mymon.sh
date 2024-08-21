#!/bin/bash

#-------------------------------------------------------------------------------
# 2024.07.08 created by omegaman                       (Ver1.0)
#-------------------------------------------------------------------------------


# Message Function -----------------------------
pr_done(){
  echo "Press Enter Key to repeat this output or other key to back previous menu..."
}


pr_version()
{
  echo "============================="
  echo " MySQL Monitoring Script "
  echo "============================="
}

# Get root user password from prompt
get_rootpass(){
  stty -echo
  echo
  if [ $OS = "Linux" ] ; then
    echo -e "Enter MySQL root Password : \c"
  else
    echo "Enter MySQL root Password : \c"
  fi
  read PASS
  stty echo
}

# Check MySQL Version -----------------------
mysql_version_chk(){
  MYSQL_VER_CHK=`$MSQL -sN -e "select version()"`
  MAJOR_MYSQL_VER=`echo ${MYSQL_VER_CHK} | cut -c 1-1` 

  if [ ${MAJOR_MYSQL_VER} -lt 8  ] ; then
     echo 'The lower version Than MySQL 8 do not support yet'
     exit
  elif [  ${MAJOR_MYSQL_VER} -eq 8  ] ; then
     echo "MySQL ${MYSQL_VER_CHK}"
  fi

}

# get hostname of the connected MySQL server  ----
get_dbhostname() {
  MY_HOSTNAME=`$MSQL -sN -e "select @@hostname"`

  export MY_HOSTNAME
  echo "${MY_HOSTNAME}"
}

# SQL Run Function ----------------------------
run_sql(){
  $MSQL -t < $MONITOR/sql/$1 
}

run_sql_with_param1(){
  cat $MONITOR/sql/$1  | sed "s/#PARAM1/$2/g" | $MSQL -t
}

run_sql_with_result(){
  $MSQL < $MONITOR/sql/$1
}

# Start monitor shell --------------------------
# Shell Check ----------------------------------
if [ $# -ne 0 ] ;  then
  echo
  echo " MySQL Monitoring Shell"
  echo " ---------------------"
  echo " Usage : $0 "
  echo " "
  echo
  exit
fi

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

# Message Printing -----------------------------
clear
pr_version

# Get root user password  -----------------------
get_rootpass
export MYSQL_PWD=${PASS}
MSQL="mysql -h ${MYSQL_IP} -u $USER -P${MYSQL_PORT_NO}"; export MSQL

echo "MSQL=$MSQL"

mysql_version_chk

get_dbhostname

# -----------------------------------------------------------

call_sql() 
{
	clear
	echo "============================"
    echo " $1 " "sql file: $2"
    echo "============================"
    run_sql $2
    count=$(($count + 1 ))
    echo "count=$count"
    pr_done
	read -n 1 key
    if [[ $key = "" ]]; then
       call_sql "$1" "$2"  # Enter key
    fi

}

call_sql_with_param_one() 
{   
    clear
	if [ $count -eq 0 ] ; 
    then
      echo "input $3 : "
      read param1
    fi
    echo "============================"
    echo " $1 " "sql file: $2"
    echo "============================"
    run_sql_with_param1 "$2" "${param1}"
    count=$(($count + 1 ))
    echo "count=$count $3=${param1}"
    pr_done 
    read -n 1 key
    if [[ $key = "" ]]; then
       call_sql_with_param_one "$1" "$2" "$3"  # Enter key
    fi

}

call_shellscript()
{
    clear
    echo "============================"
    echo " $1 " "sql file: $2" " sub-script:$3 "
    echo "============================"
    ./$3 $2
    count=$(($count + 1 ))
    echo "count=$count"
    pr_done
    read -n 1 key
    if [[ $key = "" ]]; then
       call_shellscript "$1" "$2" "$3"  # Enter key
    fi
    
}

call_shellscript_with_delta()
{
    clear
    echo "============================"
    echo " $1 " "sql file: $2" " sub-script:$3 " " filter=$4" " repeat_num=$5 "  " interval=$6"
    echo "============================"
    ./$3 "$2" "$4" "$5" "$6"
    count=$(($count + 1 ))
    echo "count=$count"
    pr_done
    read -n 1 key
    if [[ $key = "" ]]; then
       call_shellscript_with_delta "$1" "$2" "$3" "$4" "$5" "$6" # Enter key
    fi

}

while true
do
clear
export count=0
cat <<EOF
     MySQL Version : $MYSQL_VER_CHK  Connected to : ${MY_HOSTNAME}  MYMON.sh Version : ${MYMON_VER}
 ------------------------------------------------+------------------------------------------------
 1.GENERAL                                       |  2.Cache & Latch                        
 ------------------------------------------------+------------------------------------------------
 11 - Instance/Database Info                     |  21 - Buffer Hit Ratio                  
 12 - Parameter Info (innodb buffer)             |                                         
 13 - Memory Usage by each module                |                                         
 ------------------------------------------------+------------------------------------------------
 3.SESSION                                       |  4.LOCK                                 
 ------------------------------------------------+------------------------------------------------
 31 - Current Session Info                       |  41  - Current Transaction               
 32 - Current Running Session Info               |  42  - Current Lock status  of Grant and Wait 
 33 - Current Wait Session Info                  |  43  - Waiting commit session info       
 34 - Running Session SQL Info                   |  44  - Waiting commit Transaction info (require time)      
                                                 |  45  - Meta Locking Session Info
                                                 |  46  - Waiting Session by table lock
                                                 |  47  - All Lock Wait stat by table (sort by avg)         
                                                 |  48  - All Lock Wait stat by table (sort by sum)         
                                                 |  49  - Write Lock Wait stat by table (sort by avg)         
                                                 |  491 - Write Lock Wait stat by table (sort by sum)         
 ------------------------------------------------+------------------------------------------------
 5.Wait Event                                    |  6.I/O                                 
 ------------------------------------------------+------------------------------------------------
 51 - Most time used Wait Event by AvgTime       |  61 - Event I/O by avg WaitTime
 52 - Most time used Wait Event by SumTime       |  62 - Event I/O by sum WaitTime
 53 - Most time used Wait Event by MaxTime       |  63 - File I/O by avg WaitTime
                                                 |  64 - File I/O by sum WaitTime
                                                 |  65 - Table I/O by avg WaitTime
                                                 |  66 - Table I/O by sum WaitTime
                                                 |  67 - Index I/O by avg WaitTime
                                                 |  68 - Index I/O by sum WaitTime
 ------------------------------------------------+------------------------------------------------
 7.DML statistics                                |  8. Space & Usage
 ------------------------------------------------+------------------------------------------------
 71 - Top slow query-digest by avg of exec time  |  81 - Database Usage
 72 - Top slow query-digest by sum of exec time  |  82 - Top table Usage
 73 - Top slow query history by duration         |  83 - Top index Usage
 74 - Most executed query                        |  84 - Top partition table Usage 
 75 - Most row examined query                    |  85 - Redo dir Disk Usage ( only possible local)
                                                 |  86 - Datafile dir Disk Usage ( only possible local)
                                                 |  87 - Temp dir Disk Usage ( only possible local) 
 ------------------------------------------------+------------------------------------------------
 9. Replication                                  |  10. Status
 ------------------------------------------------+------------------------------------------------
 91 - Connected Slave hosts                      |  101 - Thread status 
 92 - Master Server info                         |  102 - Replication status 
 93 - Show slave status                          |  103 - Row number changed by DML (auto repeat)   
 94 - Replication Lag (auto repeat)              |  
 ------------------------------------------------+------------------------------------------------
 20. Plan & Index                                |  30. Performance_schema Configuration
 ------------------------------------------------+------------------------------------------------
 201 - Unused Index                              |  301. Show Performance_schema variable  
 202 - Tables with full table scan               |  302. Show Performacne_schema setup_consumer
 203 - Statement with full table scan            |  303. Enable Performance_schema support statement history_long  
                                                 |  304. Disable Performance_schema support statement history_long
                                                 |  305. flush status (=reset status ) 
                                                 |  306. Truncate all performance_schema table( reset all)
 ------------------------------------------------+------------------------------------------------
 
 X - Exit

EOF


echo ""

if [ "$OS" = "Linux" ] ; then
   echo -e " Choose the Number or Command : \c "
else
  echo ' Choose the Number or Command : \c '
fi
read i_number
case $i_number in

# 1.GENERAL ---------------------------------------
11)
    call_sql " MySQL Instance Infomation " "1_instance.sql"
	;;
12)
    call_sql " Parameter Info for innodb" "1_parameters.sql"
	;;
13)
    call_sql " Memory Usage by each module" "1_memoryusage.sql"
	;;
21)
    call_sql " Buffer Hit Ratio " "2_bufferhitratio.sql"
	;;
31)
    call_sql " Current Session Info " "3_current_session.sql"
	;;
32)
    call_sql " Current Running Session Info " "3_run_session.sql"
	;;
33)
    call_sql " Current Wait Session Info " "3_wait_session.sql"
	;;
34)
    call_sql " Running Session SQL Info " "3_run_session_sql.sql"
	;;
41)
    call_sql " Current Transaction " "4_current_transaction.sql"
	;;
42)
    call_sql " Lock Grant and Wait Info " "4_lock_grant_wait.sql"
	;;
43)
    call_sql " Waiting commit session info " "4_waiting_commit_session.sql"
	;;
44)
    call_sql_with_param_one " Waiting commit Transaction " "4_waiting_commit_transaction.sql" "Waiting commit time(second) > "
	;;
45)
    call_sql " Meta Locking session info " "4_meta_lock_session.sql"
	;;
46)
    call_sql " Waiting Session by table lock " "4_wait_session_by_tablelock.sql"
	;;
47)
    call_sql " All Lock Wait stat by table (sort by avg) " "4_all_lockwait_stat_by_table_sortby_avg.sql"
	;;
48)
    call_sql " All Lock Wait stat by table (sort by sum) " "4_all_lockwait_stat_by_table_sortby_sum.sql"
	;;
49)
    call_sql " Write Lock Wait stat by table (sort by avg) " "4_write_lockwait_stat_by_table_sortby_avg.sql"
	;;
491)
    call_sql " Write Lock Wait stat by table (sort by sum) " "4_write_lockwait_stat_by_table_sortby_sum.sql"
	;;
51)
    call_sql " Most time used Wait Event by AvgTime  " "5_most_timeused_waitevent_avg.sql"
	;;
52)
    call_sql " Most time used Wait Event by SumTime " "5_most_timeused_waitevent_sum.sql"
	;;
53)
    call_sql " Most time used Wait Event by MaxTime " "5_most_timeused_waitevent_max.sql"
	;;
61)
    call_sql " Event I/O by avg WaitTime " "6_fileio_by_eventname_avg.sql"
	;;
62)
    call_sql " Event I/O by sum WaitTime " "6_fileio_by_eventname_sum.sql"
	;;
63)
    call_sql " File I/O by avg WaitTime " "6_fileio_by_instance_avg.sql"
	;;
64)
    call_sql " File I/O by sum WaitTime " "6_fileio_by_instance_sum.sql"
	;;
65)
    call_sql " Table I/O by avg WaitTime " "6_tableio_by_table_avg.sql"
	;;
66)
    call_sql " Table I/O by sum WaitTime " "6_tableio_by_table_sum.sql"
	;;
67)
    call_sql " Index I/O by avg WaitTime " "6_indexio_by_index_avg.sql"
	;;
51)
    call_sql " Most time used Wait Event by AvgTime  " "5_most_timeused_waitevent_avg.sql"
	;;
52)
    call_sql " Most time used Wait Event by SumTime " "5_most_timeused_waitevent_sum.sql"
	;;
53)
    call_sql " Most time used Wait Event by MaxTime " "5_most_timeused_waitevent_max.sql"
	;;
61)
    call_sql " Event I/O by avg WaitTime " "6_fileio_by_eventname_avg.sql"
	;;
62)
    call_sql " Event I/O by sum WaitTime " "6_fileio_by_eventname_sum.sql"
	;;
63)
    call_sql " File I/O by avg WaitTime " "6_fileio_by_instance_avg.sql"
	;;
64)
    call_sql " File I/O by sum WaitTime " "6_fileio_by_instance_sum.sql"
	;;
65)
    call_sql " Table I/O by avg WaitTime " "6_tableio_by_table_avg.sql"
	;;
66)
    call_sql " Table I/O by sum WaitTime " "6_tableio_by_table_sum.sql"
	;;
67)
    call_sql " Index I/O by avg WaitTime " "6_indexio_by_index_avg.sql"
	;;
51)
    call_sql " Most time used Wait Event by AvgTime  " "5_most_timeused_waitevent_avg.sql"
	;;
52)
    call_sql " Most time used Wait Event by SumTime " "5_most_timeused_waitevent_sum.sql"
	;;
53)
    call_sql " Most time used Wait Event by MaxTime " "5_most_timeused_waitevent_max.sql"
	;;
61)
    call_sql " Event I/O by avg WaitTime " "6_fileio_by_eventname_avg.sql"
	;;
62)
    call_sql " Event I/O by sum WaitTime " "6_fileio_by_eventname_sum.sql"
	;;
63)
    call_sql " File I/O by avg WaitTime " "6_fileio_by_instance_avg.sql"
	;;
64)
    call_sql " File I/O by sum WaitTime " "6_fileio_by_instance_sum.sql"
	;;
65)
    call_sql " Table I/O by avg WaitTime " "6_tableio_by_table_avg.sql"
	;;
66)
    call_sql " Table I/O by sum WaitTime " "6_tableio_by_table_sum.sql"
	;;
67)
    call_sql " Index I/O by avg WaitTime " "6_indexio_by_index_avg.sql"
	;;
51)
    call_sql " Most time used Wait Event by AvgTime  " "5_most_timeused_waitevent_avg.sql"
	;;
52)
    call_sql " Most time used Wait Event by SumTime " "5_most_timeused_waitevent_sum.sql"
	;;
53)
    call_sql " Most time used Wait Event by MaxTime " "5_most_timeused_waitevent_max.sql"
	;;
61)
    call_sql " Event I/O by avg WaitTime " "6_fileio_by_eventname_avg.sql"
	;;
62)
    call_sql " Event I/O by sum WaitTime " "6_fileio_by_eventname_sum.sql"
	;;
63)
    call_sql " File I/O by avg WaitTime " "6_fileio_by_instance_avg.sql"
	;;
64)
    call_sql " File I/O by sum WaitTime " "6_fileio_by_instance_sum.sql"
	;;
65)
    call_sql " Table I/O by avg WaitTime " "6_tableio_by_table_avg.sql"
	;;
66)
    call_sql " Table I/O by sum WaitTime " "6_tableio_by_table_sum.sql"
	;;
67)
    call_sql " Index I/O by avg WaitTime " "6_indexio_by_index_avg.sql"
	;;
68)
    call_sql " Index I/O by sum WaitTime " "6_indexio_by_index_sum.sql"
	;;
71)
    call_sql " Top slow query-digest by average of exec time  " "7_topslow_query_digest_by_avg.sql"
	;;
72)
    call_sql " Top slow query-digest by  sum of exec time  " "7_topslow_query_digest_by_sum.sql"
	;;
73)
    call_sql " Top slow query history by duration  " "7_topslow_queryhistory_by_duration.sql"
	;;
74)
    call_sql " Most executed query " "7_most_exec_query.sql"
	;;
75)
    call_sql " Most row-examined query " "7_most_row_examined_query.sql"
	;;
81)
    call_sql " Database Usage " "8_database_usage.sql"
	;;
82)
    call_sql " Top table Usage " "8_top_table_usage.sql"
	;;
83)
    call_sql " Top index Usage " "8_top_index_usage.sql"
	;;
84)
    call_sql " Top partition table Usage " "8_top_partition_table_usage.sql"
	;;
85)
    call_shellscript " Redo dir Disk Usage ( only possible local connect) " "8_redolog_dir.sql" "disk_usage.sh"
	;;
86)
    call_shellscript " Datafile dir Disk Usage ( only possible local connect )" "8_datafile_dir.sql" "disk_usage.sh"
	;;
87)
    call_shellscript " Temp dir Disk Usage ( only possible local connect )" "8_tmp_dir.sql" "disk_usage.sh"
	;;
91)
    call_sql " Connected Slave hosts " "9_connected_slave_hosts.sql" 
	;;
92)
    call_sql " Master Server info " "9_master_server_info.sql" 
	;;
93)
    call_shellscript " Show Slave status " "9_show_slave_status.sql"  "slave_status.sh"
	;;
94)
    call_shellscript_with_delta "  Replication Lag (auto repeat)" "9_show_slave_status.sql"  "show_delta.sh" "Seconds_Behind_Master" "10" "1"
	;;
101)
    call_sql " Thread status " "10_thread_status.sql" 
	;;
102)
    call_sql " Replication status " "10_replication_status.sql" 
	;;
103)
    call_shellscript_with_delta " Row number changed by DML " "10_innodb_rows_changed_by_dml.sql"  "show_multi_delta.sh"  "" "10" "1"
	;;

201)
    call_sql " Unused Index " "20_unused_index_status.sql" 
	;;
202)
    call_sql " Tables with full table scan" "20_tables_with_fullscan.sql" 
	;;
203)
    call_sql " Statement with full table scan" "20_statement_with_fullscan.sql" 
	;;
301)
    call_sql " Show Performance_schema variable" "30_perf_variables.sql" 
	;;
302)
    call_sql " Show Performacne_schema setup_consumer" "30_perf_setup_consumer.sql" 
	;;
303)
    call_sql " Enable Performance_schema support events_statements_history_long  " "30_enable_history_long.sql" 
	;;
304)
    call_sql " Disable Performance_schema support events_statements_history_long  " "30_disable_history_long.sql" 
	;;
305)
    call_sql " flush status ( reset status ) " "30_flush_status.sql" 
	;;
306)
    call_sql " Truncate all performance_schema table( reset all) " "30_ps_truncate_all_table.sql" 
	;;
x|X)
	clear
	echo "Good bye..."
	echo
	exit
	;;
*)
	echo
	echo
	echo
	echo "You choose wrong number."
	echo "Try Again.."
	sleep 1
	;;

esac

done
