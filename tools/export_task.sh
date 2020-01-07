#!/bin/bash

source $SCRIPT_HOME/env/common_setting.sh

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


export mysql_conf_file=mysql-test.properties


$TOOLS_DIR/sqoop_export_tools.sh export_all target_db target_table /home/hive/warehouse/test.db/my_test/ a,b,c,d

$TOOLS_DIR/sqoop_export_tools.sh export_incr target_db target_table source_db source_table day 2019-01-01
