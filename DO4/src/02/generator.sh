#!/bin/bash

generate_name() {

    local letters=$1
    local index=$2
    local date=$(date +%d%m%y)

    local name=""

    for ((i=0;i<index+4;i++))
    do
        name+=${letters:0:1}
    done

    name=${name:0:-1}${letters: -1}

    echo "${name}_${date}"
}

check_disk_space() {

    local free=$(df / --output=avail | tail -1)

    if (( free < 1048576 )); then
        echo "Less than 1GB free space. Script stopped."
        exit 1
    fi
}

write_log() {

    local path=$1
    local size=$2
    local log_file=$3

    echo "$path $(date '+%d.%m.%y') $size" >> "$log_file"
}

generate_structure(){

local folder_letters=$1
local file_pattern=$2
local file_size=$3

local name_letters=${file_pattern%.*}
local ext_letters=${file_pattern#*.}

local size=${file_size%Mb}

local LOG_FILE="/tmp/clogging_log.txt"

PATHS=(
"/tmp"
"/var/tmp"
"$HOME"
)

for base in "${PATHS[@]}"
do

DEPTH=$((RANDOM % 10 + 1))

CURRENT_PATH="$base"

for (( i=1;i<=DEPTH;i++ ))
do

check_disk_space

folder_name=$(generate_name "$folder_letters" "$i")

CURRENT_PATH="$CURRENT_PATH/$folder_name"

mkdir -p "$CURRENT_PATH"

write_log "$CURRENT_PATH" "-" "$LOG_FILE"

FILES=$((RANDOM % 10 + 1))

for (( j=1;j<=FILES;j++ ))
do

check_disk_space

file_name=$(generate_name "$name_letters" "$j")

ext="$ext_letters"

while [[ ${#ext} -lt 3 ]]
do
ext="${ext_letters:0:1}$ext"
done

file_path="$CURRENT_PATH/${file_name}.${ext}"

dd if=/dev/zero of="$file_path" bs=1M count="$size" status=none

write_log "$file_path" "$file_size" "$LOG_FILE"

done

done

done

}
