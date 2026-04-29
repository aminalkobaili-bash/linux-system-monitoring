#!/bin/bash

if [[ $# -ne 0 ]]; then
echo "This script does not accept parameters"
exit 1
fi

source generator.sh

generate_logs