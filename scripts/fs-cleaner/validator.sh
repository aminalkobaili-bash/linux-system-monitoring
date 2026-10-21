#!/bin/bash

validate_params() {

if [[ $# -ne 1 ]]
then
    echo "Error: script requires 1 parameter (1, 2 or 3)"
    exit 1
fi

if [[ ! $1 =~ ^[123]$ ]]
then
    echo "Error: parameter must be 1, 2 or 3"
    exit 1
fi

}
