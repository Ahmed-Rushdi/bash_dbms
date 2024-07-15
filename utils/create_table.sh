#!/bin/bash

function parse_schema() {
    for i in "${@:3}"; do
        #      attr=$(echo "${i}" | cut -d ":" 2> /dev/null)
        #      WIP split attibute on ':'
        if [[ ${#attr} -ne 2 ]]; then
            echo "Invalid schema"
            ./drop_table "$1" "$2"
            return 0
        fi
        echo "${i}" >>"../databases/${1}/.${2}.schema"
    done
}
parse_schema "${@}"
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
    parse_schema "${@:1}"
fi
