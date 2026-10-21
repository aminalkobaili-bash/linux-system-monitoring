#!/bin/bash

source ./config_loader.sh
source ./validator.sh
source ./colors.sh
source ./system_info.sh

check_no_args "$@"
load_config
validate_config
init_colors
collect_system_info
print_system_info
print_color_scheme