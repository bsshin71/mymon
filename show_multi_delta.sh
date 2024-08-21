#!/bin/bash 


queryfile=$1
filter=$2
repeat=$3
interval=$4


echo "|-----|------------------------------|------------------------------|------------------------------|"
printf "|%5s|%30s|%30s|%30s|\n" "count" "variable_name" "value" "delta_value"
echo "|-----|------------------------------|------------------------------|------------------------------|"
for(( j=0, CNT=1; j <$repeat; j++, CNT++))
do
  i=0
  while IFS=$'\t'  read name value ;do
     NAME[$i]=$name
     VALUE[$i]=$value
     ((i++))
  done < <($MSQL -N  < "$MONITOR/sql/${queryfile}" )

  IFS=' '


  for (( e=0; e<$i; e++ ))
  do
    # echo -e "${NAME[$e]} \t ${VALUE[$e]}"
    aName="${NAME[$e]}" 
    aValue="${VALUE[$e]}"
    #echo -e "$aName \t $aValue" 
    
    if [ $j -gt 0 ]; then
       BEFORE="${BEFORES[$e]}"
       DELTA[$e]=$(( aValue - BEFORE ))
    else
       DELTA[$e]=0
    fi
    BEFORES[$e]=$aValue

    #echo -e "cnt=$CNT  $aName \t $aValue  \t delta_value=${DELTA[$e]}"
    printf "|%5s|%30s|%30s|%30s|\n" "$CNT" "$aName" "$aValue" "${DELTA[$e]}"
  done
  echo "|-----|------------------------------|------------------------------|------------------------------|"


  sleep $interval 
done
