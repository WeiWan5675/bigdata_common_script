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




#step 1 读取文件
db_file_name="$1"
conf_file=$CONF_DIR/$PROJECT_ENV/$db_file_name

#echo "==================开始读取数据库配置信息=================="
mysql_server=`cat $conf_file | grep db.server | awk -F'=' '{ print $2 }' | sed s/[[:space:]]//g`
mysql_port=`cat $conf_file | grep db.port | awk -F'=' '{ print $2 }' | sed s/[[:space:]]//g`
mysql_db_default=`cat $conf_file | grep db.database | awk -F'=' '{ print $2 }' | sed s/[[:space:]]//g`
mysql_user=`cat $conf_file | grep db.username | awk -F'=' '{ print $2 }' | sed s/[[:space:]]//g`
mysql_pass=`cat $conf_file | grep db.password | awk -F'=' '{ print $2 }' | sed s/[[:space:]]//g`
#链接mysqlurl
MYSQL_URL="jdbc:mysql://$mysql_server:$mysql_port/$mysql_db_default?tinyInt1isBit=false&characterEncoding=UTF-8"
#echo "mysql链接信息: "$MYSQL_URL
#echo "==================读取数据库配置信息结束=================="

echo $MYSQL_URL
echo $mysql_db_default
echo $mysql_user
echo $mysql_pass
echo $mysql_server
echo $mysql_port
