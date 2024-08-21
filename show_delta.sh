#!/bin/bash 

queryfile=$1
filter=$2
repeat=$3
interval=$4

DELTA=0
for(( i=0,CNT=1; i<= 9; i++,CNT++))
do
  value=`${MSQL} < "$MONITOR/sql/${queryfile}"  | grep "$filter" | cut -d ':' -f 2`
  if [ $i -gt 0 ] ; then
     DELTA=$((value - BEFORE )) 
  fi
  BEFORE=$value

  echo  "cnt=$CNT    $filter =$value  delta_value=$DELTA"
  
  sleep $interval 
done


