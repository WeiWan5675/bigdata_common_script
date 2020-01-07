#!/bin/bash


source /etc/profile
nodes="node01 node02"
for node in $nodes
do
	echo "开始推送${node}"
	scp -r $1 hdata@${node}:$2
done
