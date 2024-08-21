#!/bin/bash 

i=0
while IFS=$' '  read name value ;do
   NAME[$i]=$name
   VALUE[$i]=$value
   ((i++))
done < <($MSQL < $MONITOR/sql/$1 )

IFS=' '

for (( e=0; e<$i; e++ ))
do
     
    # echo -e "${NAME[$e]} \t ${VALUE[$e]}"
    aName="${NAME[$e]}" 
    aValue="${VALUE[$e]}"

    if [ "x${aValue}" != "x" ]; then
     awk -v a1="$aName" -v a2="$aValue" 'BEGIN {printf "%40s%s\n", a1,a2}' 
    fi
done
