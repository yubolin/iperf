#!/bin/bash

######################################################################
#
# wrk test long_run
#
# sh longrun_wrk.sh threads(-t) connections(-c)  duration(-d) url(-u)  interval(-i)
# example:
# sh longrun_wrk.sh 8 8 30s 
# #wrk -t8 -c8 -d30s --csv  http://169.62.34.114/100MB.bin |awk '{if(NR>1)print}' >>result.csv
######################################################################


for((i=0;i<=280;i++))
do
    for u in $(cat url.txt)
    do
        if [[ "$1" == "" ]] || [[ "$2" == "" ]] || [[ "$3" == "" ]]
        then
            echo "threads or connections or duration should not be null"
            break 2
        else
            echo "t = $1,c = $2，d = $3 "
            echo "i= $i"
          if ((i==0))
          then 
            echo " wrk -t $1 -c $2 -d $3 $u > test_wrk.csv"
            wrk -t $1 -c $2 -d $3 $u --csv > test_wrk.csv
          else
            echo " wrk -t $1 -c $2 -d $3 $u >> test_wrk.csv"
            wrk -t $1 -c $2 -d $3 $u --csv|awk '{if(NR>1)print}' >> test_wrk.csv
           fi 
           continue
        fi
    done
    sleep 1m
done
