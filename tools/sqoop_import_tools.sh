#!/bin/bash

source ${SCRIPT_HOME}/env/common_setting.sh

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

fields_split_by="\001"
lines_split_by="\n"
null_str=""
map_num=1
incremental_mode="append" #TODO 需要注意这里有版本1.46之后问题 包括--hive-import 等参数
bindir=$TMP_DIR/sqoop/import
outdir=$TMP_DIR/sqoop/import

#全量导入(两边表结构完全一致)
import_all()
{
logger_info "全量导入"
target_db="$1"
target_table="$2"
source_db="$3"
source_table="$4"

logger_info "清空source表: [${target_db}"".""${target_table}]"
$TOOLS_DIR/hive_tools.sh truncate_table $target_db $target_table

db_url="jdbc:mysql://$db_server:$db_port/$source_db?tinyInt1isBit=false&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull"
logger_info "SqoopImport[全量]任务信息:"
logger_info "-------------------------------------------------------------------------------"
logger_info "target_db: [$target_db]"
logger_info "target_table: [$target_table]"
logger_info "source_db: [$source_db]"
logger_info "source_table: [$source_table]"
sqoop import  \
--connect "$db_url" \
--username "$db_user" \
--password "$db_pass" \
--table "$source_table" \
--fields-terminated-by "$fields_split_by" \
--lines-terminated-by "$lines_split_by" \
--hive-database "$target_db" \
--hive-table "$target_table" \
--hive-import \
--hive-overwrite \
--hive-drop-import-delims \
--delete-target-dir \
--null-string "$null_str" \
--null-non-string "$null_str" \
--bindir "${bindir}/${target_db}_${target_table}" \
--outdir "${outdir}/${target_db}_${target_table}" \
-m $map_num
}

#全量导入(执行sql导入)
import_query()
{
target_db="$1"
target_table="$2"
source_db="$3"
source_table="$4"
query_sql="${@:5}"

logger_info "清空source表: [${target_db}"".""${target_table}]"
$TOOLS_DIR/hive_tools.sh truncate_table $target_db $target_table

db_url="jdbc:mysql://$db_server:$db_port/$source_db?tinyInt1isBit=false&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull"
target_dir="/tmp/hive/$target_table""_`$TOOLS_DIR/date_tools.sh today`"
query_sql=`echo "$query_sql" | sed 's/;//g'`
if [[ $query_sql =~ "where" ]]
then
    query_sql=$query_sql" and $""CONDITIONS"
else
    query_sql=$query_sql" where $""CONDITIONS"
fi
logger_info "SqoopImport[执行SQL导入]任务信息: "
logger_info "----------------------------------------------------------------------------"
logger_info "SQL: [$query_sql]"
logger_info "target_db: [$target_db]"
logger_info "target_table: [$target_table]"
logger_info "source_db: [$source_db]"
logger_info "source_table: [$source_table]"

sqoop import  \
--connect "$db_url" \
--username "$db_user" \
--password "$db_pass" \
--query "$query_sql" \
--fields-terminated-by "$fields_split_by" \
--lines-terminated-by "$lines_split_by" \
--hive-database "$target_db" \
--hive-table "$target_table" \
--target-dir "$target_dir" \
--null-string "$null_str" \
--null-non-string "$null_str" \
--hive-import \
--hive-overwrite \
--hive-drop-import-delims \
--delete-target-dir \
--bindir "${bindir}/${target_db}_${target_table}" \
--outdir "${outdir}/${target_db}_${target_table}" \
-m $map_num


}

import_incr_job()
{

logger_info "增量导入"
target_db="${1}"
target_table="${2}"
source_db="${3}"
source_table="${4}"
check_column="${5}"
last_value="${6}"

logger_info "清空source表: [${target_db}"".""${target_table}]"
$TOOLS_DIR/hive_tools.sh truncate_table $target_db $target_table

db_url="jdbc:mysql://$db_server:$db_port/$source_db?tinyInt1isBit=false&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull"
job_flag=0

job_name="$target_db"":$target_table""+++$source_db"":$source_table"
target_dir="/user/hive/warehouse/$target_db"".db/$target_table"
logger_info "SqoopImport[增量]任务信息:"
logger_info "-----------------------------------------------------------------------"
logger_info "source_db: [$source_db]"
logger_info "source_table: [$source_table]"
logger_info "target_db: [$target_db]"
logger_info "target_table: [$target_table]"
logger_info "job_name: [$job_name]"
for job  in `sqoop job --list`
do
    if [ "$job" == "${job_name}" ];then
	logger_info "SqoopJob:[$job_name]已经存在!直接执行"
        job_flag=1
    fi
done

if [ $job_flag == 0 ];then
logger_info "开始创建SqoopJob,JobName:[$job_name]"
sqoop job --create "$job_name" \
-- import \
--connect "$db_url" \
--username "$db_user" \
--password "$db_pass" \
--target-dir "$target_dir" \
--table "$source_table" \
--incremental "$incremental_mode" \
--check-column "$check_column" \
--last-value "$last_value" \
--fields-terminated-by "$fields_split_by" \
--lines-terminated-by "$lines_split_by" \
--null-string "$null_str" \
--null-non-string "$null_str" \
--hive-drop-import-delims \
--bindir "${bindir}/${target_db}_${target_table}" \
--outdir "${outdir}/${target_db}_${target_table}" \
-m 1
if [ $? -eq 0 ];then
job_flag=1
fi
fi

if [ $job_flag == 1 ];then
logger_info "SqoopJob:[$job_name]开始执行!"
sqoop job --exec $job_name
else
logger_info "创建SqoopJob失败,请检查日志"
fi


}


import_incr()
{
logger_info "增量导入"
target_db="${1}"
target_table="${2}"
source_db="${3}"
source_table="${4}"
check_column="${5}"
last_value="${6}"

logger_info "清空source表: [${target_db}"".""${target_table}]"
$TOOLS_DIR/hive_tools.sh truncate_table $target_db $target_table

db_url="jdbc:mysql://$db_server:$db_port/$source_db?tinyInt1isBit=false&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull"

target_dir="/user/hive/warehouse/$target_db"".db/$target_table"
logger_info "SqoopImport[增量]任务信息:"
logger_info "-----------------------------------------------------------------------"
logger_info "source_db: [$source_db]"
logger_info "source_table: [$source_table]"
logger_info "target_db: [$target_db]"
logger_info "target_table: [$target_table]"
logger_info "last_value: [$last_value]"
sqoop import \
--connect "$db_url" \
--username "$db_user" \
--password "$db_pass" \
--target-dir "$target_dir" \
--table "$source_table" \
--incremental "$incremental_mode" \
--check-column "$check_column" \
--last-value "$last_value" \
--fields-terminated-by "$fields_split_by" \
--lines-terminated-by "$lines_split_by" \
--null-string "$null_str" \
--null-non-string "$null_str" \
--hive-drop-import-delims \
--bindir "${bindir}/${target_db}_${target_table}" \
--outdir "${outdir}/${target_db}_${target_table}" \
-m 1
}




case "$1" in
	"import_all")
		import_all "${2}" "${3}" "${4}" "${5}"
	;;
	"import_incr_job")
		import_incr_job "${2}" "${3}" "${4}" "${5}" "${6}" "${7}"
	;;
	"import_incr")
		import_incr "${2}" "${3}" "${4}" "${5}" "${6}" "${7}"
	;;
	"import_query_all")
		import_query "${2}" "${3}" "${4}" "${5}" "${@:6}"
	;;
	*)
	logger_warn "请输入正确的参数![import_all|import_incr_job|import_incr|import_query]"
	;;
esac