#!/bin/bash

# select database tablename condition

cd "$(dirname "$0")"

if [[ $# -lt 3 ]]; then
  echo " Usage $(basename $0) <database_name> <table_name> condition( <field_name condition value> )"
  exit 1
elif [[ ! -d "../databases/$1" ]]; then
  echo "Database does not exist: $1"
  exit 1
elif [[ ! -f "../databases/$1/$2.csv" ]]; then
  echo "Table does not exist: $2"
  exit 1
#elif [[ $(grep -cG "^$3:" "../databases/$1/.$2.schema") -eq 0 ]]; then
#  echo "Field does not exist: $3"
else
  # pass the arguments to the parse_condition script to find matching lines in the table !
  declare -a selected_lines
  output=$(
    ../parsers/parse_condition.sh "${@:1:2}" "$3"
    exit $?
  )
  if [ $? -ne 0 ]; then
    echo "$output"
    exit 1
  fi
  IFS=" " read -ra selected_lines <<<"$output"

  # exit  if condition was not met

  echo "Selected lines: ${#selected_lines[@]}"
  for line in "${selected_lines[@]}"; do
    awk -v line="$line" 'NR == line { print }' "../databases/$1/$2.csv"
  done
  exit 0
fi
