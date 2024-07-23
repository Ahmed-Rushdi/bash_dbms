#!/bin/bash
cd "$(dirname "$0")"
if [[ $# -lt 3 ]]; then
  echo "Usage: $(basename $0) <database_name> <table_name> <condition> <first_attribute_name:new_attribute_value,second_attribute_name:new_attribute_value,third_attribute_name:new_attribute_value>"
  exit 1
elif [[ ! -d "../databases/$1" ]]; then
  echo "Database does not exist: $1"
  exit 1
elif [[ ! -f "../databases/$1/$2.csv" ]]; then
  echo "Table does not exist: $2"
  exit 1
#elif [[ $(grep -cG "^$3:" "../databases/$1/.$2.schema") -eq 0 ]]; then
#  echo "Attribute does not exist: $3"
else
  output=$(
    ../parsers/parse_condition.sh "${@:1:2}" "$3"
    exit $?
  )
  if [[ $? -ne 0 ]]; then
    echo "$output"
    exit 1
  fi
  IFS=" " read -ra lines <<<"$output"

  declare -A values
  IFS="," read -ra names_values <<<"$4"
  for name_value in "${names_values[@]}"; do
    key=$(echo "$name_value" | cut -d ':' -f1)
    value=$(echo "$name_value" | cut -d ':' -f2)
    if [[ $(grep -cG "^$key:" "../databases/$1/.$2.schema") -eq 0 ]]; then
      echo "Attribute does not exist: $key"
      exit 1
    elif [[ $value == "NULL" && $(grep -cG "^$key:(int|str):[nN]$" "../databases/$1/.$2.schema") -eq 0 ]]; then
      echo "Invalid value: $value for $key (not nullable)"
      exit 1
    elif [[ ! $value =~ ^([[:digit:]]+|NULL)$ && $(grep -cG "^$key:int:[yY]$" "../databases/$1/.$2.schema") -eq 1 ]]; then
      echo "Invalid value: $value for $key (int not str)"
      exit 1
    else
      key_pos=$(grep -nG "^$key:" "../databases/$1/.$2.schema" | cut -d ':' -f1)
      key_pos=$((key_pos - 1))
      if [[ $key_pos -eq 0 && $(grep -cG "^$value," "../databases/$1/$2.csv") -ne 0 ]]; then
        echo "Invalid value: repeated primary key $key $value"
        exit 1
      fi
    fi
    values[$key_pos]="$value"
  done
  #  for line in "${lines[@]}"; do
  #    for key_pos in "${!values[@]}"; do
  #      sed -iE "${line}s/^((.+?,){${key_pos})[^,]+?(,.*)$/\1${values[$key_pos]}\3/g" "../databases/$1/$2.csv"
  #    done
  #  done
#  cat <<EOF
#$(for line in "${lines[@]}"; do
#    for key_pos in "${!values[@]}"; do
#      echo "${line}s/^((.+?,){${key_pos}})[^,]+?(,.*)$/\1${values[$key_pos]}\3/g"
#    done
#  done)
#EOF
  sed -i -E -f - "../databases/$1/$2.csv" <<EOF
$(for line in "${lines[@]}"; do
    for key_pos in "${!values[@]}"; do
      echo "${line}s/^((.+?,){${key_pos}})[^,]+?(,.*)$/\1${values[$key_pos]}\3/g"
    done
  done)
EOF
  echo "Updated ${#lines[@]} rows in $2 successfully"
  exit 0
fi
