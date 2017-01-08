#!/bin/bash
#v2.0  20150504
#v2.1  20160217


if [ $0 != "-bash" ];then
    exit_cmd='exit'
else
    exit_cmd='return'
fi

#list buildsetting shell script for select
path_prefix=buildsettings
file_prefix=list_
keyword=messi

script_list_all=`ls ${path_prefix}/${file_prefix}*.sh | grep  -i "${keyword}"`

echo "param is $*"

for para in $@;do
    if [[ -z $para ]]; then
        break
    fi

    script_list_all=$(echo "$script_list_all" | grep -i $para)
    #echo "filter:$script_list_all"
done

if [[ -z ${script_list_all} ]]; then
    #statements
    echo "no file founded!"
    ${exit_cmd}
fi

PS3="Select:"

select script_file in ${script_list_all};
do
    if [ -z $script_file ]; then
        echo "Please select again!!";continue;
    else
        break;
    fi
done

if [ ! -f $script_file ]; then
    echo -e "\033[0;31m $script_file not exist!! \033[0m"
else
    echo -e "\033[0;31m$script_file\033[0m"
    echo "$script_file">../../currentprojmod.txt
    source $script_file;
fi


