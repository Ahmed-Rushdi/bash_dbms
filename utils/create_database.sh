#!/bin/bash
cd "$(dirname "$0")"
if [[ $# -eq 0 ]]; then
  echo "Usage: $(basename $0) <database_name>"
  exit 1
elif [ -d "../databases/$1" ]; then
  echo "Database already exists"
  exit 1
else
  mkdir "../databases/$1"
  #  echo "database $1 created successfully"
  exit 0
fi
