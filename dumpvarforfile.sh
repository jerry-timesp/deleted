#!/bin/bash

folderpath=${1:-none}
param=${2:none}

if [ ${folderpath} = "none"  -o ${param} = "none"  ]; then
    echo "please give a path and param"
    exit
fi

shfiles=$(ls ${folderpath}/*.sh)

for eachfile in ${shfiles}; do
    echo -n "${eachfile}: "
    result=$(grep ${param} ${eachfile})
    if [ -z ${result} ]; then
    echo -e "\033[0;31mnot found\033[0m"
    else
    echo -e "\033[0;32m${result}\033[0m"
    fi
done
