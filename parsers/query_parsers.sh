#!/bin/bash

cd "$(dirname "$0")"

read -r -p "Please enter a line of text: " -a array

case "${array[0]}" in 
"insert")
    if [[ "${array[1]}" == "into" && "${array[3]}" == "values" ]]; then
        table="${array[2]}"
        values="${array[*]:4}"
        values=$(echo "$values" | tr -d '()')
        ./insert.sh "$table" "$values"
    else
        echo "invalid insert query"
    fi
    ;;
"select")
    if [[ "${array[2]}" == "from" ]]; then
        columns="${array[1]}"
        table="${array[3]}"
        if [[ "${array[*]: -2: 1}" == "where" ]]; then
            condition="${array[*]: -1}"
            ./select.sh "$columns" "$table" "$condition"
        else
            ./select.sh "$columns" "$table"
        fi
        else
            echo "invalid select query, usage: select from table condition"
    fi
    ;;
"update")
    if [[ "${array[3]}" == "set" ]]; then
        database_name="${array[1]}"
        table="${array[2]}"
        updates="${array[4]}"
        where_index=-1
        for i in "${!array[@]}"; do
            if [[ "${array[$i]}" == "where" ]]; then
                where_index=$i
                break
            fi
        done
        if [[ $where_index -ne -1 ]]; then
            condition="${array[*]:$((where_index + 1))}"
            ./update.sh "$database_name" "$table" "$updates" "$condition"
        else
            ./update.sh "$database_name" "$table" "$updates"
        fi
    else
        echo "invalid update query, Usage: update database_name table set updates where condition"
    fi
    ;;
"delete")
    if [[ "${array[1]}" == "from" ]]; then
            database_name="${array[2]}"
            table="${array[3]}"
        if [[ "${#array[*]: -2}" == "where" ]]; then
            condition="${array[*]: -1}"
            ./delete.sh "$database_name" "$table" "$condition"
    else
        echo "invalid delete query, usage: delete from database table where condition"
    fi
    fi
    ;;
"drop")
database_name="${array[1]}"
table="${array[2]}"
./drop_table.sh "$database_name" "$table"
;;
*)
echo " invalid query"
;;
esac
