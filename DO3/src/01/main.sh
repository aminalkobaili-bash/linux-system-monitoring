#!/bin/bash

source ./validator.sh

check_args_count "$@"

value="$1"

check_if_empty "$1"

check_if_number "$value"

echo "Parameter value: $value"