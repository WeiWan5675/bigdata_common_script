#!/bin/bash



#step1 创建工作目录
init_dir=$(cd "$(dirname "$0")";pwd)
dirs="tmp logs"
echo "脚本环境初始化" >> ./.init.log
echo "开始初始化文件夹" >> ./.init.log
for dir in $dirs
do
	echo "创建${dir}文件夹" >> ./.init.log
	mkdir $init_dir/$dir -p
done

echo "初始化文件夹完成" >> ./.init.log


echo "===============================================" >> ./.init.log
echo "开始添加脚本环境变量" >> ./.init.log

if [ `grep -c "SCRIPT_HOME" ~/.bash_profile` -eq '1' ]; then

    echo "环境变量已存在!请检查!" >> ./.init.log
else
    echo "export SCRIPT_HOME=$init_dir" >> ~/.bash_profile
fi
source ~/.bash_profile
echo "脚本环境变量添加完成!" >> ./.init.log
echo "初始化结束!" >> ./.init.log
mv ./.init.log $SCRIPT_HOME/logs/init.log
#step2 添加SCRIPT_HOME环境变量


