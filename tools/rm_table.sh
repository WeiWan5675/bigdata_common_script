#!/bin/bash

source ${SCRIPT_HOME}/env/common_setting.sh

############################################################
#
#       功能描述: 批量删除表
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
#echo $BIN_DIR	#执行目录
#--------------------------------------------------------------------


tables=""


for table in $tables
do

logger_info "删除${table}表"
#$TOOLS_DIR/hive_tools.sh drop_table easylife_ods $table

done


exit

