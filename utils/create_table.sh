#!/bin/bash

function parse_schema() {
    for ((i = 3; i <= $#; i++)); do
        if [[ ${!i} =~ ^[[:alpha:]]+:[[:alpha:]]+$ ]]; then
            name=$(echo "${!i}" | cut -d ":" -f 1)
            type=$(echo "${!i}" | cut -d ":" -f 2)
            if [[ $(grep -cG "^${name}:" "../databases/${1}/.${2}.schema") -eq 0 && $type =~ ^(int|str)$ ]]; then
                echo "${i}" >>"../databases/${1}/.${2}.schema"
                continue
            fi
        fi
        echo "Invalid schema at arg ${i}: ${!i}"
        ./drop_table "$1" "$2"
        return 1
    done
    return 0
}

if [[ $# -eq 0 ]]; then
    echo "Usage: $(basename "${0}") <database_name> <table_name> <pk_name:pk_type> <attribute1_name:attribute1_type> <attribute2_name:attribute2_type>"
    exit 1
elif [[ ! -d "../databases/${1}" ]]; then
    echo "Database does not exist"
    exit 1
elif [[ -f "../databases/${1}/${2}" ]]; then
    echo "Table already exists"
    exit 1
else
    touch "../databases/${1}/${2}.csv"
    touch "../databases/${1}/.${2}.schema"
    parse_schema "${@}"
fi
