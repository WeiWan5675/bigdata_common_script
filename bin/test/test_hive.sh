#!/bin/bash

source $SCRIPT_HOME/env/common_setting.sh

############################################################
#
#       功能描述: 测试hive脚本
#       修改者: 肖振男
#       修改时间: 2019.1.7
#       版本: x
#
#
#
#############################################################


#文件sql执行
#$TOOLS_DIR/hive_tools.sh executor_sql_file "$CONF_DIR/sql_file/create_sql/ods_test.sql"
#$TOOLS_DIR/hive_tools.sh executor_sql_file "$CONF_DIR/sql_file/create_sql/test_day.sql"
#$TOOLS_DIR/hive_tools.sh executor_sql_file "$CONF_DIR/sql_file/create_sql/test_drop.sql"
#传入sql执行
#sql1="show databases;show tables;use test_common_script;show tables;"
#$TOOLS_DIR/hive_tools.sh executor_sql $sql1

#导入数据
#$TOOLS_DIR/hive_tools.sh import_data test_common_script ods_test "file:$TMP_DIR/data.csv"

#sql2="set hive.exec.dynamic.partition.mode=nonstrict;insert into table test_common_script.test_day partition(day) select *,substr(create_date,1,10) as day from test_common_script.ods_test"
#$TOOLS_DIR/hive_tools.sh executor_sql $sql2

#sql3="set hive.exec.dynamic.partition.mode=nonstrict;insert into table test_common_script.test_drop partition(day) select *,substr(create_date,1,10) as day from test_common_script.ods_test"
#$TOOLS_DIR/hive_tools.sh executor_sql $sql3

#truncate表
#$TOOLS_DIR/hive_tools.sh truncate_table test_common_script test_drop

#删除表
#$TOOLS_DIR/hive_tools.sh drop_table test_common_script "test_drop_table"
#删除分区
#$TOOLS_DIR/hive_tools.sh drop_partition test_common_script "test_drop" "day=2019-12-05"

#$TOOLS_DIR/hive_tools.sh import_data test_common_script ods_test "file:$TMP_DIR/data2.csv"

#$TOOLS_DIR/hive_tools.sh export_data test_common_script test_day export_data.csv "select * from test_day where day = '2019-12-01'"
