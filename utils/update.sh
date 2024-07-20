#!/bin/bash
function parse_condition() {
  
}

function parse_attribute() {

}

function parse_update() {
    
}

if [ $# -lt 3 ]; then
  echo "Usage: $(basename $0) <database_name> <table_name> <condition1,condition2,condition3,...> <first_attribute_name:new_attribute_value,second_attribute_name:new_attribute_value,third_attribute_name:new_attribute_value>"
  exit 1
elif [[ ! -d "../databases/$1" ]]; then
  echo "Database does not exist: $1"
  exit 1
elif [[ ! -f "../databases/$1/$2.csv" ]]; then
  echo "Table does not exist: $2"
  exit 1
elif [[ $(grep -cG "^$3:" "../databases/$1/.$2.schema") -eq 0 ]]; then
  echo "Attribute does not exist: $3"
fi
