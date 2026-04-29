#!/bin/bash

check_args_count() {
    if [ "$#" -ne 4 ]; then
        echo "Error: You must enter 4 parameters"
        echo "Example: ./main.sh 1 3 4 5"
        exit 1
    fi
}

check_range() {
    for param in "$@"
    do
        if ! [[ "$param" =~ ^[1-6]$ ]]; then
            echo "Error: Parameters must be numbers from 1 to 6"
            exit 1
        fi
    done
}

check_equal_colors() {
    if [ "$1" -eq "$2" ] || [ "$3" -eq "$4" ]; then
        echo "Error: Font and background colours must not match in one column"
        echo "Please run the script again with different parameters"
        exit 1
    fi
}