#!/bin/bash
if [[ $# -eq 0 ]]; then
    echo "Usage: $(basename $0) <database_name>"
    exit 1
elif [ -d "../databases/$1" ]; then
    rm -rf "../databases/$1"
else
    echo "Database does not exist: $1"
fi
