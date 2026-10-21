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

generate_structure() {

    local base_path=$1
    local folder_count=$2
    local folder_letters=$3
    local files_count=$4
    local file_pattern=$5
    local file_size=$6

    local name_letters=${file_pattern%.*}
    local ext_letters=${file_pattern#*.}

    local size=${file_size%kb}

    local log_file="$base_path/generator.log"

    mkdir -p "$base_path"

    for (( i=1; i<=folder_count; i++ ))
    do

        check_disk_space
        
        folder_name=$(generate_name "$folder_letters" "$i")
        folder_path="$base_path/$folder_name"

        mkdir -p "$folder_path"

        write_log "$folder_path" "-" "$log_file"

        for (( j=1; j<=files_count; j++ ))
        do

            check_disk_space

            file_name=$(generate_name "$name_letters" "$j")
	    ext="$ext_letters"

	    while [[ ${#ext} -lt 3 ]]
	        do
	            ext="${ext_letters:0:1}$ext"
	        done

            file_path="$folder_path/${file_name}.${ext}"

            truncate -s "${size}K" "$file_path"

            write_log "$file_path" "$file_size" "$log_file"

        done

    done
}
