#!/bin/bash
cd "$(dirname "$0")"

if [[ $# -eq 0 ]]; then
  echo "Usage: $(basename $0) <database_name>"
  exit 1
elif [[ ! -d "../databases/$1" ]]; then
  echo "Database does not exist: $1"
  exit 1
else
  rm -r "../databases/$1"
  exit 0
fi
