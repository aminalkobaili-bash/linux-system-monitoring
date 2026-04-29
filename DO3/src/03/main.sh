#!/bin/bash

source ./validator.sh
source ./colors.sh
source ./system_info.sh

check_args_count "$@"
check_range "$@"
check_equal_colors "$@"

NAME_BG=$(get_bg_color "$1")
NAME_FG=$(get_font_color "$2")
VALUE_BG=$(get_bg_color "$3")
VALUE_FG=$(get_font_color "$4")

print_system_info