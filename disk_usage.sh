#!/bin/bash 

i=0
while IFS=$'t' read path ;do
   PATHS[$i]=$path
   ((i++))
done < <($MSQL -N < $MONITOR/sql/$1 )
IFS=' '

for (( e=0; e<$i; e++ ))
do
     echo -e "path=${PATHS[$e]}"
     path="${PATHS[$e]}"
     echo "-----------------------------------------------------------"
     df -h ${path}
     echo "-----------------------------------------------------------"
done
