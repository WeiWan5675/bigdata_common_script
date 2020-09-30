#!/bin/bash


############################################################
#
#       功能描述: 环境初始化脚本
#       修改者: 肖振男
#       修改时间: 2019.1.3
#       版本: v1.0
#
#
#
#############################################################
#step1 创建工作目录
init_dir=$(cd "$(dirname "$0")";pwd)
dirs="tmp logs"
echo "脚本环境初始化" | tee -a "./.init.log"
echo "开始初始化文件夹" | tee -a "./.init.log"
for dir in $dirs
do
	echo "创建${dir}文件夹" | tee -a "./.init.log"
	mkdir $init_dir/$dir -p
done

echo "初始化文件夹完成" | tee -a "./.init.log"

#step2 添加SCRIPT_HOME环境变量
echo "===============================================" | tee -a "./.init.log"
echo "开始添加脚本环境变量" | tee -a "./.init.log"

if [ `grep -c "SCRIPT_HOME_OLD" ~/.bash_profile` -eq '1' ]; then
    if [ `grep -c "SCRIPT_HOME" ~/.bash_profile` -eq '2' ]; then
          echo "环境变量已存在" | tee -a "./.init.log"
          echo "SCRIPT_HOME: ${SCRIPT_HOME}" | tee -a "./.init.log"
          echo "SCRIPT_HOME_OLD: ${SCRIPT_HOME_OLD}" | tee -a "./.init.log"
          echo "请检查环境变量设置"
    else
      echo "export SCRIPT_HOME=$init_dir" >> ~/.bash_profile
      echo "输出环境变量: [ export SCRIPT_HOME=${init_dir} ]" | tee -a "./.init.log"
    fi
fi

source ~/.bash_profile
echo "脚本环境变量添加完成!" | tee -a "./.init.log"

#step3 可执行权限
echo "===============================================" | tee -a "./.init.log"
echo "开始配置可执行文件权限" | tee -a "./.init.log"

chmod +x ./*.sh
echo 'chmod +x ./*.sh' | tee -a "./.init.log"
chmod -R +x ./bin
echo 'chmod -R +x ./bin' | tee -a "./.init.log"
chmod -R +x ./env/*.sh
echo 'chmod -R +x ./env/*.sh' | tee -a "./.init.log"
chmod -R +x ./tools/*.sh
echo 'chmod -R +x ./tools/*.sh' | tee -a "./.init.log"
chmod -R +x ./lib/python/*.py
echo 'chmod -R +x ./lib/*.py' | tee -a "./.init.log"

echo "配置可执行文件权限完成" | tee -a "./.init.log"


echo "初始化结束!" | tee -a "./.init.log"
mv ./.init.log ${SCRIPT_HOME}/logs/init.log



