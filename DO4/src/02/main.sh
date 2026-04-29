#!/bin/bash

source ./validator.sh
source ./generator.sh

validate_params "$@"

FOLDER_LETTERS=$1
FILE_PATTERN=$2
FILE_SIZE=$3

LOG_FILE="/tmp/clogging_log.txt"

> "$LOG_FILE"

START_TIME=$(date +%s)
START_HUMAN=$(date '+%Y-%m-%d %H:%M:%S')

generate_structure "$FOLDER_LETTERS" "$FILE_PATTERN" "$FILE_SIZE"

END_TIME=$(date +%s)
END_HUMAN=$(date '+%Y-%m-%d %H:%M:%S')

DURATION=$((END_TIME - START_TIME))

echo "Start time: $START_HUMAN" >> "$LOG_FILE"
echo "End time: $END_HUMAN" >> "$LOG_FILE"
echo "Execution time: ${DURATION}s" >> "$LOG_FILE"
