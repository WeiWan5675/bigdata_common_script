#!/bin/bash

source $SCRIPT_HOME/env/common_setting.sh

############################################################
#
#       功能描述: 测试其它脚本
#       修改者: 肖振男
#       修改时间: 2019.1.7
#       版本: x
#
#
#
#############################################################

#--------------------------------------------------------------------

#获取时间列表
$TOOLS_DIR/build_date_list.sh 2019-01-01 2019-01-31 "/"


#加载数据库配置文件
$TOOLS_DIR/load_db_conf.sh mysql-test.properties


#日期工具
echo "今天: `$TOOLS_DIR/date_tools.sh today`"
echo "昨天: `$TOOLS_DIR/date_tools.sh yesterday`"
echo "明天; `$TOOLS_DIR/date_tools.sh tomorrow`"

#切割字符串
str="a,b,c"
$TOOLS_DIR/split_str.sh $str ","


#替换字符串
$TOOLS_DIR/replace_str.sh $TMP_DIR/2020-01-07/test_day/export_data.csv "," "\|" 
