#!/bin/bash



source ${SCRIPT_HOME}/env/common_setting.sh

######################################################
#
#	功能描述: 加载数据库配置文件
#	修改人: 肖振男
#	修改时间: 2019.1.3
#	版本信息: v1.0
# 使用示例: mongo_server=`$TOOLS_DIR/load_config.sh $CONF_DIR/$PROJECT_ENV/other.properties mongo_server`
#
#####################################################
conf_file="${1}"
key="$2"
value=`cat $conf_file | grep $key | awk -F'=' '{ print $2 }' | sed s/[[:space:]]//g`
echo $value