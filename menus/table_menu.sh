#!/bin/bash
cd "$(dirname "${0}")"
PS3=" Choose an option: "

select REPLY in "List tables" "select table" "Insert into table" "Create table" "update table" "delete table" "drop table" "Exit"; do
  case $REPLY in
  "List tables")
  ../utils/list_table.sh "$database_name"
  ;;
  "select table")
  read -p "Enter table name and condition (ex: table_name field_name condition value):"  table_name  condition
  ../utils/select.sh "$database_name" "$table_name"  "$condition"

  ;;
"Insert into table")
  read -p "Enter table name attributes separated by space (ex: table_name attr1 attr2 attr3 ..):"  table_name attr

  ../utils/insert.sh "$database_name" "$table_name" "$attr"
;;
  "Create table")
  read -p "Enter table name and the fields starting with PK (ex: table_name pk_name:pk_type attribute1_name:attribute1_type:nullable ...): " set_of_arguments
  # set will split the set_of_arguments into separated arguments
  set -- $set_of_arguments
  ../utils/create_table.sh "$database_name" "$@"
  ;;
  "update table")
  read -p "Enter table name and condition and values to update as follows (ex: <table_name> <condition> <attr_name:new_attr_val,attr_name:new_attr_val,...>): " table_name condition updated_values
  ../utils/update.sh "$database_name" "$table_name" "$condition" "$updated_values"
  echo here2
#  if [ $? -eq 0 ]; then
#      echo "table $table_name is updated successfully"
#  fi
  ;;
  "delete table")
  read -p "Enter table name and condition (ex: table_name field_name condition value):"  table_name  condition
  ../utils/delete.sh "$database_name" "$table_name" "$condition"
  if [ $? -eq 0 ]; then
      echo "table $table_name fields deleted successfully"
  fi
  ;;
  "drop table")
  read -p "Enter table name to be dropped :"  table_name
  ../utils/drop_table.sh "$database_name" "$table_name"
  if [ $? -eq 0 ]; then
      echo "table $table_name is dropped successfully"
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



