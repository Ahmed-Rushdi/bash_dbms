#!/bin/bash

cd "$(dirname "$0")"

list_tables(){

    number_of_files=(../databases/"$1"/*)
    if [ ${#number_of_files[@]} -eq 0 ]; then
    echo "Data base is empty"
    fi

 for file in "${number_of_files[@]}"; do
     if [[ -f $file ]]; then
        if [[ $file == *.csv || $file == "${file}.schema" ]]; then
          table_name=$(basename $file)
          echo " table : ${table_name%.csv}"
#          echo " schema: .$file.schema"
        fi
    fi
done
}
list_tables $1
