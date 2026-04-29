#!/bin/bash

validate_config() {

    for param in $column1_background $column1_font_color \
                 $column2_background $column2_font_color
    do
        if ! [[ "$param" =~ ^[1-6]$ ]]; then
            echo "Error: Config values must be numbers from 1 to 6"
            exit 1
        fi
    done

    if [ "$column1_background" -eq "$column1_font_color" ] || \
       [ "$column2_background" -eq "$column2_font_color" ]; then
        echo "Error: Font and background colours must not match in one column."
        exit 1
    fi
}

check_no_args() {
    if [ "$#" -ne 0 ]
    then
        echo "Error: script must be run without parameters."
        exit 1
    fi
}