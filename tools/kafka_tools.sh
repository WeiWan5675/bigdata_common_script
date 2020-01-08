#!/bin/bash


#kafka操作脚本
############################################################
#
#       功能描述: kafka操作工具
#       修改者: 肖振男
#       修改时间: 2019.1.3
#       版本: v1.0
#
#
#
#############################################################
source /etc/profile
echo "=============================== $1 start =================================="


case $1 in
   list)
	resultList=`kafka-topics --list --zookeeper bigdata01:2181`
	echo $resultList
        ;;
   pull)
	kafka-console-consumer --zookeeper node1:2181,node2:2181,node3:2181 --from-beginning --topic $2
        ;;
   push)
	kafka-console-producer --broker-list node1:9092,node2:9092,node3:9092 --topic $2
   	;;
   delete)
	kafka-topics --delete --zookeeper node1:2181,node2:2181,node3:2181 --topic $2
	;;
   create)
	echo "create topic $2"
	kafka-topics --create --zookeeper  node1:2181,node2:2181,node3:2181 --replication-factor 2 --partitions 2 --topic $2
	;;
   *)
	echo "use {list,pull [topic],push [topic],delete [topic],create [topic]}"
esac


echo "=============================== $1 end =================================="

