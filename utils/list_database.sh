#!/bin/bash

databases="$PWD"

list_databases(){
    echo hi

  # match only directories
  number_of_databases=("$databases"/*)
  
  if [[ ${#number_of_databases[@]} -eq 0 ]]; then

  echo "There are no databases"
  
  fi

  count=0;

for database in "${number_of_databases[@]}"; do
   
    if [[ -d $database ]]; then    


     ((count++))

      echo "database $count : $database"

    fi  


done

}

list_databases