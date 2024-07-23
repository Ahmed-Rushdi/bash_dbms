#!/bin/bash

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
declare -a to_delete

  output=$(
    ../parsers/parse_condition.sh "${@:1:2}" "$3"
    exit $?
  )
  if [ $? -ne 0 ]; then
    echo "$output"
    exit 1
  fi
  IFS=" " read -ra to_delete <<<"$output"

# sort the array lines to be deleted descendingly so it does not affect the order of the table records
IFS=$'\n' sorted_to_delete=($(sort -nr <<<"${to_delete[*]}"))
unset IFS
echo "${sorted_to_delete[@]}"
# using sed d directive to make delete command per line and save them in an array
 delete_final=""
  for index in "${sorted_to_delete[@]}"; do
    delete_final+="${index}d;"
  done
    echo "${delete_final}"
    echo "-i" "${delete_final}" "../databases/$1/$2.csv"
    sed -i "${delete_final}" "../databases/$1/$2.csv"
fi