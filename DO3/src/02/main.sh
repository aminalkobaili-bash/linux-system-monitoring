#!/bin/bash

source ./system_info.sh
source ./save_to_file.sh

check_no_args "$@"
collect_system_info
print_system_info
ask_to_save