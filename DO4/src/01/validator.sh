#!/bin/bash

validate_params(){
if [[ $# -ne 6 ]]
    then
      echo "Invalid number of arguments."
      exit 1
fi

local path=$1
local folder_count=$2
local folder_letters=$3
local files_count=$4
local file_pattern=$5
local file_size=$6

    if [[ ! -e "$path" ]]; then
        echo "Error: Path does not exist"
        exit 1
    fi

    if [[ ! $path =~ ^/ ]]; then
        echo "Error: Path must be absolute"
        exit 1
    fi

    if [[ ! $folder_count =~ ^[0-9]+$ ]]; then
        echo "Error: Folder count must be a number"
        exit 1
    fi

    if [[ ! $files_count =~ ^[0-9]+$ ]]; then
        echo "Error: Files count must be a number"
        exit 1
    fi

    if [[ ! $folder_letters =~ ^[a-zA-Z]{1,7}$ ]]; then
        echo "Error: Folder letters must contain only letters (max 7)"
        exit 1
    fi

    if [[ ! $file_pattern =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
        echo "Error: File pattern must be name.ext"
        exit 1
    fi

    if [[ ! $file_size =~ ^[0-9]+kb$ ]]; then
        echo "Error: File size must be like 10kb"
        exit 1
    fi

    local size=${file_size%kb}

    if (( size > 100 )); then
        echo "Error: File size must be <= 100kb"
        exit 1
    fi
}

