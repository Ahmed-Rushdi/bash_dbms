#!/bin/bash
cd "$(dirname "${0}")"
# save the schema args data types in an array.

function read_schema() {

  schema_file="../databases/$1/.$2.schema"
  data_types_array=()

  if [ -f "$schema_file" ]; then

    while IFS= read -r line; do

      data_type=$(echo "$line" | cut -d ':' -f2)
      nullable=$(echo "$line" | cut -d ':' -f3)

      if [[ "$data_type" ]]; then
        data_types_array+=("$data_type:$nullable")
      fi

    done <"$schema_file"
  else
    echo " schema file not found "
    return 1
  fi
  echo "${data_types_array[@]}"

}

function insert_entries() {
  database_name=$1
  table_name=$2

  IFS=" " read -r -a array_schema <<<"$(read_schema "$database_name" "$table_name")"
  shift 2
  args=$#

  # first lets check if the args are the same

  if [[ $args -ne ${#array_schema[@]} ]]; then
    echo " Incorrect number of Entries: Entries should be as follows: Table  ${array_schema[*]}"
    return 1
  fi
  # lets check each argument with the data type from the schema respectively

  index=0

  for input in $@; do
    type=${array_schema[$index]%:*}
    case "$type" in
    "int")
      check_null="${array_schema[$index]#*:}"
      if [[ $check_null =~ ^[Yy]$ ]]; then
        if ! [[ "$input" =~ ^([0-9]+|NULL)$ ]]; then

          echo " the field you entered ${input} is not of type int "
          return 1

        fi
      else
        if ! [[ "$input" =~ ^[0-9]+$ ]]; then

          echo " the field you entered ${input} is not of type int "
          return 1
        fi

      fi
      ;;
    "str")

      if [[ "${input}" =~ ^(.*?,).*$ ]]; then

        echo " the field you entered ${input} is not an allowed string"
        return 1
      fi
      ;;

    *)
      echo " wrong data type "
      return 1
      ;;

    esac
    ((index++))

  done
  # now we checked that each argument is corectly entered as opposed to the table's schema
  data_entered=""
  delimeter=","

  for arg in "$@"; do
    data_entered+="$arg$delimeter"
  done

  data_entered="${data_entered::-1}"
  #  sed -i -e '$a\' -e "$data_entered" "../databases/$database_name/$table_name.csv"
  pk=$(echo "$data_entered" | cut -d ',' -f1)
  if [[ $(grep -cG "^$pk," "../databases/$database_name/$table_name.csv") -ne 0 ]]; then
    echo "Duplicate primary key"
    return 1
  fi

  echo "$data_entered" >>"../databases/$database_name/$table_name.csv"
  echo "Inserted successfully"
  return 0

}

insert_entries $@
exit $?
