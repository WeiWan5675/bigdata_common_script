#!/bin/bash


work_dir=$1


for file in `ls $work_dir`
do
dos2unix -n -k $work_dir/$file ./tmp/tttt/$file
echo "处理:"$dir
done
