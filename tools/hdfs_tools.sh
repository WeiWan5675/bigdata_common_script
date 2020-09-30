#!/bin/bash

source ${SCRIPT_HOME}/env/common_setting.sh
############################################################
#
#       功能描述: hdfs操作脚本
#       修改者: 肖振男
#       修改时间: 2019.1.3
#       版本: v1.0
#
#
#
#############################################################


#拉取文件到本地
get_file ()
{
source_path="$1"
target_path="$2"
ismerge="$3"
if [ ! -n "$ismerge" ]; then
	hdfs dfs -get $source_path $target_path
else
	hdfs dfs -getmerge $source_path $target_path
fi

}



put_file ()
{
source_path="$1"
target_path="$2"
hdfs dfs -put $source_path $target_path

}


del_file ()
{
del_path="$1"
hdfs dfs -rm -r $del_path
}


create_dir ()
{
dir_path="$1"
hdfs dfs -mkdir -p $dir_path
}

copy_dir ()
{
source_path="$1"
target_path="$2"
hdfs dfs cp $source_path $target_path
}



look_usage()
{
look_path="$1"
if [ ! -n "$look_path" ]; then
	hdfs dfs -du -h /
else
	hdfs dfs -du -h $look_path
fi
}

report()
{
logger_info "------------------------------------------------------------------------"
hdfs dfsadmin -report
logger_info "------------------------------------------------------------------------"
}

safemode()
{
switch="$1"
case $switch in
	"enter")
	hdfs dfsadmin -safemode enter
	;;
	"leave")
	hdfs dfsadmin -safemode leave
	;;
	"get")
	hdfs dfsadmin -safemode get
	;;
	"wait")
	hdfs dfsadmin -safemode "wait"
	;;
esac
}

cmd="$1"
case $cmd in
	"get_file")
		get_file "$2" "$3" "$4"
	;;
	"put_file")
		put_file "$2" "$3"
	;;
	"del_file")
		del_file "$2"
	;;
	"create_dir")
		create_dir "$2"
	;;
	"copy_dir")
		copy_dir "$2" "$3"
	;;
	"look_usage")
		look_usage "$2"
	;;
	"report")
		report 
	;;
	"safemode")
		safemode "$2"
	;;
	*)
	echo "没有匹配的操作"
	;; 
esac
