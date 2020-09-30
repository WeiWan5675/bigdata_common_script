#!/bin/bash

source ${SCRIPT_HOME}/env/common_setting.sh
############################################################
#
#       功能描述: hive操作工具
#       修改者: 肖振男
#       修改时间: 2019.1.3
#       版本: v1.0
#
#
#
#############################################################



run_flag=0

#执行sql文件
exec_sql_file ()
{

sql_file="${1}"
sql_parameter="${@:2}"
logger_info "开始执行hiveSQL,SQL文件: [$sql_file]"
hive_cmd="hive -f $sql_file --hivevar "
if [ -n "$sql_parameter" ]; then
    for var_p in `$TOOLS_DIR/split_str.sh $sql_parameter`
    do
        hive_cmd=$hive_cmd" "$var_p" --hivevar"
    done
fi
hive_cmd=${hive_cmd%--*}
logger_info "需要执行的hiveSQL: [$hive_cmd]"
$hive_cmd
flag_num=$?
logger_info "执行HiveSQL操作完成"
return $flag_num
}

#执行sql
exec_sql ()
{

hive_sql="${@:1}"
hive -e "$hive_sql"
flag_num=$?
return $flag_num
}


#truncate表
exec_truncate_table ()
{
database="${1}"
table="${@:2}"
 logger_info "开始执行清空hive表操作: [$database"."$table]"
 hive -e "use $database;truncate table $table;"
 flag_num=$?
 logger_info "执行清空hive表[$database"."$table]操作完成!"
return $flag_num
}

#删除表
exec_drop_table ()
{
database="${1}"
table="${@:2}"
 logger_info "开始执行删除hive表操作:  [$database"."$table]"
 hive -e "use $database;drop table $table;"
 flag_num=$?
 logger_info "执行删除hive表[$database"."$table]操作完成!"
return $flag_num
}


#删除分区
exec_drop_partition ()
{
database="${1}"
table="${2}"
condition="${@:3}"
 logger_info "开始执行删除hive表分区操作:[数据库:$database 数据表:$table 分区:$condition]"
 partition_key=`echo "$condition" | awk -F "=" '{print $1}'` 
 partition_value=`echo "$condition" | awk -F "=" '{print $2}'`
 hive -e "use $database;alter table $table drop partition($partition_key='$partition_value')"
 flag_num=$?
 logger_info "执行删除hive表分区[数据库:$database 数据表:$table 分区:$condition]操作完成!"
return $flag_num
}


#创建表
exec_create_table ()
{
database="${1}"
create="${@:2}"
 logger_info "开始执行创建hive表操作:[数据库:$database 建表语句文件:$create]"
 if [ -f "$2" ];then
	echo "需要执行的建表语句:"
	echo `cat ${2}`
	hive -f $2
 else
 	hive -e "use $database;$create;"
 fi
flag_num=$?
return $flag_num
}


#导入数据
exec_import_data ()
{
database="${1}"
table="${2}"
data_path=${@:3}
 logger_info "开始执行导入数据到hive表操作:[数据库:$database 数据表:$tabe 数据文件:$data_path}]"
 data_source=`echo "$data_path" | awk -F ":" '{print $1}'`
 file_path=`echo "$data_path" | awk -F ":" '{print $2}'`
 
 if [ $data_source = "hdfs" ];then
	hive -e "use $database;load data inpath '${file_path}' into table $table;"
 else
	hive -e "use $database;load data local inpath '${file_path}' into table $table"
 fi
flag_num=$?
 logger_info "执行导入数据到hive表:[数据库:$database 数据表:$table 数据文件:$data_path] 操作完成!"
return $flag_num
}


#导出数据
exec_export_data ()
{
export_file_name="export_data.csv"
database="${1}"
table="${2}"
export_file_name="${3}"
export_sql="${@:4}"
export_path="$TMP_DIR/`$TOOLS_DIR/date_tools.sh today`/$table"
rm -rf $export_path/*
 logger_info "开始执行导出hive表数据到本地操作:[数据库:${database} 数据表:${table} 导出目录:${export_path}]"
 echo "=========导出sql========="
 echo "${export_sql}"
 hive -e "use ${database};insert overwrite local directory '${export_path}' ROW FORMAT DELIMITED FIELDS TERMINATED BY',' ${export_sql};"
flag_num=$?
 cat $export_path/* > $export_path/$export_file_name
 logger_info "执行导出hive表数据到本地:[数据库:$database 数据表:$table 导出目录:$export_path] 操作完成!"
return $flag_num
}




case $1 in
	"executor_sql_file")
		exec_sql_file "${2}" "${@:3}"
		run_flag=$?
    ;;
	"executor_sql")
		exec_sql "${@:2}"
		
		run_flag=$?
    ;;
	"truncate_table")
 		exec_truncate_table "${2}" "${@:3}"
		run_flag=$?
    ;;
	"drop_table")
		exec_drop_table "${2}" "${@:3}"
		run_flag=$?
    ;;
	"drop_partition")
		exec_drop_partition "${2}" "${3}" "${@:4}"
		run_flag=$?
    ;;
	"create_table")
		exec_create_table "${2}" "${@:3}"
		run_flag=$?
    ;;
	"import_data")
		exec_import_data "${2}" "${3}" "${@:4}"
		run_flag=$?
    ;;
	"export_data")
		exec_export_data "${2}" "${3}" "${@:4}"
		run_flag=$?
    ;;
	*)
		echo "没有匹配的操作"
    ;;
esac


if [ $run_flag -eq 0 ]; then
    exit 0
else
    exit 1
fi

