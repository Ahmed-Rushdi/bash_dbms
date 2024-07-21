#!/bin/bash

# save the schema arguments data types in an array.

function read_schema() {

schema_file="$1.schema";
data_types_array=();

if [ -f "$schema_file" ]; then
   
   while IFS= read -r line; do

      data_type=$( "$line" | cut -d ':' -f2 )

      if [ -n "$data_type" ]; then

        data_types_array+=($data_type)
      fi
    
    done 

else 

    echo " schema file not found "

    return 1

fi

    echo "${data_types_array[@]}"

}




function insert_entries(){

table_name=$1

arguments=$#

array_schema=$(read_schema "$table_name")

shift


# first lets check if the arguments are the same 

 if ( arguments -nq echo ${#array_schema[@]} ); then

    echo " Incorrect number of Entries: Entries should be as follows: Table  ${array_schema[*@]}" 

    return 1;
fi

# lets check each argument with the data type from the schema respectively 

index=0

for input in "$@"; do

  case "${array_schema[$index]}" in 

    "int") 
        
        if ! [[ "$input" =~ ^[0-9]+$ ]]; then 

          echo " the field you entered ${input} is not of type int "

          return 1
        fi 
        ;;
    "string")

        if ! [[ "${input}" =~ ^[a-zA-Z][^,] ]]; then

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
delimeter="  "

for arg in "$@"; do 
   
   data_entered+="$delimeter$arg"
done

# append data_enetered to the file 

echo "$data_entered"  >> "$table_name"

return 0

}
