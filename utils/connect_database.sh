#!/bin/bash

cd "$(dirname "${0}")"

connect_database(){

databases="../databases"
database_name=$1

 #### starts with alphapetic ####
#if [[ $database_name =~ ^[a-zA-z][a-zA-Z0-9_]+$ ]]; then
    if [ ! -d "$databases/$database_name" ]; then
     echo " database does not exist"
    else 
    echo "$database_name"
    fi
#else
#echo "enter database name correctly- only alphapets and unserscores are allowed"
#fi
}
if [ $# -ne 1 ]; then
   echo "please enter only one database name"
else
connect_database "$1"
fi