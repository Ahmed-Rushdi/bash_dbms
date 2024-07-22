#!/bin/bash

cd "$(dirname "$0")"

list_tables(){

    number_of_files=("$database"/*)
    if [ ${#number_of_files[@]} -eq 0 ]; then
    echo "Data base is empty"
    fi

 for file in "${number_of_files[@]}"; do
     if [[ -f $file ]]; then
        if [[ $file == *.csv || $file == "${file}.schema" ]]; then
          echo " table : $file"
          echo " schema: $file.schema"
        fi
    fi
done
}
list_tables
