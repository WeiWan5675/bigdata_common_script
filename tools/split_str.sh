#!/bin/bash

str=$1
split=$2

if [ ! -n "$split" ]; then
split=","
#echo "使用默认分隔符"
fi


array=(${str//${split}/ })  
for var in ${array[@]}
do
   echo $var
done

