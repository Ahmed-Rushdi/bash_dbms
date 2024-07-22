#!/bin/bash
cd "$(dirname "${0}")"
select REPLY in  "List databases" "Connect to database" "Create database" "Drop database" "Exit"; do
  case $REPLY in
    "List databases")
      ../utils/list_database.sh
      ;;
    "Connect to database")

#      ../utils/connect_database.sh
      ;;
    "Create database")

#      ../utils/create_database.sh
      ;;
    "Drop database")

#      ../utils/drop_database.sh
      ;;
    "Exit")
      exit
      ;;
    *)
      echo "invalid option $REPLY"
      ;;
  esac
done