#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Usage: $(basename $0) <database_name> <table_name>"
  exit 1
elif [[ ! -d "../databases/$1" ]]; then
  echo "Database does not exist: $1"
  exit 1
elif [[ ! -f "../databases/$1/$2.csv" ]]; then
  echo "Table does not exist: $2"
  exit 1
else
  rm "../databases/$1/$2.csv"
  rm "../databases/$1/.$2.schema"
fi