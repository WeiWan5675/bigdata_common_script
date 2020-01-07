#!/bin/bash
 
echo "Enter a file name :"
root_path=$1
read file
if [ -e $root_path/$a ];then
    echo "the file is exist!"
else
    echo "the file is not exist!"
fi
