#!/bin/bash

source ./validator.sh
source ./cleaner.sh

validate_params "$@"

MODE=$1

case $MODE in
1)
    clean_by_log
    ;;
2)
    clean_by_time
    ;;
3)
    clean_by_mask
    ;;
esac
