#!/bin/bash



source ${SCRIPT_HOME}/env/common_setting.sh

######################################################
#
#	功能描述: 加载数据库配置文件
#	修改人: 肖振男
#	修改时间: 2019.1.3
#	版本信息: v1.0
#
#
#
#####################################################

# step1 获取数据库连接信息
db_res=`$TOOLS_DIR/load_db_conf.sh $mysql_conf_file`
db_url=`echo $db_res | awk -F "[ ]" '{print $1}'`     
db_name=`echo $db_res | awk -F "[ ]" '{print $2}'`
db_user=`echo $db_res | awk -F "[ ]" '{print $3}'`
db_pass=`echo $db_res | awk -F "[ ]" '{print $4}'`
db_server=`echo $db_res | awk -F "[ ]" '{print $5}'`
db_port=`echo $db_res | awk -F "[ ]" '{print $6}'`

#sql=$"select count(1) from easylife_order;"

exec_sql()
{
sql="${@:2}"
#echo $sql
if [ -n "${1}" ]; then
db_name="${1}"
fi
res=` mysql -h${db_server} -u${db_user} --password=${db_pass} ${db_name} -P${db_port}   <<  EOF
$sql
EOF
`
echo $res
}





case "$1" in
	"exec_sql")
		exec_sql "${2}" "${@:3}"
	;;
	*)
	logger_warn "请输入正确的参数![exec_sql]"
	;;
esac
