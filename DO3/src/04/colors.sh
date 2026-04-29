#!/bin/bash

get_font_color() {
    case $1 in
        1) echo 37 ;;
        2) echo 31 ;;
        3) echo 32 ;;
        4) echo 34 ;;
        5) echo 35 ;;
        6) echo 30 ;;
    esac
}

get_bg_color() {
    case $1 in
        1) echo 47 ;;
        2) echo 41 ;;
        3) echo 42 ;;
        4) echo 44 ;;
        5) echo 45 ;;
        6) echo 40 ;;
    esac
}

color_name() {
    case $1 in
        1) echo white ;;
        2) echo red ;;
        3) echo green ;;
        4) echo blue ;;
        5) echo purple ;;
        6) echo black ;;
    esac
}

init_colors() {
    NAME_BG=$(get_bg_color $column1_background)
    NAME_FG=$(get_font_color $column1_font_color)
    VALUE_BG=$(get_bg_color $column2_background)
    VALUE_FG=$(get_font_color $column2_font_color)
}

print_line() {
    echo -e "\033[${NAME_BG};${NAME_FG}m$1\033[0m = \033[${VALUE_BG};${VALUE_FG}m$2\033[0m"
}

print_color_scheme() {

    echo

    if [ "$column1_background" -eq "$DEFAULT_COLUMN1_BG" ]; then
        echo "Column 1 background = default ($(color_name $DEFAULT_COLUMN1_BG))"
    else
        echo "Column 1 background = $column1_background ($(color_name $column1_background))"
    fi

    if [ "$column1_font_color" -eq "$DEFAULT_COLUMN1_FG" ]; then
        echo "Column 1 font color = default ($(color_name $DEFAULT_COLUMN1_FG))"
    else
        echo "Column 1 font color = $column1_font_color ($(color_name $column1_font_color))"
    fi

    if [ "$column2_background" -eq "$DEFAULT_COLUMN2_BG" ]; then
        echo "Column 2 background = default ($(color_name $DEFAULT_COLUMN2_BG))"
    else
        echo "Column 2 background = $column2_background ($(color_name $column2_background))"
    fi

    if [ "$column2_font_color" -eq "$DEFAULT_COLUMN2_FG" ]; then
        echo "Column 2 font color = default ($(color_name $DEFAULT_COLUMN2_FG))"
    else
        echo "Column 2 font color = $column2_font_color ($(color_name $column2_font_color))"
    fi
}