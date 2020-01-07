#!/bin/bash

source $SCRIPT_HOME/env/common_setting.sh

############################################################
#
#       功能描述: 日期处理脚本 
#       修改者: 肖振男
#       修改时间: 2019.1.7
#       版本: v1.o
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

split="-"
if [ $# -eq 2 ];then
split="$2"
fi

today()
{
td=`date +"%Y$split%m$split%d"`
echo $td
}

next_day()
{
echo `date -d next-day +"%Y$split%m$split%d"`
}

yesterday()
{
echo `date -d last-day +"%Y$split%m$split%d"`
}



case "$1" in
	"today")
		today
	;;
	"yesterday")
		yesterday
	;;
	"tomorrow")
		next_day
	
	;;
	*)
		exit
esac
