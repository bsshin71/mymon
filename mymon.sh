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
MONITOR=.; export MONITOR
USER=root; export USER
PASS="ss0081"; export PASS
OS=`uname -s`; export OS
OSVER=`uname -r`; export OSVER
MYSQL_VER_CHK=8 ; export MYSQL_VER_CHK
MYSQL_IP="127.0.0.1" ; export MYSQL_IP
MYSQL_PORT_NO=3306; export ALTIBASE_PORT_NO
PAGER=more; export PAGER

# Message Printing -----------------------------
clear
pr_version

# Get root user password  -----------------------
#get_rootpass
export MYSQL_PWD=${PASS}
MSQL="mysql -h ${MYSQL_IP} -u $USER -P${MYSQL_PORT_NO} --pager"; export MSQL


mysql_version_chk

get_dbhostname

# -----------------------------------------------------------

call_sql() 
{
	clear
	echo "============================"
    echo " $1 "
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
    echo " $1 "
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
while true
do
clear
export count=0
cat <<EOF
     MySQL Version : $MYSQL_VER_CHK  Connected to : ${MY_HOSTNAME} 
 -----------------------------------------------------------------------------------
 1.GENERAL                                     |  2.Cache & Latch                        
 ----------------------------------------------+------------------------------------------
 11 - Instance/Database Info                   |  21 - Buffer Hit Ratio                  
 12 - Parameter Info (innodb buffer)           |                                         
 13 - Memory Usage by each module              |                                         
 -----------------------------------------------------------------------------------
 3.SESSION                                     |  4.LOCK                                 
 ----------------------------------------------+------------------------------------------
 31 - Current Session Info                     |  41 - Current Transaction               
 32 - Current Running Session Info             |  42 - Lock Grant and Wait Info          
 33 - Current Wait Session Info                |  43 - Waiting commit session info       
 34 - Running Session SQL Info                 |  44 - Waiting commit Transaction        
                                               |  45 - Meta Locking Session Info         
 -----------------------------------------------------------------------------------
 5.Wait Event                                  |  6.I/O                                 
 ----------------------------------------------+------------------------------------------
 51 - Most time used Wait Event by AvgTime     |  61 - Event I/O by avg WaitTime
 52 - Most time used Wait Event by SumTime     |  62 - Event I/O by sum WaitTime
 53 - Most time used Wait Event by MaxTime     |  63 - File I/O by avg WaitTime
                                               |  64 - File I/O by sum WaitTime
                                               |  65 - Table I/O by avg WaitTime
                                               |  66 - Table I/O by sum WaitTime
                                               |  67 - Index I/O by avg WaitTime
                                               |  68 - Index I/O by sum WaitTime
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
