#!/bin/bash

validate_params(){

if [[ $# -ne 3 ]]
then
echo "Invalid number of arguments."
exit 1
fi

local folder_letters=$1
local file_pattern=$2
local file_size=$3

if [[ ! $folder_letters =~ ^[a-zA-Z]{1,7}$ ]]
then
echo "Error: Folder letters must contain only letters"
exit 1
fi

if [[ ! $file_pattern =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]
then
echo "Error: File pattern must be name.ext"
exit 1
fi

if [[ ! $file_size =~ ^[0-9]+Mb$ ]]
then
echo "Error: File size must be like 10Mb"
exit 1
fi

local size=${file_size%Mb}

if (( size > 100 ))
then
echo "Error: File size must be <= 100Mb"
exit 1
fi

}
