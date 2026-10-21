#!/bin/bash

START_TIME=$(date +%s.%N)

source ./functions.sh

validate_input "$@"

DIR="$1"

count_folders "$DIR"
top_folders "$DIR"
count_files "$DIR"
count_file_types "$DIR"
top_files "$DIR"
top_exec_files "$DIR"

END_TIME=$(date +%s.%N)
EXEC_TIME=$(echo "$END_TIME - $START_TIME" | bc)

echo "Script execution time (in seconds) = $EXEC_TIME"