#!/bin/bash


########################################################
#
#	功能描述:通用设置脚本                              
#	修改者:肖振男                                      
#	修改时间:2020.1.2                                  
#	版本:v1.0                                          	
#                                                      
#	                                                                                         
#                                                      
########################################################


source /etc/profile
source /home/easylife/.bash_profile
#定义环境相关
export SCRIPT_HOME=${SCRIPT_HOME}
#临时目录
export TMP_DIR=${SCRIPT_HOME}/tmp
##日志目录
export LOG_DIR=${SCRIPT_HOME}/logs
##工具目录
export TOOLS_DIR=${SCRIPT_HOME}/tools
##配置目录
export CONF_DIR=${SCRIPT_HOME}/conf
##环境目录
export ENV_DIR=${SCRIPT_HOME}/env
##外部依赖目录
export LIB_DIR=${SCRIPT_HOME}/lib
##执行目录
export BIN_DIR=${SCRIPT_HOME}/bin
##sql文件目录
export SQL_DIR=$CONF_DIR/sql

############################################################
#当前生效环境
export PROJECT_ENV=pre

#info日志方法
logger_info ()
{
	echo -e `date +%Y-%m-%d\ %H:%M:%S` : "INFO [${0##*/}] : ${1}" | tee -a "$LOG_DIR/${0##*/}-info.log"
	return $?

}

#err日志方法
logger_err ()
{
	echo -e `date +%Y-%m-%d\ %H:%M:%S` : "ERROR [${0##*/}] : ${1}" | tee -a "$LOG_DIR/${0##*/}-error.log"
	return $?
}

#警告日志方法
logger_warn()
{
	echo -e `date +%Y-%m-%d\ %H:%M:%S` : "WARN [${0##*/}] : ${1}" | tee -a "$LOG_DIR/${0##*/}-warn.log"
	return $?
}
