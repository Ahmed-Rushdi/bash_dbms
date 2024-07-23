#!/bin/bash

cd "$(dirname "${0}")"
PS3="Choose an option: "

select REPLY in "List databases" "Connect to database" "Create database" "Drop database" "Exit"; do
  case $REPLY in
  "List databases")
    ../utils/list_database.sh
    ;;
  "Connect to database")
    read -p "Enter database name : " db_name
    export database_name=$(
      ../utils/connect_database.sh "$db_name"
      exit $?
    )
    if [ $? -eq 0 ]; then
      echo "database $db_name connected successfully"
      ./table_menu.sh
    else
      echo "database $db_name does not exist"
      unset database_name
    fi
    ;;
  "Create database")
    read -p "Enter database name : " db_name
    ../utils/create_database.sh "$db_name"
    if [ $? -eq 0 ]; then
      echo "database $db_name created successfully"
    fi
    ;;
  "Drop database")
    read -p "Enter database name : " db_name
    ../utils/drop_database.sh "$db_name"
    if [ $? -eq 0 ]; then
      echo "database $db_name dropped successfully"
    fi
    ;;
  "Exit")
    exit 0
    ;;
  *)
    echo "invalid option $REPLY"
    ;;
  esac
  REPLY=
  echo "---------------"
done
