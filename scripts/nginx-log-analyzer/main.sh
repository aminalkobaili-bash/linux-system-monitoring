#!/bin/bash

if [[ $# -ne 1 ]]
then
echo "Main should start be with 1 parameter"
exit 1
fi

MODE=$1

if [[ $MODE -lt 1 || $MODE -gt 4 ]]
then
echo "Parameter must be 1-4"
exit 1
fi

LOGS=../04/access_log_*.log

case $MODE in

1)

awk '{print $0}' $LOGS | sort -k9 -n

;;

2)

awk '{print $1}' $LOGS | sort | uniq

;;

3)

awk '$9 >= 400 && $9 < 600 {print $0}' $LOGS

;;

4)

awk '$9 >= 400 && $9 < 600 {print $1}' $LOGS | sort | uniq

;;

esac
