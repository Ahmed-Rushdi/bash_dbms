#!/bin/bash
cd "$(dirname "$0")"
if [[ $# -ne 3 ]]; then
  echo "Usage: $(basename $0) <database_name> <table_name> <condition>"
  exit 1
elif [[ ! -d "../databases/$1" ]]; then
  echo "Database does not exist: $1"
  exit 1
elif [[ ! -f "../databases/$1/$2.csv" ]]; then
  echo "Table does not exist: $2"
  exit 1
else
  cond_re="^([[:alpha:]]+)([<>=!]{1,2})([[:alnum:]]+)$"
  # Check for valid condition: (field eg. salary)(operator eg. >)(value eg. 10000) --> salary>10000
  if [[ ! $3 =~ $cond_re ]]; then
    echo "Invalid condition: $3"
    exit 1
  fi

  # Extract field, operator and value
  field=$(echo $3 | sed -E "s/$cond_re/\1/g")
  comp_op=$(echo $3 | sed -E "s/$cond_re/\2/g")
  value=$(echo $3 | sed -E "s/$cond_re/\3/g")
  v_type="str"
  # Check if value is an integer
  if [[ $value =~ ^[[:digit:]]+$ || $value == "NULL" ]]; then
    v_type="int"
  fi
  # Check if field exists in table schema
  if [[ $(grep -cG "^$field:" "../databases/$1/.$2.schema") -eq 0 ]]; then
    echo "Attribute does not exist: $field"
    exit 1
  # Check if operator is valid
  elif
    [[ $comp_op != "==" && $comp_op != ">" && $comp_op != "<" && $comp_op != ">=" && $comp_op != "<=" && $comp_op != "!=" ]]; then
    echo "Invalid operator: $comp_op"
    exit 1
  # Check if type of value matches type of field (specifically if field is integer)
  elif [[ $v_type == "str" && $(grep -cG "^$field:$v_type.*$" "../databases/$1/.$2.schema") -eq 0 ]]; then
    echo "Invalid value: $value for $field"
    exit 1
  fi
  field_number=$(grep -nG "^$field:" "../databases/$1/.$2.schema" | cut -d ":" -f 1)
  if [[ $(grep -cG "^$field:str" "../databases/$1/.$2.schema") -eq 1 ]]; then
    value="\"$value\""
  fi
  awk_cmd="awk -F ',' '{if (\$${field_number} ${comp_op} ${value}) print NR}' ../databases/$1/$2.csv"
  matched_rows=$(eval "$awk_cmd") # 1 5 15 25 40
  echo "$matched_rows" | tr '\n' ' '
  exit 0
fi
