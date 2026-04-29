#!/bin/bash

check_args_count() {
    if [ "$#" -ne 1 ]; then
        echo "Invalid number of arguments"
        exit 1
    fi
}

check_if_empty() {
    if [ -z "$1" ]
    then
        echo "Empty parameter"
        exit 1
    fi
}

check_if_number() {
    local value="$1"

    if [[ "$value" =~ ^-?[0-9]+$ ]]; then
        echo "Invalid input. A number was entered. Text was expected"
        exit 1
    fi
}