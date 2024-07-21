#!/bin/bash
cd "$(dirname "${0}")"
function parse_schema() {
  for ((i = 3; i <= $#; i++)); do
    if [[ ${!i} =~ ^[[:alpha:]]+:[[:alpha:]]+(:[[:alpha:]])?$ ]]; then
      name=$(echo "${!i}" | cut -d ":" -f 1)
      type=$(echo "${!i}" | cut -d ":" -f 2)
      if [[ $i -gt 3 ]]; then
        nullable=$(echo "${!i}" | cut -d ":" -f 3)
      else
        nullable="N"
      fi
      if [[ $(grep -cG "^${name}:" "../databases/${1}/.${2}.schema") -eq 0 && $type =~ ^(int|str)$ && $nullable =~ ^(y|n|Y|N)$ ]]; then
        echo "${name}:${type}:${nullable}" >> "../databases/${1}/.${2}.schema"
        continue
      fi
    fi
    echo "Invalid schema at attribute $(( i-2 )): ${!i}"
    ./drop_table.sh "$1" "$2"
    return 1
  done
  return 0
}

if [[ $# -lt 3 ]]; then
  echo "Usage: $(basename "${0}") <database_name> <table_name> <pk_name:pk_type> <attribute1_name:attribute1_type:nullable> <attribute2_name:attribute2_type:nullable>"
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
