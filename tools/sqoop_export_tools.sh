#!/bin/bash

source ${SCRIPT_HOME}/env/common_setting.sh

############################################################
#
#       功能描述: sqoop导出工具
#       修改者: 肖振男
#       修改时间: 2019.1.3
#       版本: v1.0
#
#
#
#############################################################

# step1 获取数据库连接信息
db_res=`$TOOLS_DIR/load_db_conf.sh $mysql_conf_file`
db_url=`echo $db_res | awk -F "[ ]" '{print $1}'`	#这里数据库连接提供一个默认值 工程初始化时在配置文件中配置导出的目标mysql
db_name=`echo $db_res | awk -F "[ ]" '{print $2}'`
db_user=`echo $db_res | awk -F "[ ]" '{print $3}'`
db_pass=`echo $db_res | awk -F "[ ]" '{print $4}'`
db_server=`echo $db_res | awk -F "[ ]" '{print $5}'`
db_port=`echo $db_res | awk -F "[ ]" '{print $6}'`

fields_split_by="\001"
lines_split_by="\n"
null_str=""
staging_table_suffix="_tmp"
map_num=1

bindir=$TMP_DIR/sqoop/export
outdir=$TMP_DIR/sqoop/export

#全量导出
export_all_file ()
{
logger_info "全量导出"
logger_info "传入export_all方法中的参数个数:$#"
target_db="$1"
target_table="$2"
export_data_dir="$3"
columns="$4"
logger_info "target_db: [$target_db] target_table: [$target_table] export_data_dir: [$export_data_dir] columns: [$columns]"

if [ $# -ne 4 ];then
logger_err "导出失败! 缺少必要参数[target_db][target_table][export_data_dir][columns]!"
exit 1
fi

db_url="jdbc:mysql://$db_server:$db_port/$target_db?tinyInt1isBit=false&characterEncoding=UTF-8"
logger_info "数据库url: "$db_url
# step2 导出
sqoop export \
--connect "${db_url}" \
--username "${db_user}" \
--password "${db_pass}" \
--table "${target_table}" \
--export-dir "${export_data_dir}" \
--columns "${columns}" \
--input-null-non-string "${null_str}" \
--fields-terminated-by "${fields_split_by}" \
--input-lines-terminated-by "${lines_split_by}"  \
--input-null-string "${null_str}" \
--staging-table "${target_table}${staging_table_suffix}" \
--clear-staging-table \
--bindir "${bindir}/${target_db}_${target_table}" \
--outdir "${outdir}/${target_db}_${target_table}" \
-m $map_num


}



#增量导出
export_incr ()
{
logger_info "增量导出"
logger_info "传入incr方法中参数个数:$#"
target_db="$1"
target_table="$2"
source_db="$3"
source_table="$4"
partition_key="$5"
partition_value="$6"
logger_info "source_db: [$source_db] source_table: [$source_table] target_db: [$target_db] target_table: [$target_table] partition_key: [$partition_key] partition_valie: [$partition_value]"
if [ $# -ne 6 ];then
logger_err "导出失败! 缺少必要参数[source_db][source_table][target_db][target_table][partition_key][partition_value]"
exit 1
fi

db_url="jdbc:mysql://$db_server:$db_port/$target_db?tinyInt1isBit=false&characterEncoding=UTF-8"
logger_info "数据库url: "$db_url
sqoop export \
--connect "${db_url}" \
--username "${db_user}" \
--password "${db_pass}" \
--table "${target_table}" \
--hcatalog-database "${source_db}" \
--hcatalog-table "${source_table}" \
--hcatalog-partition-keys "${partition_key}" \
--hcatalog-partition-values "${partition_value}" \
--input-fields-terminated-by "'${fields_split_by}'" \
--input-lines-terminated-by "'${lines_split_by}'" \
--input-null-string "'${null_str}'" \
--input-null-non-string "'${null_str}'" \
--staging-table "${target_table}${staging_table_suffix}" \
--clear-staging-table \
--bindir "${bindir}/${target_db}_${target_table}" \
--outdir "${outdir}/${target_db}_${target_table}" \
-m $map_num

}

#================================================================
#全量导出
export_all ()
{
logger_info "全量导出"
logger_info "传入export_all方法中的参数个数:$#"
target_db="$1"
target_table="$2"
source_db="$3"
source_table="$4"
#columns="$4"
logger_info "target_db: [$target_db] target_table: [$target_table] source_db: [$source_db] source_table: [$source_table]"

if [ $# -ne 4 ];then
logger_err "导出失败! 缺少必要参数[target_db][target_table][export_data_dir[columns]!"
exit 1
fi

db_url="jdbc:mysql://$db_server:$db_port/$target_db?tinyInt1isBit=false&characterEncoding=UTF-8"
logger_info "数据库url: "$db_url
# step2 导出
sqoop export \
--connect "${db_url}" \
--username "${db_user}" \
--password "${db_pass}" \
--table "${target_table}" \
--hcatalog-database "${source_db}" \
--hcatalog-table "${source_table}" \
--input-null-non-string "${null_str}" \
--fields-terminated-by "${fields_split_by}" \
--input-lines-terminated-by "${lines_split_by}"  \
--input-null-string "${null_str}" \
--staging-table "${target_table}${staging_table_suffix}" \
--clear-staging-table \
--bindir "${bindir}/${target_db}_${target_table}" \
--outdir "${outdir}/${target_db}_${target_table}" \
-m $map_num


}





case "$1" in
	"export_all")
		export_all "$2" "$3" "$4" "$5"
	;;
	"export_incr")
		export_incr "$2" "$3" "$4" "$5" "$6" "$7"
	;;
	"export_all_file")
		export_all_file "$2" "$3" "$4" "$5"
	;;
	*)
	echo "导出方法错误!请传入正确参数"
esac


exit 0
