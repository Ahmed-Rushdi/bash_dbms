#!/bin/bash
cd "$(dirname "$0")"

if [[ $# -eq 0 ]]; then
  ./menus/database_menu.sh
elif [[ $# -eq 1 ]]; then
  if [[ $1 == "-h" || $1 == "--help" ]]; then
    cat <<EOF
Usage: $(basename $0) [-h|--help] [-Q|--query]
[-h|--help] to display help page
[-Q|--query] for query mode"
EOF
    exit 0

  elif [[ $1 == "-Q" || $1 == "--query" ]]; then
    ./menus/query_mode.sh
  else
    echo "Invalid argument: $1 use -h or --help"
  fi
else
  echo "Invalid number of arguments: $# use -h or --help"
  exit 1
fi

