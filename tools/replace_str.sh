#!/bin/bash

source ${SCRIPT_HOME}/env/common_setting.sh

############################################################
#
#       功能描述: 
#       修改者: 
#       修改时间: 
#       版本: 
#
#
#
#############################################################


#这里运行可以看到脚本环境对应的dir
#echo $TOOLS_DIR	#工具目录
#echo $ENV_DIR	#环境目录
#echo $CONF_DIR	#配置目录
#echo $LIB_DIR	#依赖目录
#echo $TMP_DIR	#临时目录
#echo $LOG_DIR	#日志目录

#--------------------------------------------------------------------
file="$1"
old_str="$2"
new_str="$3"
new_file="$4"


if [ -f $file ];then
	if [ $# -lt 4 ];then
		sed -i "s%${old_str}%${new_str}%g" $file
	else
		sed -e "s%${old_str}%${new_str}%g" $file >> $new_file
	fi
else

res=`echo "$1" | sed "s%${old_str}%${new_str}%g"`
echo $res


fi

exit 0
