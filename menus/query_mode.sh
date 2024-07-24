#!/bin/bash
cd "$(dirname "$0")"
read -r -p "Please enter a line of text: " -a array

case "${array[0]}" in 
"insert")
    if [[ "${array[1]}" == "into" ]]; then
       table="${array[1]}"
       column=$(echo "${array[3]}" | tr -d '()')
       values=$(echo "${array[5]}" | tr -d '()')
       ./insert.sh "$table" "$columns" "$values"
       else
       echo " invalid query, Usage: INSERT INTO table (columns) VALUES (values) "
    fi
    ;;
"select")
    if [[ "${array[2]}" == "FROM" ]]; then
        columns="${array[1]}"
        table="${array[3]}"
        if [[ "${array[@]: -2: 1}" == "WHERE" ]]; then
            condition="${array[@]: -1}"
            ./select.sh "$columns" "$table" "$condition"
        else
            ./select.sh "$columns" "$table"
        fi
        else
            echo "invalid select query"
    fi
    ;;
"update")
    if [[ "$array[2]" == "set" ]]; then
        table="${array[1]}"
        updates="${array[3]}"
        if [[ "${array[@]: -2: 1}" == "WHERE" ]]; then
            condition="${array[@]: -1}"
            ./update.sh "$table" "$updates" "$condition"
        else
            ./update.sh "$table" "$updates"
        fi
    else
         echo "invalid update query"
    fi
    ;;
"delete")
    if [[ "${array[1]}" == "FROM" ]]; then
            table="${array[2]}"
        if [[ "${array[@]: -2: 1}" == "WHERE" ]]; then
            condition="${array[@]: -1}"
            ./delete.sh "$table" "$condition"
    else
        echo "invalid delete query, usage: delete from table where condition"
    fi
    ;;
"drop")
    table="${array[1]}"
    ./drop_table.sh "$table"
    ;;
*)
   echo " invalid query"
   ;;
esac


       
