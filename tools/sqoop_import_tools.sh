#!/bin/bash

source $SCRIPT_HOME/env/common_setting.sh

############################################################
#
#       功能描述: sqoop导入工具
#       修改者: 肖振男
#       修改时间: 2019.1.3
#       版本: v1.0
#
#
#
#############################################################


# step1 获取数据库连接信息
db_res=`$TOOLS_DIR/load_db_conf.sh $mysql_conf_file`
db_url=`echo $db_res | awk -F "[ ]" '{print $1}'`       #这里数据库连接提供一个默认值 工程初始化时在配置文件中配置导出的目标mysql
db_name=`echo $db_res | awk -F "[ ]" '{print $2}'`
db_user=`echo $db_res | awk -F "[ ]" '{print $3}'`
db_pass=`echo $db_res | awk -F "[ ]" '{print $4}'`
db_server=`echo $db_res | awk -F "[ ]" '{print $5}'`
db_port=`echo $db_res | awk -F "[ ]" '{print $6}'`

fields_split_by="','"
lines_split_by="'\t'"
null_str="'\\N'"

incremental_mode="lastmodifiedi"

import_all()
{
logger_info "全量导入"
source_db="$1"
source_table="$2"
target_db="$3"
target_table="$4"
query_sql="${@:5}"

sqoop_cmd="sqoop import --connect $db_url --username $db_user --password $db_pass --table $source_table --hive-import --hive-table $target_table --query $query_sql --hive-drop-import-delims --incremental $incremental_mode --num-mappers $mapper_num --direct --fields-terminated-by $fields_split_by"
}



import_incr()
{
logger_info "增量导入"
source_table="${1}"
source_db="${2}"
target_db="${3}"
target_table="${4}"
check_column="${5}"
last_value="${6}"

db_url="jdbc:mysql://$db_server:$db_port/$source_db?tinyInt1isBit=false&characterEncoding=UTF-8"

sqoop_cmd="sqoop import --connect ${db_url} --username ${db_user} --password ${db_pass} --table ${source_table} --hive-import --hive-database ${target_db} --hive-table ${target_table} --fields-terminated-by ${fields_split_by} --lines-terminated-by ${lines_split_by} --hive-drop-import-delims --null-string ${null_str} --null-non-string ${null_str} --incremental ${incremental_mode} --check-column ${check_column} --last-value ${last_value}"
echo $sqoop_cmd
$sqoop_cmd
}










case "$1" in
	"import_all")
		import_all
	;;
	"import_incr")
		import_incr "${2}" "${3}" "${4}" "${5}" "${6}" "${7}"
	;;
	*)
	logger_warn "请输入正确的参数![import_all|import_incr]"
	;;
esac
