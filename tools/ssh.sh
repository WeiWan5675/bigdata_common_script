#!/bin/bash

nodes=`cat ip.list` 

for node in $nodes
do
ssh -tt $node << EOF
echo "测试"
exit
EOF
echo $node
done
