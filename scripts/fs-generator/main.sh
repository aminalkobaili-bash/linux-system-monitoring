#!/bin/bash

source validator.sh
source generator.sh

validate_params "$@"

BASE_PATH=$1
FOLDER_COUNT=$2
FOLDER_LETTERS=$3
FILES_COUNT=$4
FILE_PATTERN=$5
FILE_SIZE=$6

generate_structure "$BASE_PATH" "$FOLDER_COUNT" "$FOLDER_LETTERS" "$FILES_COUNT" "$FILE_PATTERN" "$FILE_SIZE"
