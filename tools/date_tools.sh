#!/bin/bash

source ${SCRIPT_HOME}/env/common_setting.sh

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


#--------------------------------------------------------------------

split="-"
if [ $# -eq 2 ];then
split="$2"
fi
#今天
today()
{
td=`date +"%Y$split%m$split%d"`
echo $td
}
#明天
next_day()
{
echo `date -d next-day +"%Y$split%m$split%d"`
}
#昨天
yesterday()
{
echo `date -d last-day +"%Y$split%m$split%d"`
}

#两天之前的日期
anteayer()
{
  echo `date -d "2 day ago" +"%Y$split%m$split%d"`
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
	"anteayer")
	  anteayer
	;;
	*)
		exit
esac
