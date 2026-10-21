#!/bin/bash

# Same output as main.sh, then offers to save it to DD_MM_YY_HH_MM_SS.status

source ./config_loader.sh
source ./validator.sh
source ./colors.sh
source ./system_info.sh
source ./save_to_file.sh

check_no_args "$@"
load_config
validate_config
init_colors
collect_system_info
print_system_info
ask_to_save
