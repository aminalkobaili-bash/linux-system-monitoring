#!/bin/bash

LOG_FILE="/tmp/clogging_log.txt"

clean_by_log() {

if [[ ! -f "$LOG_FILE" ]]
then
    echo "Log file not found"
    exit 1
fi

echo "Cleaning using log file..."

tac "$LOG_FILE" | while read line
do
    path=$(echo "$line" | awk '{print $1}')

    if [[ -e "$path" ]]
    then
        rm -rf "$path"
    fi
done

echo "Cleaning completed"

}

clean_by_time() {

echo "Enter start time (YYYY-MM-DD HH:MM)"
read start_time

echo "Enter end time (YYYY-MM-DD HH:MM)"
read end_time

echo "Cleaning files created between $start_time and $end_time"

find /tmp /var/tmp "$HOME" \
-newermt "$start_time" ! -newermt "$end_time" \
-name "*_[0-9][0-9][0-9][0-9][0-9][0-9]*" \
-exec rm -rf {} + 2>/dev/null

echo "Cleaning completed"

}

clean_by_mask() {

echo "Enter date mask (DDMMYY)"
read mask

echo "Cleaning using mask *_${mask}"

find /tmp /var/tmp "$HOME" \
-name "*_${mask}*" \
-exec rm -rf {} + 2>/dev/null

echo "Cleaning completed"

}
